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

  Future createNewUser(
      String name, String rollNumber, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseManager()
          .createUserData(email, name, rollNumber, user!.uid);
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
      preferenceHelper.login(true);
      preferenceHelper.preferences.setString('uid', result.user!.uid);
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
