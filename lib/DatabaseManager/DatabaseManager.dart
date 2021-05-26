import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/Service/AuthenticationService.dart';

class DatabaseManager{

  final String uid;
  DatabaseManager({this.uid});

  final profile =  FirebaseFirestore.instance.collection('profile');

  Future  createUserData(String name , String rollNumber, String uid) async{
    return await profile.doc(uid).set({
      'name': name,
      'rollNo' : rollNumber
    });
  }

  Future updateUserList(String name, String rollNumber , String uid) async {
    return await profile.doc(uid).update({
      'name': name,
      'rollNo': rollNumber
    });
  }

  Future getUsersList() async {
    // List itemsList = [];

    try {
      // await profile.get().then((querySnapshot) {
      //   querySnapshot.docs.forEach((element) {
      //     itemsList.add(element.data);
      //   });
      // });
      DocumentSnapshot itemsList = await profile.doc(uid).get();
      return itemsList;
      String name = itemsList.get('name');
      String rollNo = itemsList.get('rollNo');
      return [name , rollNo];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}