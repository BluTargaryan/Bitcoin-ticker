

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
@override
_PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
String selectedCurrency = 'USD';

Column coinCards(){
  List<Widget> cards=[];
  for(String crypto in cryptoList){
    late var value;
    if(crypto=='BTC') value=bitcoinValueInUSD;
    if(crypto=='ETH') value=ethValueInUSD;
    if(crypto=='LTC') value=ltcValueInUSD;
    var newItem = Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          //15. Update the Text Widget with the data in bitcoinValueInUSD.
          '1 $crypto = $value $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
    cards.add(newItem);
  }

  return Column(
    children: [...cards],
  );
}

DropdownButton androidDropdown(){
  List<DropdownMenuItem> dropdownItems=[];
  for(String currency in currenciesList){
    var newItem = DropdownMenuItem(child: Text(currency), value: currency,);
    dropdownItems.add(newItem);
  }

  return DropdownButton(
    value:selectedCurrency,
    items: dropdownItems,onChanged: (value){
    getData();
    setState(() {
      selectedCurrency=value ?? '';
    });
  },);
}

CupertinoPicker iOSPicker() {
List<Text> pickerItems = [];
for (String currency in currenciesList) {
pickerItems.add(Text(currency));
}

return CupertinoPicker(
backgroundColor: Colors.lightBlue,
itemExtent: 32.0,
onSelectedItemChanged: (selectedIndex) {
print(selectedIndex);
},
children: pickerItems,
);
}

//12. Create a variable to hold the value and use in our Text Widget. Give the variable a starting value of '?' before the data comes back from the async methods.
String bitcoinValueInUSD = '?';
  String ethValueInUSD = '?';
  String ltcValueInUSD = '?';

//11. Create an async method here await the coin data from coin_data.dart
void getData() async {
try {
double btc = await CoinData().getBTCCoinData(selectedCurrency);
double eth = await CoinData().getETHCoinData(selectedCurrency);
double ltc = await CoinData().getLTCCoinData(selectedCurrency);
//13. We can't await in a setState(). So you have to separate it out into two steps.
setState(() {
bitcoinValueInUSD = btc.toStringAsFixed(0);
ethValueInUSD = eth.toStringAsFixed(0);
ltcValueInUSD = ltc.toStringAsFixed(0);
});
} catch (e) {
print(e);
}
}

@override
void initState() {
super.initState();
//14. Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because we can't make initState() async.
getData();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('🤑 Coin Ticker'),
),
body: Column(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.stretch,
children: <Widget>[
coinCards(),
Container(
height: 150.0,
alignment: Alignment.center,
padding: EdgeInsets.only(bottom: 30.0),
color: Colors.lightBlue,
child: Platform.isIOS ? iOSPicker() : androidDropdown(),
),
],
),
);
}
}


