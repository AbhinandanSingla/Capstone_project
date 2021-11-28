import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/DatabaseManager/DatabaseManager.dart';
import 'package:flutter_login_signup/Service/AuthenticationService.dart';
import 'package:flutter_login_signup/Service/preference.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_room.dart';

class Chats extends StatefulWidget {
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List feedList = [];

  late String name;

  late String rollNo;

  dynamic uid;

  final AuthenticationService _auth = AuthenticationService();

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
  }

  Future<void> fetchDatabaseList() async {
    uid = await _auth.getCurrentUID();
    if (uid == null) {
      print("UID is NULL");
    } else {
      print("uid-$uid");
      DatabaseManager databaseManager = DatabaseManager(uid: uid);
      DocumentSnapshot resultant = await databaseManager.getUsersList();

      if (resultant == null) {
        print('Unable to retrieve');
      } else {
        setState(() {
          // print(resultant);
          name = resultant.get('name');
          rollNo = resultant.get('rollNo');
          // String name = resultant.g;
          // String rollNo = resultant[1];
          // print("name = $name");
          // print("rollNor = $rollNo");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? uuid = preferenceHelper.preferences.getString('uid');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Chats'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: firestore.collection('profile').doc(uuid).snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  DocumentSnapshot? doc = snapshot.data;
                  if (snapshot.hasData) {
                    feedList = doc!.get('feed');
                  } else {
                    return Container();
                  }
                  return ListView.builder(
                      itemCount: feedList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        if (feedList.isEmpty) {
                          return Container();
                        }
                        print(feedList[index]['uid']);
                        String feedName = feedList[index]['name'];

                        return ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatRoom(feedList[index]['uid']))),
                          title: Text(feedName,style: GoogleFonts.openSans(fontSize: 18),),
                          leading: CircleAvatar(
                            backgroundColor: Colors.orangeAccent,
                            child: Text(
                              feedName.characters.first.toUpperCase(),
                              style: GoogleFonts.roboto(color: Colors.white),
                            ),
                          ),
                          // subtitle: Text('Last Message'),
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
