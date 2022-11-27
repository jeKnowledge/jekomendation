import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'signUp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void changeToSignUpPage() {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignUpPage()),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hello
              Text(
                'Hello',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 10),

              Text(
                'Welcome to jeKomendation',
                style: TextStyle(
                  fontSize: 20
                ),
              ),

              SizedBox(height: 50),
      
              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),


                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),

                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
      
              // pass textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),


                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),

                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              
              // login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12), 
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                  )
                ),
              ),

            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                foregroundColor: Colors.white,
              ),
              onPressed: changeToSignUpPage,
              child: const Text('Sign Up'),
            ),
                          
            ],
          ),
        ),
      )
    );
  }
}