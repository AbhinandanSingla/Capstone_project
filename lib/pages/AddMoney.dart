import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/pages/GlobalState.dart';
import 'package:flutter_login_signup/pages/moneyWallet.dart';

class AddMoney extends StatefulWidget {
  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  GlobalState _store = GlobalState.instance;
  late TextEditingController _money;
  final TextEditingController t1 = new TextEditingController(text: "0");

  // final AuthenticationService _auth = AuthenticationService();
  // dynamic uid;
  // String name;
  // String rollNo;
  //
  //
  // @override
  // // void initState(){
  // //   super.initState();
  // //   fetchUserInfo();
  // // }
  //
  // // fetchUserInfo() async{
  // //   uid = await _auth.getCurrentUID();
  // //   print(uid);
  // // }
  //
  // Future<void> fetchDatabaseList() async {
  //
  //   uid = await _auth.getCurrentUID();
  //   if (uid == null) {
  //     print("UID is NULL");
  //   }
  //   else {
  //     print("uid-$uid");
  //     DatabaseManager databaseManager = DatabaseManager(uid: uid);
  //     DocumentSnapshot resultant = await databaseManager.getUsersList();
  //
  //     if (resultant == null) {
  //       print('Unable to retrieve');
  //     } else {
  //       setState(() {
  //         // print(resultant);
  //         name = resultant.get('name');
  //         rollNo = resultant.get('rollNo');
  //         // money = resultant.get('money');
  //         // String name = resultant.g;
  //         // String rollNo = resultant[1];
  //         // print("name = $name");
  //         // print("rollNor = $rollNo");
  //       });
  //     }
  //   }
  // }
  //
  // updateData(String name, String rollNo, String money , String userID) async {
  //   await DatabaseManager().updateUserList(name, rollNo, money ,  userID);
  // }

  @override
  void initState() {
    super.initState();
    // fetchDatabaseList();
    _money = TextEditingController();
    _store.set('money', '');
    _money.text = _store.get('money');
  }

  // onClickSendVariables(){
  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>new WalletApp()));}

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(children: <Widget>[
            //new Text('${_store.get('name')}'),
            SizedBox(height: 30),
            CircleAvatar(
              backgroundImage: AssetImage('images/addmoney.PNG'),
              radius: 70,
            ),
            //Text('${_store.get('value')}'),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: _money,

                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  LimitRangeTextInputFormatter(0, 500),
                ],

                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Amount',
                  hintText: 'Enter Amount less than 500',
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      splashColor: Colors.black,
                      onPressed: () {
                        _money.clear();
                      }),
                ),
                //onChanged: (var text){
                //  setState((){
                // value = text;
                //  });

                //},
              ),
            ),

            SizedBox(height: 20),

            RaisedButton(
                textColor: Colors.white,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Confirm to Add',
                  style: TextStyle(fontSize: 22.0),
                ),
                onPressed: () {
                  // showAlertDialog(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new WalletApp(money: _money.text)));
                }),
            //SizedBox(height:10),
            // RaisedButton(
            //   textColor: Colors.white,
            //   color: Colors.black,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10)),
            //
            //   child: Text('Click to check balance',
            //     style: TextStyle(fontSize: 22.0),
            //   ),
            //   onPressed: () async {
            //     Navigator.push(context, MaterialPageRoute(
            //         builder: (context) => WalletApp()));
            //   },
            // ),
          ]),
        ));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewScreen()));
  }
// submitAction(BuildContext context) {
//   updateData(name, rollNo, _money.text , uid);
// }
}

class NewScreen extends StatelessWidget {
  //String value;
  //NewScreen({this.value});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Balance'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          " The balance in the wallet is ",
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max) : assert(min < max);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = int.parse(newValue.text);
    if (value < min) {
      return TextEditingValue(text: min.toString());
    } else if (value > max) {
      return TextEditingValue(text: max.toString());
    }
    return newValue;
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog

  AlertDialog alert = AlertDialog(
    title: Text(
      "Message",
      style: TextStyle(color: Colors.white),
    ),
    content: Text(
      " Money credited to your wallet",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
