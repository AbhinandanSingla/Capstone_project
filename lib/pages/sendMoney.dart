import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/pages/GlobalState.dart';
import 'package:flutter_login_signup/pages/pinScreen.dart';

class SendMoney extends StatefulWidget {
  late final data;

  SendMoney(this.data);

  @override
  State<SendMoney> createState() => _SendMoneyState(this.data);
}

class _SendMoneyState extends State<SendMoney> {
  GlobalState _store = GlobalState.instance;

  _SendMoneyState(data);

  late TextEditingController _money;

  final TextEditingController t1 = new TextEditingController(text: "0");
  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  late String pin;

  @override
  void initState() {
    super.initState();

    print('${widget.data} ++++++step reached');
    // fetchDatabaseList();
    _money = TextEditingController();
    _store.set('money', '');
    _money.text = _store.get('money');
  }

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
                  'Confirm to send',
                  style: TextStyle(fontSize: 22.0),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => PinScreen(
                          {'money': _money.value.text, 'uid': widget.data})));
                  // showAlertDialog(context);
                  // submitAction(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //             new WalletApp(money: _money.text)));
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
