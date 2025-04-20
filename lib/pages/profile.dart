import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  final _authService = authService.value;
  //Moves the page to login if you are not 
  void movePage() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if(mounted) {
      context.push('/login').then((value) => {
        //check if the user is still logged in after returning from a pushed page
        setState(() {})
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_authService.currentUser == null){
      movePage();
    } else {
      print("User is logged in ${_authService.currentUser!.email} ");
    }

    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: 
        IconButton(
          onPressed: () async {
            await _authService.signOut();
            if(mounted) {movePage();}
          },
          iconSize: MediaQuery.sizeOf(context).height *.05,
          icon: const Icon(
            Icons.account_circle

          ),
        ),
      );
  }
}