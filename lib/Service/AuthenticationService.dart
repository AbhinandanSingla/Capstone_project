import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_signup/DatabaseManager/DatabaseManager.dart';
import 'package:flutter_login_signup/Service/preference.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _error;

  // Stream<String> get onAuthStateChanged =>
  //     _auth.onAuthStateChanged.map((User user) => user?.uid,);

  Future<String?> getCurrentUID() async {
    User? user = (_auth.currentUser);
    return user != null ? user.uid : null;
  }

  Future createNewUser(String name, String rollNumber, String email,
      String password, String pin) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      preferenceHelper.login(true);
      preferenceHelper.preferences.setString('uid', result.user!.uid);
      preferenceHelper.preferences.setString('rollno', rollNumber);
      preferenceHelper.preferences.setString('email', email);
      preferenceHelper.preferences.setString('name', name);
      await DatabaseManager()
          .createUserData(email, name, rollNumber, user!.uid, pin);
      // await DatabaseManager().getUsersList(user.uid);
      return user;
    } catch (e) {
      _error = e.toString();
      print(e.toString());
      print(_error);
    }
  }

  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('login done');
      DatabaseManager databaseManager = DatabaseManager(uid: result.user!.uid);
      DocumentSnapshot resultant = await databaseManager.getUsersList();
      print('stage55555555555555555599999999');

      preferenceHelper.login(true);
      preferenceHelper.preferences.setString('uid', result.user!.uid);
      preferenceHelper.preferences.setString('rollno', resultant.get('rollNo'));
      preferenceHelper.preferences.setString('email', email);
      preferenceHelper.preferences.setString('name', resultant.get('name'));
      print('stage199999999999999999999999');
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      preferenceHelper.login(false);
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
