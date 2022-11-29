import 'package:flutter/material.dart';

class makeSuggestion extends StatefulWidget {
  const makeSuggestion({super.key});

  @override
  State<makeSuggestion> createState() => _makeSuggestionState();
}

class _makeSuggestionState extends State<makeSuggestion> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: const Text('SignUp'),
        ),
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'Username *',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your username',
                        focusColor: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'Email *',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your email',
                        focusColor: Colors.black),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'Password *',
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
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your password',
                        focusColor: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
                  child: Text(
                    'Confirm Your Password *',
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
                      obscureText: true,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your password',
                          focusColor: Colors.black),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                    },
                    child: const Text('Sign Up'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
  }
  
