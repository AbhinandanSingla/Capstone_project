import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_signup/DatabaseManager/DatabaseManager.dart';

class AuthenticationService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _error;

  // Stream<String> get onAuthStateChanged =>
  //     _auth.onAuthStateChanged.map((User user) => user?.uid,);

  Future<String> getCurrentUID() async {
    User user =  (await _auth.currentUser);
    return user != null ? user.uid : null;
  }


  Future createNewUser(String name , String rollNumber , String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await DatabaseManager().createUserData(name, rollNumber , user.uid);
      // await DatabaseManager().getUsersList(user.uid);
      return user;
    }catch(e){
      _error=e.message;
      print(e.toString());
      print(_error);
    }
  }



  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
