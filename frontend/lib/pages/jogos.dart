// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/classes/Suggestion.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

class JogosPage extends StatefulWidget {
  JogosPage({Key? key}) : super(key: key);

  @override
  _JogosPageState createState() => _JogosPageState();
}

class _JogosPageState extends State<JogosPage> {
  
  http.Client client = http.Client();
  List<Jekomandation> suggestion = [];
  var currentUser = '';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        getUser(),
        http.get(Uri.parse('http://127.0.0.1:8000/jekomandations'),
            headers: {'Content-Type': 'application/json'}),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data![0]) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blue,
                    title: const Text("Filmes e Séries"),
                    actions: [
                      IconButton(
                          onPressed: () {
                            context.push('/filters');
                          },
                          icon: const Icon(Icons.list_rounded)),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                        ),
                        onPressed: logout,
                      )
                    ],
                  ),
                  backgroundColor: Colors.blue,
                  body: showPosts(utf8.decode(snapshot.data![1].bodyBytes)),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: (() {
                      context.push('/suggestion/create');
                    }),
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ));
            }
            return const LoginPage();
          } else {
            return const Text("ERROR");
          }
        } else {
          // ignore: prefer_const_constructors
          return Center(
              child: const CircularProgressIndicator(
            color: Colors.blue,
          ));
        }
      },
    );
  }

  Widget showPosts(posts) {
    List<Jekomandation> suggestions = [];

    var postJson = json.decode(posts);
    postJson.forEach((element) {
      if(element['category'] == 'Jogos') {
        suggestions.add(Jekomandation.fromMap(element));
      }
        
    });

    return Container(
      alignment: Alignment.topCenter,
      child: ListView.separated(
        padding: const EdgeInsets.all(2),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Center(
            child: SizedBox(
              width: 500,
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(suggestions[index].jekomandation),
                      subtitle: Row(
                        children: [
                          Text(suggestions[index].category),
                          const Icon(
                            Icons.star,
                            size: 15,
                          ),
                          if (suggestions[index].rating != 0)
                            Text(suggestions[index].rating.toString()),
                        ],
                      ),
                      shape: BorderDirectional(
                        bottom: BorderSide(
                            width: 2.0, color: Colors.lightBlue.shade900),
                      ),
                      onTap: () {
                        context.go(Uri(
                            path: '/jekomandation/',
                            queryParameters: {
                              'jekomandationId': '${suggestions[index].id}'
                            }).toString());
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              suggestions[index].about.length > 28
                                  ? '${suggestions[index].about.substring(0, 28)}...'
                                  : suggestions[index].about,
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.link,
                              size: 15,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(suggestions[index].link));
                                },
                                child: Text(
                                  suggestions[index].link.length > 28
                                      ? '${suggestions[index].link.substring(0, 28)}...'
                                      : suggestions[index].link,
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
                            child: TextButton(
                              child: Text(suggestions[index].user),
                              onPressed: () {
                                context.go(Uri(
                                    path: '/user-page/',
                                    queryParameters: {
                                      'userID': '${suggestions[index].userID}'
                                    }).toString());
                              },
                            )),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Center(child: SizedBox(width: 500, child: Divider())),
      ),
    );
  }

  Future<bool> getUser() async {
    var user = await googleSignIn.signInSilently();
    final ggAuth = await user!.authentication;

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': ggAuth.idToken.toString(),
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      currentUser = data['user']['id'].toString();
      return true;
    }
    return false;
  }

  void logout() async {
    await googleSignIn.signOut();
    initState();
  }

}
