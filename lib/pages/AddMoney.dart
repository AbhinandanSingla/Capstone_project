import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_signup/pages/moneyWallet.dart';
import 'package:flutter_login_signup/pages/GlobalState.dart';

class AddMoney extends StatefulWidget {

  @override
  _AddMoneyState createState() => _AddMoneyState();
}
class _AddMoneyState extends State<AddMoney> {
  GlobalState _store = GlobalState.instance;
  TextEditingController _name;
  final TextEditingController t1 = new TextEditingController(text: "0");
 // var name;
 // var num1 = 0, num2 = 0, sum = 0;
  //void doAddition() {
   // setState(() {
     // num2 = int.parse(t1.text);

     // name = name + num2;
     // num2=name;
   // });
 // }



  @override
  void initState() {
     _name = TextEditingController();
     _store.set('name','');
     _name.text= _store.get('name');
  }
  onClickSendVariables(){

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>new HomeScreen( name:_name.text)));}
    Widget build(BuildContext context) {

      return Scaffold
        (resizeToAvoidBottomInset: false,
          body: Padding(

            padding: EdgeInsets.all(15),
            child: Column(
                children: <Widget>[
                  //new Text('${_store.get('name')}'),
                  SizedBox(height:30),
                  CircleAvatar(

                    backgroundImage: AssetImage('images/addmoney.PNG'),

                    radius: 70,


                  ),
                  //Text('${_store.get('value')}'),
                  SizedBox(height:50),
                  Padding(
                    padding: EdgeInsets.all(15),


                    child: TextField(

                      controller: _name,

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
                              _name.clear();

                            }),


                      ),
                      //onChanged: (var text){
                      //  setState((){
                      // value = text;
                      //  });

                      //},
                    ),

                  ),

                  SizedBox(height:20),

                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Confirm to pay',
                      style: TextStyle(fontSize: 22.0),
                    ),

                    onPressed:(){


                    showAlertDialog(context);}

                  ),
                  SizedBox(height:10),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),

                    child: Text('Click to check balance',
                      style: TextStyle(fontSize: 22.0),
                    ),
                    onPressed:  onClickSendVariables,
                  ),
                ]
            ),
          )
      );


    }


    void _navigateToNextScreen(BuildContext context) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
    }
  }



class NewScreen extends StatelessWidget {
  //String value;
  //NewScreen({this.value});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar
        (title: Text('Available Balance'),
        backgroundColor: Colors.black,),

      body: Center(


        child: Text(

          " The balance in the wallet is ",
          style: TextStyle(fontSize: 24.0),

        ),

      ),
    );

  }

}






class LimitRangeTextInputFormatter  extends TextInputFormatter {
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
    title: Text("Message",style: TextStyle(color: Colors.white),),

    content: Text(" Money credited to your wallet",style: TextStyle(color: Colors.white),),
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