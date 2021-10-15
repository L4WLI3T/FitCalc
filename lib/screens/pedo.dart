import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bmi_calculator/screens/chat_screen.dart';
import 'package:flutter_bmi_calculator/screens/calculator_screen.dart';
//import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';*/
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

/*void main() {
  runApp(MyApp());
}*/

class Pedo extends StatefulWidget {
  static String id = 'ped';
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Pedo> {


  Position _currP;
  String _currentAddress;
  final Geolocator geolocator = Geolocator();
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((
        Position position) {
      setState(() {
        _currP = position;
      });
      _getAddressFromLatLng();
    }
    );
  }
  _getAddressFromLatLng() async {
    try {
      var p = await placemarkFromCoordinates(
          _currP.latitude, _currP.longitude);
      var spd = _currP.speed;
      Placemark place = p[0];
      spd = double.parse((spd*3.6).toStringAsFixed(2));
      setState(() {
        _currentAddress =
        "📍${place.locality}, ${place.country} \n \t\t\t\t\t\t\t\t\t\t\t\t\t${spd} km/hr ";
      });
      //return _currentAddress;
    } catch (e) {
      print(e);
    }
  }


  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
      //mainAxisAlignment: MainAxisAlignment.center;
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Count Not Available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_currentAddress',
              ),
              Text(
                'Steps',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _steps,
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                    ? Icons.accessibility_new
                    : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}