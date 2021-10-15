import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmi_calculator/constants.dart';
import 'package:flutter_bmi_calculator/screens/calculator_screen.dart';
import 'package:flutter_bmi_calculator/screens/pedo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*void main() {
  runApp(ChatScreen());
}*/

final _firestore = Firestore.instance;
//FirebaseUser loggedInUser;
class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  //final _auth = FirebaseAuth.instance;

  String messageText;
  //@override
  //void initState(){
    //super.initState();
    //getCurrentUser();
  //}
  //void getCurrentUser() async {
    //try{
    //final user = await _auth.currentUser();
    //if(user != null){
      //loggedInUser = user;
    //}}
    //catch(e){
      //print(e);
    //}

  //}
  // void getMessages() async{
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   for(var message in messages.documents){
  //     print(message.data);
  //   }
  // }

  //}
  void messagesStream() async {
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.documents){
        print(message.data);
      }
    }
  }
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('FitCalc 🏃‍🚴‍🏋️‍🤸', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), ////
        backgroundColor: Color(0xFF0A0E21),
        //backgroundColor: Colors.lightBlueAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        //currentIndex: currentIndex = 0,
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
            icon: new Icon(Icons.message),
            title: new Text('Chat Support'),
          ),
        ],
        onTap: (index) {
          if(index==0)
            Navigator.pushNamed(context, Pedo.id);
          else if (index ==1)
            Navigator.pushNamed(context, CalculatorScreen.id);
          else if(index==2)
            Navigator.pushNamed(context, ChatScreen.id);
          /*setState(() {
            _selectedIndex = index;
          });*/
        },
        //currentIndex: 0,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.black,
        backgroundColor: Color(0xFFFFE082),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                        decoration: kMessageTextFieldDecoration.copyWith(hintText: "Type message", hintStyle: TextStyle(color: Colors.white), fillColor: Color(0xFF0A0E21), filled: true),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messages').add({
                          'text':messageText,
                          'sender': "Me",
                        });
                        if(messageText == "/help"){
                          _firestore.collection('messages').add({
                            'text':"This is FitCalc! \nType 1 to get information about BMI.\nType 2 to get information about Fat Percentage.\nType 3 to get in touch with the developers.",
                            'sender': "Bot",
                          });
                        }
                        else if(messageText == "1")
                          {
                            _firestore.collection('messages').add({
                              'text':"Body mass index (BMI) is a person’s weight in kilograms divided by the square of height in meters. BMI is an inexpensive and easy screening method for weight category—underweight, healthy weight, overweight, and obesity.BMI appears to be as strongly correlated with various metabolic and disease outcome as are these more direct measures of body fatness.",
                              'sender': "Bot",
                            });
                          }
                        else if(messageText == "2")
                          {
                            _firestore.collection('messages').add({
                              'text':"Body composition refers to the proportion of fat you have, relative to lean tissue (muscles, bones, body water, organs, etc). This measurement is a clearer indicator of your fitness. No matter what you weigh, the higher percentage of body fat you have, the more likely you are to develop obesity-related diseases, including heart disease, high blood pressure, stroke, and type 2 diabetes.",
                              'sender': "Bot",
                            });
                          }
                        else if(messageText=="3")
                          {
                            _firestore.collection('messages').add({
                              'text':"Email : fitcalc-auto-reply@fitcalc-support.com",
                              'sender': "Bot",
                            });
                          }
                        else if(messageText=="Hello" || messageText=="hello")
                          {
                            _firestore.collection('messages').add({
                              'text':"🤖 \n Hello user. \nType /help for any assistance.",
                              'sender': "Bot",
                            });
                          }
                        else if(messageText=="Thankyou"||messageText=="Thank You"||messageText=="thankyou"|| messageText=="thank you")
                          {
                            _firestore.collection('messages').add({
                              'text':"You're most welcome.",
                              'sender': "Bot",
                            });
                          }



                    },
                    child: Text(
                      '➤',
                      style: kSendButtonTextStyle.copyWith(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF0A0E21), ////
    );
  }
}

class MessagesStream extends StatelessWidget {
  // const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot){
        List<MessageBubble> messageBubbles = [];
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.yellow.shade100,
            ),

          );
        }
        var messages = snapshot.data.documents;
        var cnt = 0;
        var temp = [];
        for(var message in messages){
          var txt = message.data['text'];
          var sndr = message.data['sender'];
          temp.add([txt, sndr]);


        }

        var temp1 = temp.reversed.toList();
        // for(var message in temp1){
        //    print(message[0]);
        //
        // }



        // var messages = snapshot.data.documents.reversed;



        for(var message in temp1){

          final messageText = message[0];//message.data['text'];
          final messageSender = message[1];//message.data['sender'];
          //final currentUser = loggedInUser.email;

          // if(messageText == "/help"){
          //   temp.insert(cnt+1, ["Kya sahaayta kar sakta hu me aapki?", "Bot"]);
          // }

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: messageSender == "Me",
          );
          messageBubbles.add(messageBubble);

        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );


        return Column(
          children: messageBubbles,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)) : BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.grey.shade400: Colors.blueGrey.shade700,
            child: Padding(
              padding:EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                  '$text',
                   style: TextStyle(
                     fontSize: 15.0,
                     fontWeight: FontWeight.bold, ////
                     color: Colors.white, ////
                   ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
