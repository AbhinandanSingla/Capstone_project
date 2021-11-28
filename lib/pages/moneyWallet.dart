import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/DatabaseManager/DatabaseManager.dart';
import 'package:flutter_login_signup/Service/AuthenticationService.dart';
import 'package:intl/intl.dart';

// import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

import 'Home.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class WalletApp extends StatefulWidget {
  String? money;

  WalletApp({Key? key, this.money}) : super(key: key);

  @override
  _WalletAppState createState() => _WalletAppState();
}

class _WalletAppState extends State<WalletApp> {
  final AuthenticationService _auth = AuthenticationService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // late String money;
  dynamic uid;
  late String _money;
  late String name;
  late String rollNo;
  List transactions = [];
  List transactionRemaining = [];
  List transactionsToday = [];
  String _expression = '0';
  String history = '';

  // _WalletAppState(this.money);

  // void initState(){
  //   super.initState();
  // }

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
          _money = resultant.get('money');
          name = resultant.get('name');
          rollNo = resultant.get('rollNo');
          transactions = resultant.get('transaction');
          print("_money");
          print(_money);
          _expression += "+";
          _expression += _money;
        });
        Parser p = Parser();
        Expression exp = p.parse(_expression);
        ContextModel cm = ContextModel();
        transactions.forEach((element) {
          var a = DateTime.parse(element['time'].toDate().toString());
          DateFormat formatter = DateFormat('dd-MM-yyyy');
          String formatted = formatter.format(a);
          DateTime today = DateTime.now();
          today.compareTo(a);
          if (today.isSameDate(a)) {
            transactionsToday.add(element);
          } else {
            transactionRemaining.add(element);
            print('diff ++++++++++++++++++++++');
          }
          print('${today.isSameDate(a)} ++++++++++++++++++++++');
        });
        setState(() {
          history = _expression;
          _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
          print("_expression ");
          print(_expression);
        });
      }
    }
  }

  updateData(String name, String rollNo, String money, String userID) async {
    // fetchDatabaseList();
    await DatabaseManager().updateUserList(name, rollNo, money, userID);
    // fetchDatabaseList();
  }

  @override
  void initState() {
    super.initState();
    fetchDatabaseList();
    // updateData(name, rollNo, _expression ,uid);
    if (widget.money != null) {
      setState(() {
        _expression += "+";
        _expression += widget.money!;
        // _expression += "+";
        // _expression += _money;
      });
    }
    // else{
    //   setState(() => _expression += history);
    // }
    print("string:-");
    print(_expression);
    Parser p = Parser();
    Expression exp = p.parse(_expression);
    ContextModel cm = ContextModel();

    setState(() {
      history = _expression;
      _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
      // _expression=_money;
      print("_expression ");
      print(_expression);
      if (_expression is int) {
        print("shitttt");
      }
      if (_expression is String) {
        print("greatttt");
      }
    });
    // submitAction(context)
  }

  //
  // void evaluate(String text) {
  //
  // }
  // var screens = [
  //   HomeScreen(),
  // ]; //screens for each tab

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              submitAction(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                //Container for top data
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              'Rs.$_expression',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(
                          "Available Balance",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                      ]),
                ),

                //draggable sheet
                DraggableScrollableSheet(
                  builder: (context, scrollController) {
                    return Container(
                      height: size.height / 2,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Recent Transactions",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                            ),
                            SizedBox(
                              height: 24,
                            ),

                            //Container for buttons
                            Container(
                              child: Text(
                                "TODAY",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[700]),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                            ),

                            SizedBox(
                              height: 16,
                            ),

                            ListView.builder(
                              itemBuilder: (context, index) {
                                var formatter = new DateFormat('MMMM');
                                var date = DateTime.parse(
                                    transactionsToday[index]['time']
                                        .toDate()
                                        .toString());

                                return Container(
                                  margin: EdgeInsets.only(
                                      right: 32, left: 32, top: 2, bottom: 2),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Icon(
                                          Icons.date_range,
                                          color: Colors.black,
                                        ),
                                        padding: EdgeInsets.all(12),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              transactionsToday[index]
                                                          ['name'] ==
                                                      null
                                                  ? ''
                                                  : transactionsToday[index]
                                                      ['name'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[900]),
                                            ),
                                            Text(
                                              transactionsToday[index]['send']
                                                  ? "Payment Sent"
                                                  : "Payment Received",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            transactionsToday[index]['send']
                                                ? "-${transactionsToday[index]['money']}"
                                                : '+${transactionsToday[index]['money']}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            "${date.day} ${formatter.format(date)}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              shrinkWrap: true,
                              itemCount: transactionsToday.length,
                              padding: EdgeInsets.all(0),
                              controller:
                                  ScrollController(keepScrollOffset: true),
                            ),

                            //now expense
                            SizedBox(
                              height: 16,
                            ),

                            Container(
                              child: Text(
                                "Others",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[700]),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32),
                            ),

                            SizedBox(
                              height: 16,
                            ),

                            Container(
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  var formatter = new DateFormat('MMMM');
                                  var date = DateTime.parse(
                                      transactionRemaining[index]['time']
                                          .toDate()
                                          .toString());

                                  return Container(
                                    margin: EdgeInsets.only(top: 2, bottom: 2),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(18))),
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.black,
                                          ),
                                          padding: EdgeInsets.all(12),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                transactionRemaining[index]
                                                            ['name'] ==
                                                        null
                                                    ? ''
                                                    : transactionRemaining[
                                                        index]['name'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey[900]),
                                              ),
                                              Text(
                                                transactionRemaining[index]
                                                        ['send']
                                                    ? "Payment Sent"
                                                    : "Payment Received",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey[500]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              transactionRemaining[index]
                                                      ['send']
                                                  ? "-${transactionRemaining[index]['money']}"
                                                  : '+${transactionRemaining[index]['money']}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.blue),
                                            ),
                                            Text(
                                              "${date.day} ${formatter.format(date)}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: transactionRemaining.length,
                                padding: EdgeInsets.all(0),
                                controller:
                                    ScrollController(keepScrollOffset: false),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),

                            //now expense
                          ],
                        ),
                        controller: scrollController,
                      ),
                    );
                  },
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 1,
                )
              ],
            ),
          ),
        ));
  }

  submitAction(BuildContext context) {
    updateData(name, rollNo, _expression, uid);
  }
}

// class HomeScreen extends StatelessWidget {
//
//   var name;
//   HomeScreen({Key key, @required this.name}) : super(key : key);
//
//
//
//   @override
//   Widget build(BuildContext context) {

// return Container(
//   height: MediaQuery.of(context).size.height,
//   width: double.infinity,
//   child: Stack(
//     children: <Widget>[
//       //Container for top data
//       Container(
//         margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Row(
//
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   new Text( 'Rs.$name', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),),
//
//                 ],
//               ),
//
//               Text("Available Balance", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),),
//
//               SizedBox(height : 24,),
//             ]
//         ),
//       ),
//
//
//
//
//       //draggable sheet
//       DraggableScrollableSheet(
//         builder: (context, scrollController){
//           return Container(
//             decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   SizedBox(height: 24,),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.black),),
//                       ],
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 32),
//                   ),
//                   SizedBox(height: 24,),
//
//                   //Container for buttons
//                   Container(
//                     child: Text("TODAY", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[700]),),
//                     padding: EdgeInsets.symmetric(horizontal: 32),
//                   ),
//
//                   SizedBox(height: 16,),
//
//                   ListView.builder(
//                     itemBuilder: (context, index){
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 32),
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.all(Radius.circular(20))
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.grey[100],
//                                   borderRadius: BorderRadius.all(Radius.circular(18))
//                               ),
//                               child: Icon(Icons.date_range, color: Colors.black,),
//                               padding: EdgeInsets.all(12),
//                             ),
//
//                             SizedBox(width: 16,),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text("Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey[900]),),
//                                   Text("Payment by me", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
//                                 ],
//                               ),
//                             ),
//
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: <Widget>[
//                                 Text("-\30.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.red),),
//                                 Text("5 April", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     shrinkWrap: true,
//                     itemCount: 2,
//                     padding: EdgeInsets.all(0),
//                     controller: ScrollController(keepScrollOffset: false),
//                   ),
//
//                   //now expense
//                   SizedBox(height: 16,),
//
//                   Container(
//                     child: Text("YESTERDAY", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[700]),),
//                     padding: EdgeInsets.symmetric(horizontal: 32),
//                   ),
//
//                   SizedBox(height: 16,),
//
//                   ListView.builder(
//                     itemBuilder: (context, index){
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 32),
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.all(Radius.circular(20))
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.grey[100],
//                                   borderRadius: BorderRadius.all(Radius.circular(18))
//                               ),
//                               child: Icon(Icons.date_range, color: Colors.black,),
//                               padding: EdgeInsets.all(12),
//                             ),
//
//                             SizedBox(width: 16,),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text("Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey[900]),),
//                                   Text("Payment received from xyz", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
//                                 ],
//                               ),
//                             ),
//
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: <Widget>[
//                                 Text("+\40Rs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.blue),),
//                                 Text("4 April", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     shrinkWrap: true,
//                     itemCount: 2,
//                     padding: EdgeInsets.all(0),
//                     controller: ScrollController(keepScrollOffset: false),
//                   ),
//
//                   //now expense
//
//
//                 ],
//               ),
//               controller: scrollController,
//             ),
//           );
//         },
//         initialChildSize: 0.65,
//         minChildSize: 0.65,
//         maxChildSize: 1,
//       )
//     ],
//   ),
// );
//   }
// }
