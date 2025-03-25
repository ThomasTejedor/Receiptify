import 'package:flutter/material.dart';
import '../pages/startup_screen.dart';
import '../pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receiptify',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 13, 19, 33),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LoginPage()
      ),
    );
  }
}
