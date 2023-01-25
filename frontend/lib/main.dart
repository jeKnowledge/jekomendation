import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/jogos.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/make_suggestion.dart';
import 'package:frontend/pages/musica.dart';
import 'package:frontend/pages/signUp_page.dart';
import 'package:frontend/pages/suggetions_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/classes/Suggestion.dart';
import 'package:http/http.dart';
import 'package:frontend/pages/filmesseries.dart';
import 'package:url_launcher/url_launcher.dart';

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
          title: "Jekomendation",
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
        path: '/jekomandation',
        builder: (BuildContext context, GoRouterState state) {
          return SuggestionPage(
              jekomandationId: state.queryParams['jekomandationId']!);
        }),
    GoRoute(
        path: '/suggestion/create',
        builder: (BuildContext context, GoRouterState state) {
          return const makeSuggestion();
        }),
    GoRoute(
        path: '/filters',
        builder: (BuildContext context, GoRouterState state) {
          return const Paginaprincipal();
        }),
    GoRoute(
        path: '/filmesseries',
        builder: (BuildContext context, GoRouterState state) {
          return FilmsPage();
        }),
    GoRoute(
        path: '/musica',
        builder: (BuildContext context, GoRouterState state) {
          return MusicsPage();
        }),
    GoRoute(
        path: '/jogos',
        builder: (BuildContext context, GoRouterState state) {
          return GamesPage();
        }),
  ],
);

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
  List<Jekomandation> suggestion = [];

  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "1028574994519-m4jie21dv7jjg5ae4skkd57qr60erkbh.apps.googleusercontent.com",
  );

  @override
  void initState() {
    googleSignIn.signInSilently();
    checkLogin();
    _retrieveSuggestion();
    super.initState();
  }

  Future<void> _retrieveSuggestion() async {
    suggestion = [];

    List response = json.decode(
        (await client.get(Uri.parse('http://127.0.0.1:8000/jekomandations')))
            .body);
    response.forEach((element) {
      suggestion.add(Jekomandation.fromMap(element));
    });
    suggestion = suggestion.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: ClipOval(
            child: Image.network(
              profilePicture(),
              scale: 1,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
          actions: [
            IconButton(
              onPressed: (){context.go('/filters');},
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
        body: RefreshIndicator(
          onRefresh: _retrieveSuggestion,
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
                            if (suggestion[index].rating != -1)
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
                          suggestion[index].user,
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
