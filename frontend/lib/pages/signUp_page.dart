import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool checkJekDomain(String value) {
    if (value.contains('@jeknowledge')) {
      return true;
    }
    return false;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: const Text('SignUp'),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a eamil';
                      } else if (!checkJekDomain(value)) {
                        return 'Please enter a email with a @jeknowledge domain';
                      }
                      return null;
                    },
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
                    controller: _pass,
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
                      controller: _confirmPass,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your password',
                          focusColor: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Empty';
                        if (value != _pass.text) {
                          return 'Passwords Do Not Match';
                        }
                        return null;
                      }),
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
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
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
