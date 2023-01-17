import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/classes/comments_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';


import '../classes/Suggestion.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({
    Key? key,
    required this.jekomandationId,
  }) : super(key: key);

  final String jekomandationId;

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "1028574994519-m4jie21dv7jjg5ae4skkd57qr60erkbh.apps.googleusercontent.com",
  );

  late String currentUser;
  late TextEditingController _comment;

  @override
  void initState() {
    super.initState();
    googleSignIn.signInSilently();
    getToken();
    _comment = TextEditingController();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          http.get(Uri.parse(
              'http://127.0.0.1:8000/jekomandation/${widget.jekomandationId}/')),
          http.get(Uri.parse(
              'http://127.0.0.1:8000/comment/${widget.jekomandationId}/'))
        ]),
        builder: (context, AsyncSnapshot<List<Response>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: (() {
                        context.go('/');
                      })),
                ),
                backgroundColor: Colors.blue,
                body: Column(
                  children: [
                    showSuggestion(context, snapshot.data![0].body),
                    const Text("Comments: "),
                    addComments(context),
                    if (snapshot.data![1].statusCode == 200)
                      Expanded(
                          child: showComments(context, snapshot.data![1].body))
                    else
                      showComments(context, null)
                  ],
                ),
              );
            } else {
              //Show erro page
              return Scaffold(
                appBar: AppBar(title: const Text("ERROR")),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget showSuggestion(BuildContext context, snapshot) {
    final post = Jekomandation.fromJson(snapshot);
    return Column(
      children: [
        Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(post.jekomandation),
                  subtitle: Text(post.category),
                  shape: BorderDirectional(
                    bottom: BorderSide(
                        width: 2.0, color: Colors.lightBlue.shade900),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                    child: Column(children: [

                            Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(post.about)),
                            const SizedBox(height: 15,),
                            Row(
                              children: [
                                const Icon(Icons.link,
                                size: 15,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          post.link));
                                    },
                                    child: Text(
                                      post.link.length > 10
                                          ? '${post.link.substring(0, 28)}...'
                                          : post.link,
                                      style: TextStyle(
                                          color: Colors.blue[700],
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  post.user,
                                )),
                    ]),
                  ),
              ],
            )),
        RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            submitRating(rating);
          },
        )
      ],
    );
  }

  Widget addComments(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
            controller: _comment,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Add a comment...',
            ),
            onSubmitted: (value) {
              submitComment(value);
            },
          ),
        ),
      ),
    );
  }

  Widget showComments(BuildContext context, snapshot) {
    List<Comments> comments = [];
    

    if (snapshot != null) {
      var commentsJson = json.decode(snapshot);
      commentsJson.forEach((element) {
        comments.add(Comments.fromMap(element));
      });
    }

    return ListView.separated(
        padding: const EdgeInsets.all(2),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: comments.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(comments[index].user),
                  shape: BorderDirectional(
                    bottom: BorderSide(
                        width: 1.0, color: Colors.lightBlue.shade900),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                      child: Column(children: [

                        Padding(
                          padding: const EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(comments[index].body)),
                        ),
                        const SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1.0, 2.0, 1.0, 2.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child:Text(comments[index].created)),
                        ),

                      ]),
                    ),
              ],
            ),
          );
        });
  }

  void getToken() async {
    if (await googleSignIn.isSignedIn()) {
      final result = await googleSignIn.signInSilently();
      final ggAuth = await result!.authentication;
      getUser(ggAuth);
    }
  }

  Future<void> getUser(ggAuth) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': ggAuth.idToken,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      currentUser = data['user']['id'].toString();
    }
  }

  void submitComment(String value) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/comment/${widget.jekomandationId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'body': value,
        'suggestion': widget.jekomandationId,
        'user': currentUser,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  void submitRating(double value) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/ratings/${widget.jekomandationId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'review': value.toString(),
        'suggestion': widget.jekomandationId,
        'user': currentUser,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {});
    }
  }
}
