import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Caculator',
    home: Calculator(),
    theme: ThemeData(
      //brightness: Brightness.dark,
      primaryColor: Colors.deepOrange,
      accentColor: Colors.white,
    ),
  ));
}

class Calculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CalculatorState();
  }
}

class CalculatorState extends State<Calculator> {
  final miniPadding = 5.0;
  var _currencies = ['RMB', 'AU', 'US'];
  var _curentSelected = '';
  var displayResult = '';

  var _formKey = GlobalKey<FormState>(); // create a form with a globalKey.

  @override
  void initState() {
    super.initState();
    _curentSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Simple Calculator',
//          style: textStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(miniPadding),
          child: ListView(
            children: <Widget>[
              //image
              getImageAsset(),
              //textField
              Padding(
                padding: EdgeInsets.only(top: miniPadding),
                child: TextFormField(
                  controller: principalController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "please enter your principal amount";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Principal',
                    labelStyle: textStyle,
                    hintText: 'enter Principal e.g. 12000',
                    errorStyle:
                        TextStyle(color: Colors.deepOrange, fontSize: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: miniPadding),
                  child: TextFormField(
                    controller: rateController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "please enter your rate of interest";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    decoration: InputDecoration(
                      icon: Icon(Icons.accessibility),
                      labelText: 'Rate of Interest',
                      labelStyle: textStyle,
                      hintText: 'Enter Rate such as 0.35',
                      errorStyle:
                          TextStyle(color: Colors.deepOrange, fontSize: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: miniPadding, bottom: miniPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: termController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "please enter term";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            icon: Icon(Icons.accessibility),
                            labelText: 'Term',
                            labelStyle: textStyle,
                            hintText: 'in ',
                            errorStyle: TextStyle(
                                color: Colors.deepOrange, fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: miniPadding * 5,
                      ),
                      Expanded(
                          child: DropdownButton<String>(
                        items: _currencies.map((String value) {
                          return DropdownMenuItem(
                              child: Text(value), value: value);
                        }).toList(),
                        value: _curentSelected,
                        style: textStyle,
                        onChanged: (String newValueSelected) {
                          //your code to execute, when a menu item is selected from dropdown
                          _onDropDownItemSelected(newValueSelected);
                        },
                      )),

                      //
                    ],
                  )),
              Padding(
                padding: EdgeInsets.all(miniPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //first button
                    Expanded(
                        child: RaisedButton(
//                    color: Theme.of(context).primaryColor,
//                    textColor: Colors.white,

                      color: Colors.deepOrange,
                      textColor: Colors.white,
//                    padding: EdgeInsets.all(miniPadding),
                      child: Text(
                        'Calculate',
                        textScaleFactor: 1.5,
//                      style: textStyle,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState.validate()) {
                            this.displayResult = calculateAmount();
                          } else {
                            return null;
                          }
                        });
                      },
                    )),
                    //second button
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).accentColor,
//                    padding: EdgeInsets.all(miniPadding),
                      onPressed: () {
                        setState(() {
                          reset();
                        });
                      },
                      child: Text(
                        'Reset',
                        textScaleFactor: 1.5,
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(miniPadding),
                child: Text(
                  this.displayResult,
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/222.png');
    Image image = Image(
      image: assetImage,
      width: 250.0,
      height: 250.0,
    );
    return Container(
//    alignment: Alignment(, y),
      child: image,
      margin: EdgeInsets.all(miniPadding * 5),
    );
  }

  void _onDropDownItemSelected(String selectedValue) {
    setState(() {
      this._curentSelected = selectedValue;
    });
  }

  String calculateAmount() {
    double principle = double.parse(principalController.text);
    double rate = double.parse(rateController.text);
    double term = double.parse(termController.text);
    double result = principle + (principle * rate * term) / 100;
    String displayResult =
        "after $term years, your investment will be worth $result $_curentSelected";
    return displayResult;
  }

  void reset() {
    principalController.clear();
    rateController.clear();
    termController.clear();
    displayResult = '';
    _curentSelected = _currencies[0];
    _formKey.currentState.reset();
  }
}
