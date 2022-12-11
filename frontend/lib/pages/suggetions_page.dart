import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/classes/comments_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    googleSignIn.signInSilently();
    super.initState();
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
                  title: const Text("TESTE"),
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
                    if(snapshot.data![1].statusCode == 200)
                      showComments(context, snapshot.data![1].body)
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: 120.0,
                    child: Column(children: [
                      Text(post.about),
                      const Expanded(child: SizedBox()),
                      Text(post.user),
                    ]),
                  ),
                )
              ],
            )),
      ],
    );
  }

  Widget showComments(BuildContext context, snapshot) {
    List<Comments> comments = [];
    
    if(snapshot != null){
      var commentsJson = json.decode(snapshot);
      commentsJson.forEach((element) {
        comments.add(Comments.fromMap(element));
      });
    }
    

    return Column(
      children: [
        const Text("Comments: "),
        ListView.separated(
            padding: const EdgeInsets.all(2),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
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
                      title: Text(comments[index].title),
                      subtitle: Text(comments[index].user),
                      shape: BorderDirectional(
                        bottom: BorderSide(
                            width: 1.0, color: Colors.lightBlue.shade900),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        height: 40.0,
                        child: Column(children: [
                          Text(comments[index].body),
                          const Expanded(child: SizedBox()),
                          Text(comments[index].created),
                        ]),
                      ),
                    )
                  ],
                ),
              );
            }),
      ],
    );
  }
}
