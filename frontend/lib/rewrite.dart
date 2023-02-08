import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/jogos.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/make_suggestion.dart';
import 'package:frontend/pages/musica.dart';
import 'package:frontend/pages/signUp_page.dart';
import 'package:frontend/pages/suggetions_page.dart';
import 'package:frontend/pages/user_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/classes/Suggestion.dart';
import 'package:http/http.dart';
import 'package:frontend/pages/filmesseries.dart';
import 'package:url_launcher/url_launcher.dart';
import 'colors.dart';

void main() {
  runApp(MyApp());
}

GoogleSignIn googleSignIn = GoogleSignIn();

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
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
        path: '/user-page',
        builder: (BuildContext context, GoRouterState state) {
          return UserPage(userID: state.queryParams['userID']!);
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: primaryBlack,
      ),
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
  @override
  void initState() {
    super.initState();
  }

  var currentUser = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        getUser(),
        http.get(Uri.parse('http://127.0.0.1:8000/jekomandations'),
            headers: {'Content-Type': 'application/json'}),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data![0]) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Text(widget.title),
                  leading: IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () => {
                            context.go(Uri(
                                    path: '/user-page/',
                                    queryParameters: {'userID': currentUser})
                                .toString())
                          }),
                  actions: [
                    IconButton(
                        onPressed: () {
                          context.go('/filters');
                        },
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
            body: showPosts(snapshot.data![1]),
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
            return const LoginPage();
          } else {
            return Text("ERROR");
          }
        } else {
          // ignore: prefer_const_constructors
          return Center(child: CircularProgressIndicator(color: Colors.blue,));
        }
      },
    );
  }

  Widget showPosts(posts){
    List<Jekomandation> suggestions = [];
    for (var jekomandation in posts){
      suggestions.add(Jekomandation.fromMap(jekomandation));
    }
    return Container(
            alignment: Alignment.topCenter,
            child: ListView.separated(
              padding: const EdgeInsets.all(2),
              itemCount: suggestions.length,
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
                            title: Text(suggestions[index].jekomandation),
                            subtitle: Row(
                              children: [
                                Text(suggestions[index].category),
                                const Icon(
                                  Icons.star,
                                  size: 15,
                                ),
                                if (suggestions[index].rating != 0)
                                  Text(suggestions[index].rating.toString()),
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
                                    'jekomandationId': '${suggestions[index].id}'
                                  }).toString());
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    suggestions[index].about.length > 28
                                        ? '${suggestions[index].about.substring(0, 28)}...'
                                        : suggestions[index].about,
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
                                            Uri.parse(suggestions[index].link));
                                      },
                                      child: Text(
                                        suggestions[index].link.length > 28
                                            ? '${suggestions[index].link.substring(0, 28)}...'
                                            : suggestions[index].link,
                                        style: TextStyle(
                                            color: Colors.blue[700],
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: TextButton(
                                    child: Text(suggestions[index].user),
                                    onPressed: () {
                                      context.go(Uri(
                                          path: '/user-page/',
                                          queryParameters: {
                                            'userID':
                                                '${suggestions[index].userID}'
                                          }).toString());
                                    },
                                  )),
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
            ),
          );
  }

  void logout() async {
    await googleSignIn.signOut();
    initState();
  }

  Future<bool> getUser() async {
    var user = await googleSignIn.signInSilently();
    final ggAuth = await user!.authentication;

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': ggAuth.idToken.toString(),
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      currentUser = data['user']['id'].toString();
      return true;
    }
    return false;
  }
}
