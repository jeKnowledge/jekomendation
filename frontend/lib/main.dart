import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/signUp_page.dart';
import 'package:go_router/go_router.dart';

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
          title: "Home Page",
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
          })
      ],
);

class MyApp extends StatelessWidget {
  MyApp({super.key});

  bool user = true;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Work in progress',
            ),

             TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                foregroundColor: Colors.black,
              ),
              onPressed: () => context.push('/signup') ,
              child: const Text('Sign Up'),
            ),

          ],
        ),
      ),
    );
  }
}
