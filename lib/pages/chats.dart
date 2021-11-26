import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_room.dart';

class Chats extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Chats'),
              StreamBuilder(
                stream: firestore
                    .collection('user')
                    .doc('L3nyPONH5yXTNdliktvi')
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  DocumentSnapshot? doc = snapshot.data;
                  print(doc!.get('feed'));

                  return ListView.builder(
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom())),
                          title: Text('Devon Lame'),
                          leading: Icon(Icons.accessibility_new_sharp),
                          subtitle: Text('Last Message'),
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
