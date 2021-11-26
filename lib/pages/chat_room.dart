import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/Service/preference.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatefulWidget {
  final id;

  ChatRoom(this.id);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List chats = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _message = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  getChats(id) async {
    await _firestore
        .collection('chatRoom')
        .doc(id)
        .get()
        .then((value) => setState(() {
              chats = value.get('chats');
            }));
  }

  sendChat({message, id}) async {
    String? uid = preferenceHelper.preferences.getString('uid');
    print('${message}    $id   ');
    await _firestore.collection('chatRoom').doc(id).update({
      'chats': FieldValue.arrayUnion([message])
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getChats(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // getChats(widget.id);
    String? uid = preferenceHelper.preferences.getString('uid');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('ChatRoom'),
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: _firestore
                    .collection('chatRoom')
                    .doc(widget.id)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  DocumentSnapshot doc = snapshot.data;
                  chats = doc.get('chats');
                  return ListView.builder(
                    itemCount: chats.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      var alignment = MainAxisAlignment.start;
                      if (chats[index]['uid'] == uid) {
                        alignment = MainAxisAlignment.end;
                        return SizedBox(
                          width: size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: alignment,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 3, bottom: 3),
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 20, right: 20),
                                child: Text(
                                  chats[index]['message'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      fontSize: 20, color: Colors.white),
                                ),
                                decoration: BoxDecoration(
                                  // gradient: LinearGradient(
                                  //     colors: [
                                  //       Color(0xffFFFF00).withOpacity(0.3),
                                  //       Color(0xff00BCD4).withOpacity(0.5),
                                  //       Color(0xffEE82EE),
                                  //     ],
                                  //     begin: Alignment.topLeft,
                                  //     end: Alignment.bottomRight),
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Image.asset(
                                'images/tick.png',
                                width: 15,
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: alignment,
                          children: [
                            const Icon(Icons.account_circle_rounded),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 20, right: 20),
                              child: Text(
                                chats[index]['message'],
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
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomSheet: BottomSheet(
        builder: (ctx) => Container(
          height: 60,
          child: Form(
              key: _key,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, bottom: 2, top: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.shade300),
                      width: size.width * 0.8,
                      child: TextFormField(
                        controller: _message,
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
                    GestureDetector(
                        onTap: () => {
                              sendChat(message: {
                                'message': _message.value.text,
                                'uid': uid,
                                'time': DateTime.now()
                              }, id: widget.id),
                              _message.clear()
                            },
                        child: Image.asset(
                          'images/send.png',
                          width: 35,
                        )),
                  ],
                ),
              )),
        ),
        onClosing: () {},
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _message.dispose();
  }
}

class firebaseHelper extends ChangeNotifier {}
