import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<DBService> dbService = ValueNotifier(DBService());

class DBService {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;


  Future<bool> availableUsername(String username) async {
    final result = await _fireStore.collection('UserInfo')
      .where('username',isEqualTo: username)
      .get();
    if(result.size == 0) return true;
    return false;
  }

  Future<bool> availableEmail(String email) async {
    final result = await _fireStore.collection('UserInfo')
      .where('email',isEqualTo: email)
      .get();
    if(result.size == 0) return true;
    return false;
  }

  Future<void> createUserDoc ({
    required String username,
    required String email,
    required String uuid,
  }) async {
    return await _fireStore.collection('UserInfo').doc(uuid).set({
      'username': username,
      'email' : email,
    });
  }

  Future<String> getUsername(String uuid) async {
    DocumentSnapshot data = await _fireStore.collection('UserInfo').doc(uuid).get();
    if(data.exists) {
      return data['username'];
    }
    return 'could not find name';
  }


}