import 'package:flutter/material.dart';
import 'package:flutter_bmi_calculator/screens/calculator_screen.dart';
import 'package:flutter_bmi_calculator/screens/pedo.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: CalculatorScreen(),*/
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      title: 'FitCalc 🏃‍🚴‍🏋️‍🤸',
      home: Scaffold(
        appBar: AppBar(title: const Text('FitCalc 🏃‍🚴‍🏋️‍🤸')),
        body:  Center(
          child: MyStatelessWidget(),
        ),
      ),
      initialRoute: MyStatelessWidget.id,
      routes: {
        MyStatelessWidget.id: (context)=> MyStatelessWidget(),
        CalculatorScreen.id: (context) => CalculatorScreen(),
        Pedo.id: (context) => Pedo(),
      },
    );
  }
}
class MyStatelessWidget extends StatelessWidget {
  //const MyStatelessWidget({Key? key}) : super(key: key);
  static String id = 'main';
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alert'),
          content: const Text('This App uses various sensors which might drain the battery faster.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            FlatButton(
              //onPressed: () => Navigator.pop(context, 'OK'),
              onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(
                builder:(context)=>CalculatorScreen(),
              )),
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
      child: const Text('Run App'),
    );
  }
}
