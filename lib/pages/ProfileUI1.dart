import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ProfileUI2.dart';
import 'loginPage.dart';
import 'Home.dart';
import 'package:flutter_login_signup/DatabaseManager/DatabaseManager.dart';
import 'package:flutter_login_signup/pages/provider.dart';
import 'package:flutter_login_signup/Service/AuthenticationService.dart';

class Settings1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI1",
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showPassword = false;
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  // List userProfilesList = [];
  late String name;
  late String rollNo;
  dynamic uid;

  @override
  void initState(){
    super.initState();
    fetchDatabaseList();
  }

  Future<void> fetchDatabaseList() async {

    uid = await _auth.getCurrentUID();
    if (uid == null) {
      print("UID is NULL");
    }
    else {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));},
        ),

      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },

            child: ListView(
              children: [
                Center(
                  child: Text(
                    "Your Profile Information",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),


                Text("Full Name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 5,
                ),
                Text("$name"),
                Divider(color: Colors.grey[500],),
                SizedBox(
                  height: 5,
                ),



                Text("Roll Number",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 5,
                ),
                Text("$rollNo"),
                Divider(color: Colors.grey[500],),
                SizedBox(
                  height: 15,
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        // print("name = $name");
                        // print("rollNor = $rollNo");
                        // print("uid-$uid");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsUI()));},
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),

                    ),
                    RaisedButton(
                        onPressed: () {
                          // print(userProfilesList);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));},
                        color: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child:Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                size: 16,
                                color: Colors.white,
                              ),
                              onPressed: () {
                              },
                            ),
                            Text(
                              "Signout",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          ],
                        )
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                )
              ],
            )
        ),
      ),
    );
    //     body: Container(
    //         child: ListView.builder(
    //             itemCount: userProfilesList.length,
    //             itemBuilder: (context, index) {
    //               return Card(
    //                 child: ListTile(
    //                   title: Text(userProfilesList[index]['name']),
    //                   subtitle: Text(userProfilesList[index]['rollNo']),
    //                   leading: CircleAvatar(
    //                     child: Image(
    //                       image: AssetImage('pay.jpg'),
    //                     ),
    //                   ),
    //                   // trailing: Text('${userProfilesList[index]['score']}'),
    //                 ),
    //               );
    //             })));
  }
}