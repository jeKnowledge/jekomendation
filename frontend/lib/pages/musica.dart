// ignore_for_file: prefer_const_constructors_in_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/classes/Suggestion.dart';


class MusicsPage extends StatefulWidget {
  MusicsPage({Key? key}) : super(key: key);

  @override
  _MusicsPageState createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage> {
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
        (await client.get(Uri.parse('http://127.0.0.1:8000/jekomandations?type=Musica')))
            .body);
    response.forEach((element) {
      if (element['category'] == 'Musica') {
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
        title: Text('Musica'),
      ),
      body: ListView.builder(
        itemCount: suggestion.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(suggestion[index].jekomandation),
            subtitle: Text(suggestion[index].about),
          );
        },
      ),
    );
  }
}
