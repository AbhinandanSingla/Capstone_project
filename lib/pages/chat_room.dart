import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatelessWidget {
  List chats = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) => SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.account_circle_rounded),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, left: 20, right: 20),
                      child: Text(
                        'Hii',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            fontSize: 20, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: BottomSheet(
        builder: (ctx) => Container(
          height: 60,
          child: Form(
              child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade300),
              width: size.width * 0.95,
              child: TextFormField(
                onFieldSubmitted: (val) => chats
                    .add({'uid': '', 'message': '', 'time': DateTime.now()}),
                style: GoogleFonts.openSans(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.emoji_emotions_rounded),
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'Type a Message',
                ),
              ),
            ),
          )),
        ),
        onClosing: () {},
      ),
    );
  }
}

class firebaseHelper extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getChats(id) async {
    await _firestore.collection('chatRoom').doc('').get();
  }

  addChat(message, id) async {
    await _firestore.collection('chatRoom').doc(id).update({
      'chats': FieldValue.arrayUnion([message])
    });
  }
}
