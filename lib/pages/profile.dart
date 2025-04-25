import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  final _authService = authService.value;
  final _dbService = dbService.value;
  late User? user;
  String username = "";
  //Moves the page to login if you are not 
  void movePage() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if(mounted) {
      await context.push('/login').whenComplete(() {
        setState (() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    user = _authService.currentUser;
    if(user == null){
      movePage();
      return Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }
    if(username == "") {
      _dbService.getUsername(user!.uid).then((value) {setState(() {username = value;});});
      return Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          Center(
            child: Icon(
              Icons.account_circle,
              size: MediaQuery.sizeOf(context).height *.25
            ),
          ),
          Expanded(
            child: Text(
              username,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() async {
                await _authService.signOut();
                setState(() {});
              });
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
            iconAlignment: IconAlignment.start,
          ),
        ]
      ),
    );
  }
}