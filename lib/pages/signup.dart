import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/Service/AuthenticationService.dart';
import 'package:flutter_login_signup/pages/loginPage.dart';

import 'Home.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _key = GlobalKey<FormState>();

  // CollectionReference collectionReference = Firestore.instance.collection();

  final AuthenticationService _auth = AuthenticationService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _pin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,

          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/pic.jpg"), fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
          ),

          // color: Colors.deepPurpleAccent,
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        // Positioned(
                        //   top: -MediaQuery.of(context).size.height * .4,
                        //   right: -MediaQuery.of(context).size.width * .4,
                        //   child: BezierContainer(),
                        // ),

                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name cannot be empty';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 15,
                              )),
                          style: TextStyle(color: Colors.black),
                        ),

                        SizedBox(height: height * .03),
                        TextFormField(
                          controller: rollNoController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Roll no can not be empty';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Roll No',
                              labelStyle: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 15,
                              )),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: height * .03),

                        TextFormField(
                          controller: _emailContoller,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email cannot be empty';
                            } else if (!value.contains('@') ||
                                !value.contains('thapar.edu')) {
                              return 'Invalid email';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 15,
                              )),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: height * .03),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Password cannot be empty';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.indigo[900],
                              fontSize: 15,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: height * .01),
                        TextFormField(
                          controller: _pin,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Pin cannot be empty';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Pin',
                            labelStyle: TextStyle(
                              color: Colors.indigo[900],
                              fontSize: 15,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: height * .01),
                        FlatButton(
                          child: Text(
                            'Already registerd? Login',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          textColor: Colors.white,
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              child: Text('Sign Up'),
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  createUser();
                                }
                              },
                              color: Colors.white,
                            ),
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.white,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createUser() async {
    dynamic result = await _auth.createNewUser(
        _nameController.text,
        rollNoController.text,
        _emailContoller.text,
        _passwordController.text,
        _pin.value.text);
    if (result == null) {
      print('Email is not valid');
    } else {
      _emailContoller.clear();
      _passwordController.clear();
      _nameController.clear();
      _pin.clear();
      rollNoController.clear();
      print("sign up Successful");
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Home()));
    }
  }
}
