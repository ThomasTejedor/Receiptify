import 'package:flutter/material.dart';
import '../pages/startup_screen.dart';
import '../pages/login.dart';
import '../pages/signup.dart';
import '../pages/profile.dart';
import '../pages/checkbox_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';

import 'widgets/checkbox_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const StartupPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignupPage();
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfilePage();
          }
        ),
        GoRoute(
          path: 'checkbox',
          builder: (BuildContext context, GoRouterState state) {
            return CheckboxPage(userData: state.extra as PassData);
          }
        ),
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Receiptify',
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 185, 178, 231)
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 240, 235, 216)
          ),
          color: const Color.fromARGB(255, 20, 33, 61),
          titleTextStyle: TextStyle(
            fontSize: 32,
            color: Color.fromARGB(255, 240, 235, 216),
          ),
          centerTitle: true
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 13),
        ).apply(
          bodyColor: const Color.fromARGB(255, 240, 235, 216),
          displayColor: const Color.fromARGB(255, 240, 235, 216)
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 20, 21, 24),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
