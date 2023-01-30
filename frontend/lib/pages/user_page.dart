import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/classes/Suggestion.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../classes/user_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          http.get(Uri.parse(
              'http://127.0.0.1:8000/user_jekomandations/${widget.userID}/')),
          http.get(
              Uri.parse('http://127.0.0.1:8000/user_info/${widget.userID}/')),
        ]),
        builder: (context, AsyncSnapshot<List<Response>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blue,
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: (() {
                          context.go('/');
                        })),
                  ),
                  backgroundColor: Colors.blue,
                  body: Column(
                    children: [
                      showUserInfo(context, snapshot.data![1].body),
                      Expanded(child: showUserPosts(context, snapshot.data![0]))
                    ],
                  ));
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

  Widget showUserInfo(BuildContext context, snapshot) {
    final user = User.fromJson(snapshot);
    return Center(
      child: SizedBox(
        width: 500,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Icon(
                Icons.person,
                size: 100.0,
              ),
              Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(child: Text(user.username)),
                          subtitle: Column(
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              Text(user.email),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(user.userReview.toString()),
                                  const Icon(
                                    Icons.star,
                                    size: 13,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  } //End User Info Widget

  Widget showUserPosts(context, snapshot) {
    List posts = json.decode(snapshot.body);
    return ListView.separated(
      padding: const EdgeInsets.all(2),
      itemCount: posts.length,
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
                    title: Text(posts[index]['jekomandation']),
                    subtitle: Row(
                      children: [
                        Text(posts[index]['category']),
                        const Icon(
                          Icons.star,
                          size: 15,
                        ),
                        if (posts[index]['rating'] != 0)
                          Text(posts[index]['rating'].toString()),
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
                            'jekomandationId': '${posts[index]['id']}'
                          }).toString());
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              posts[index]["about"].length > 28
                                  ? '${posts[index]['about'].substring(0, 28)}...'
                                  : posts[index]['about'],
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
                                launchUrl(
                                    Uri.parse(posts[index]['link']));
                              },
                              child: Text(
                                posts[index]['link'].length > 28
                                    ? '${posts[index]['link'].substring(0, 28)}...'
                                    : posts[index]['link'],
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
                        child: Text(posts[index]['user']),
                      ),
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
    );
  }
}
