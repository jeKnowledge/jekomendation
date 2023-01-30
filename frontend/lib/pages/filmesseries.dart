// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/classes/Suggestion.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';


class FilmsPage extends StatefulWidget {
  FilmsPage({Key? key}) : super(key: key);

  @override
  _FilmsPageState createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  http.Client client = http.Client();
  List<Jekomandation> suggestion = [];

  @override
  void initState() {
    _retrieveFilmSuggestions();
    super.initState();
  }

  Future<void> _retrieveFilmSuggestions() async {
    suggestion = [];

    List response = json.decode(
        (await client.get(Uri.parse('http://127.0.0.1:8000/jekomandations')))
            .body);
    response.forEach((element) {
      if (element['category'] == 'Filmes/Series') {
        suggestion.add(Jekomandation.fromMap(element));
      }
    });
    suggestion = suggestion.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes e Séries'),
      ),
      backgroundColor: Colors.blue,
      body: RefreshIndicator(
          onRefresh: _retrieveFilmSuggestions,
          child: ListView.separated(
            padding: const EdgeInsets.all(2),
            itemCount: suggestion.length,
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
                        title: Text(suggestion[index].jekomandation),
                        subtitle: Row(
                          children: [
                            Text(suggestion[index].category),
                            const Icon(
                              Icons.star,
                              size: 15,
                            ),
                            if(suggestion[index].rating != -1)
                              Text(suggestion[index].rating.toString()),
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
                                'jekomandationId': '${suggestion[index].id}'
                              }).toString());
                        },
                      ),
                     Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Align(
                        alignment: Alignment.topLeft, child: Text(suggestion[index].about)),
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
                              launchUrl(Uri.parse(suggestion[index].link));
                            },
                            child: Text(
                              suggestion[index].link.length > 10
                                  ? '${suggestion[index].link.substring(0, 28)}...'
                                  : suggestion[index].link,
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
                          suggestion[index].user[1],
                        )),
                  ]),
                ),
                    ],
                  ));
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
    );
  }
}
