import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class makeSuggestion extends StatefulWidget {
  const makeSuggestion({super.key});

  @override
  State<makeSuggestion> createState() => _makeSuggestionState();
}

class _makeSuggestionState extends State<makeSuggestion> {
  GoogleSignIn googleSignIn = GoogleSignIn(
      // clientId:
      //     "1028574994519-m4jie21dv7jjg5ae4skkd57qr60erkbh.apps.googleusercontent.com",
      );

  Future<void> printar() async {
    print( await googleSignIn.isSignedIn());
  }

  final items = ['Filmes/Series', 'Livro', 'Musica', 'Jogo', 'Viagens'];
  String? value = 'Filmes/Series';
  String category = 'Filmes/Series';
  late String currentUser;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _link = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _about = TextEditingController();

  @override
  void initState() {
    printar();
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('New suggestion'),
        ),
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: value,
                        items: items.map(buildMenuItem).toList(),
                        onChanged: ((value) => setState(() {
                              this.value = value;
                              category = value!;
                            }))),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'Name*',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextFormField(
                    autocorrect: false,
                    controller: _name,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.arrow_right_alt_rounded),
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your jekomandation',
                        focusColor: Colors.red),
                    showCursor: true,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please give us the name of your jekmandation';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'Link*',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextFormField(
                    autocorrect: false,
                    controller: _link,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.link),
                        border: UnderlineInputBorder(),
                        labelText: 'Enter a link for your jekomandation',
                        focusColor: Colors.white),
                    showCursor: true,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a link';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'About*',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextFormField(
                    autocorrect: false,
                    controller: _about,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.link),
                        border: UnderlineInputBorder(),
                        labelText: 'Tell us about yout jekomandation',
                        focusColor: Colors.black),
                    showCursor: true,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please give us details about your jekmandation';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        submitJekomandation();
                        context.go('/');
                      }
                    },
                    child: const Text('Submit'),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));

  Future<void> submitJekomandation() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/jekomandations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'jekomandation': _name.text,
        'category': category,
        'link': _link.text,
        'about': _about.text,
        'user': currentUser,
        'rating': "0",
      }),
    );

    backToHome();
  }

  void backToHome() {
    context.go('/');
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
}
