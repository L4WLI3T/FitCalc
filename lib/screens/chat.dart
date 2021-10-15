import 'package:flutter/material.dart';
import 'package:flutter_bmi_calculator/screens/pedo.dart';
import 'package:flutter_bmi_calculator/screens/calculator_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}

/*void main() {
  runApp(Chat());
}*/

class Chat extends StatefulWidget {
  static String id = 'cht';
  @override
  _chatbox createState() => _chatbox();
}

class _chatbox extends State<Chat> {
  final messageTextController = TextEditingController();
  int _selectedIndex = 2;
  String messageText;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('FitCalc 🏃‍🚴‍🏋️‍🤸‍'),
          ),
          bottomNavigationBar: BottomNavigationBar(
           //currentIndex: currentIndex = 2,
            currentIndex: _selectedIndex,
            items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fitness_center),
            title: new Text('Calculate'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Profile'),
          ),
          ],
          onTap: (index) {
          if(index==0)
            Navigator.pushNamed(context, Pedo.id);
          else if (index ==1)
            Navigator.pushNamed(context, CalculatorScreen.id);
          else if (index==2)
            Navigator.pushNamed(context, Chat.id);
          },
            selectedItemColor: Colors.red[800],
            unselectedItemColor: Colors.black,
            backgroundColor: Color(0xFFFFE082),
    /*setState(() {
            _selectedIndex = index;
          });*/
          ),

        body: Stack(
        children: <Widget>[
          Align(
        alignment: Alignment.bottomLeft,
          child: Container(
          padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
          height: 60,
          width: double.infinity,
          color: Colors.yellow.shade100,
          child: Row(
            children: <Widget>[
              /*GestureDetector(
                onTap: (){
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 20, ),
                ),
              ),*/
              SizedBox(width: 15,),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      //fillColor: Color(0xFF0A0E21),
                      hintText: "Type Help",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none
                  ),
                  controller: messageTextController,
                  onChanged: (value){
                    messageText=value;
                  },
                ),
              ),
              SizedBox(width: 15,),
              FloatingActionButton(
                onPressed: (){},
                child: Icon(Icons.send,color: Colors.white,size: 18,),
                backgroundColor: Colors.indigo.shade300,
                elevation: 0,
              ),
            ],

          ),
        ),
      ),
      ],
    ),
    ),
    );
    //throw UnimplementedError();
  }

}
