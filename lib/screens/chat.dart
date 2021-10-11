import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';


void main() => runApp(WeatherApp(storage: WeatherStorage()));


class WeatherStorage {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    print(directory.path);

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/weatherlogs.txt');
  }


  Future<File> writeWeather(String Weather) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$Weather\n', mode: FileMode.append);  ////
  }
}

class WeatherApp extends StatefulWidget {
  static String id = 'weather_app';
  const WeatherApp({key, this.storage}) : super(key: key);
  final WeatherStorage storage;

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  int temperature = 0;
  String location = 'Mumbai';
  int woeid = 2487956;
  String weather = 'clear';
  String abbreviation = '';
  String errorMessage = '';
  Position _currentPosition;
  final Geolocator geolocator = Geolocator();
  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((
  Position position) {
  setState(() {
  _currentPosition = position;
  });
  }
  String _currentAddress;

  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  initState() {
    super.initState();
    fetchLocation();
  }

  void fetchSearch(String input) async {
    try {
      var searchResult = await http.get(searchApiUrl + input);
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage =
        "Sorry, we don't have data about this city. Try another one.";
      });
    }
  }

  Future<File> fetchLocation() async {
    var locationResult = await http.get(locationApiUrl + woeid.toString());
    var result = json.decode(locationResult.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];

    /*setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ', '').toLowerCase();
      abbreviation = data["weather_state_abbr"];
    });*/
  }

  void onTextFieldSubmitted(String input) async {
    fetchSearch(input);
    fetchLocation();
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      /*List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
*/
      List p=["hello"];
      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "mumbai";
        temperature = 10;
        weather = 'sunny';
      });
      onTextFieldSubmitted(place.locality);
      print(place.locality);
      return widget.storage.writeWeather(_currentAddress + " -> $temperature," + weather);
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/$weather.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: temperature == null
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _getCurrentLocation();
                    },
                    child: Icon(Icons.location_city, size: 36.0),
                  ),
                )
              ],
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Image.network(
                        'https://www.metaweather.com/static/img/weather/png/' +
                            abbreviation +
                            '.png',
                        width: 100,
                      ),
                    ),
                    Center(
                      child: Text(
                        temperature.toString() + ' °C',
                        style: TextStyle(
                            color: Colors.white, fontSize: 60.0),
                      ),
                    ),
                    Center(
                      child: Text(
                        location,
                        style: TextStyle(
                            color: Colors.white, fontSize: 40.0),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: TextField(
                        onSubmitted: (String input) {
                          onTextFieldSubmitted(input);
                        },
                        style:
                        TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                          hintText: 'Search another location...',
                          hintStyle: TextStyle(
                              color: Colors.white, fontSize: 18.0),
                          prefixIcon:
                          Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(right: 32.0, left: 32.0),
                      child: Text(errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize:
                              Platform.isAndroid ? 15.0 : 20.0)),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}