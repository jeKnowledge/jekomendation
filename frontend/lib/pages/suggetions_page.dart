import 'dart:convert';

import 'package:flutter/material.dart';
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

// Future<Jekomandation> _retrieveSuggestion() async {
//   var response = json.decode(
//       (await client.get(Uri.parse('http://127.0.0.1:8000/jekomandation/6/')))
//           .body);
//   Jekomandation result;
//   result = Jekomandation.fromJson(jsonDecode(response));
//   return result;
// }

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
        future: http.get(Uri.parse(
            'http://127.0.0.1:8000/jekomandation/${widget.jekomandationId}/')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return showSuggestion(context, snapshot);
            } else {
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
    final post = Jekomandation.fromJson(snapshot.data!.body);
    return Scaffold(
        appBar: AppBar(
          title: Text(post.category.toString()),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (() {
                context.go('/');
              })),
        ),
        backgroundColor: Colors.blue,
        body: Column(
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
                        height: 200.0,
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
        ));
  }
}
