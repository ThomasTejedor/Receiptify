import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<DBService> dbService = ValueNotifier(DBService());

class DBService {

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;


  Future<bool> availableUsername(String username) async {
    final result = await fireStore.collection('UserInfo')
      .where('username',isEqualTo: username)
      .get();
    if(result.size == 0) return true;
    return false;
  }


}