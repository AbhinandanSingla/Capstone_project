import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final String? uid;

  DatabaseManager({this.uid});

  final profile = FirebaseFirestore.instance.collection('profile');
  final chatRoom = FirebaseFirestore.instance.collection('chatRoom');

  Future createUserData(
      String email, String name, String rollNumber, String uid) async {
    return await profile.doc(uid).set({
      'userEmail': email,
      'name': name,
      'rollNo': rollNumber,
      'money': "0",
      'feed': []
    });
  }

  Future updateUserList(
      String name, String rollNumber, String money, String uid) async {
    return await profile
        .doc(uid)
        .update({'name': name, 'rollNo': rollNumber, 'money': money});
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
      return [name, rollNo];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
