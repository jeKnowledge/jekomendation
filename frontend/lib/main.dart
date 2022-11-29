import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/signUp_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/classes/Suggestion.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

bool loggedUser = true;

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) {
        if (!loggedUser) {
          return '/login';
        } else {
          return null;
        }
      },
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(
          title: "JeKomendation",
        );
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        }),
    GoRoute(
        path: '/suggestion',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        })
  ],
);

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client client = http.Client();
  List<Suggestion> suggestion = [];

  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "1028574994519-m4jie21dv7jjg5ae4skkd57qr60erkbh.apps.googleusercontent.com",
  );

  @override
  void initState() {
    checkLogin();
    googleSignIn.signInSilently();
    _retrieveSuggestion();
    super.initState();
  }

  _retrieveSuggestion() async {
    suggestion = [];

    List response = json.decode((await client
            .get(Uri.parse('http://127.0.0.1:8000/')))
        .body);
    response.forEach((element) {
      suggestion.add(Suggestion.fromMap(element));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(
            profilePicture(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          )
        ],
      ),
      backgroundColor: Colors.blue,
      body: ListView.separated(
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
                    leading: const Icon(Icons.person),
                    title: Text(suggestion[index].title),
                    shape: BorderDirectional(
                      bottom: BorderSide(
                          width: 2.0, color: Colors.lightBlue.shade900),
                    ),
                    onTap: () {
                      context.push('/');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Text(suggestion[index].body)),
                  ),
                ],
              ));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (() {
        }),
        child: Icon(Icons.add, color: Colors.blue,),
        )
    );
  }

  void checkLogin() async {
    if (!await googleSignIn.isSignedIn()) {
      context.go('/login');
    }
  }

  void logout() async {
    await googleSignIn.signOut();
    checkLogin();
  }

  String profilePicture() {
    var url = googleSignIn.currentUser?.photoUrl;
    if (url != null) {
      return url;
    }
    return 'https://picsum.photos/250?image=9';
  }
}
