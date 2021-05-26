import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:flutter_login_signup/pages/AddMoney.dart'; 

class WalletApp extends StatefulWidget {
  String name;
  WalletApp({Key key, @required this.name}) : super(key : key);
  @override
  _WalletAppState createState() => _WalletAppState(name);
}

class _WalletAppState extends State<WalletApp> {
  String name;
  _WalletAppState(this.name);
  var screens = [
    HomeScreen(),
  ]; //screens for each tab

  int selectedTab = 0;

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
      backgroundColor: Colors.black,
      body: screens[selectedTab],
    );
  }
}

class HomeScreen extends StatelessWidget {
  
  var name;
  HomeScreen({Key key, @required this.name}) : super(key : key);



  @override
  Widget build(BuildContext context) {



    return Container(
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
                      new Text( 'Rs.$name', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),),

                    ],
                  ),

                  Text("Available Balance", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),),

                  SizedBox(height : 24,),
                ]
            ),
          ),




          //draggable sheet
          DraggableScrollableSheet(
            builder: (context, scrollController){
              return Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 24,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Recent Transactions", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: Colors.black),),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),
                      SizedBox(height: 24,),

                      //Container for buttons
                      Container(
                        child: Text("TODAY", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[700]),),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),

                      SizedBox(height: 16,),

                      ListView.builder(
                        itemBuilder: (context, index){
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 32),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Icon(Icons.date_range, color: Colors.black,),
                                  padding: EdgeInsets.all(12),
                                ),

                                SizedBox(width: 16,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey[900]),),
                                      Text("Payment by me", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("-\30.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.red),),
                                    Text("5 April", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: 2,
                        padding: EdgeInsets.all(0),
                        controller: ScrollController(keepScrollOffset: false),
                      ),

                      //now expense
                      SizedBox(height: 16,),

                      Container(
                        child: Text("YESTERDAY", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[700]),),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),

                      SizedBox(height: 16,),

                      ListView.builder(
                        itemBuilder: (context, index){
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 32),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Icon(Icons.date_range, color: Colors.black,),
                                  padding: EdgeInsets.all(12),
                                ),

                                SizedBox(width: 16,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Payment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey[900]),),
                                      Text("Payment received from xyz", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text("+\40Rs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.blue),),
                                    Text("4 April", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[500]),),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: 2,
                        padding: EdgeInsets.all(0),
                        controller: ScrollController(keepScrollOffset: false),
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
    );
  }
}