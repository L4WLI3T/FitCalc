import 'package:flutter/material.dart';
import 'package:flutter_bmi_calculator/components/bottom_button.dart';
import 'package:flutter_bmi_calculator/components/icon_content.dart';
import 'package:flutter_bmi_calculator/components/reusable_card.dart';
import 'package:flutter_bmi_calculator/components/round_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bmi_calculator/constants.dart';
import 'package:flutter_bmi_calculator/utils/calculate_bmi.dart';
import 'result_screen.dart';
import 'package:flutter_logs/flutter_logs.dart';





enum Gender {
  male,
  female,
}

class CalculatorScreen extends StatefulWidget {
  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class navState extends State<CalculatorScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('FitCalc 🏃‍🚴‍🏋️‍🤸'),
    ),
    resizeToAvoidBottomPadding: false,
     bottomNavigationBar: BottomNavigationBar(
          //currentIndex: currentIndex = 0,
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
      ),
    );
  }
}
/*void _onItemTapped(int index) {
  setState(() {
    index = index;
  });
}*/


class CalculatorScreenState extends State<CalculatorScreen> {
  Gender selectedGender;
  int gender = 0;
  int height = 180;
  int weight = 60;
  int age = 20;
  int neck = 50;
  int waist = 90;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FitCalc 🏃‍🚴‍🏋️‍🤸'),
      ),
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
          //currentIndex: currentIndex = 0,
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
        currentIndex: 1,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.black,
        backgroundColor: Color(0xFFFFE082),
        //onTap: _onItemTapped,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      onPress: () {
                        setState(() {
                          selectedGender = Gender.male;
                          gender = 1;
                        });
                      },
                      colour: selectedGender == Gender.male
                          ? kActiveCardColour
                          : kInactiveCardColour,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.mars,
                        label: 'MALE',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      onPress: () {
                        setState(() {
                          selectedGender = Gender.female;
                          gender = 2;
                        });
                      },
                      colour: selectedGender == Gender.female
                          ? kActiveCardColour
                          : kInactiveCardColour,
                      cardChild: IconContent(
                        icon: FontAwesomeIcons.venus,
                        label: 'FEMALE',
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'HEIGHT',
                    style: kLabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        height.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        'cm',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: Color(0xFF8D8E98),
                      activeTrackColor: Colors.white,
                      thumbColor: Color(0xFFEB1555),
                      overlayColor: Color(0x29EB1555),
                      thumbShape:
                      RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                      RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Slider(
                      value: height.toDouble(),
                      min: 120.0,
                      max: 220.0,
                      onChanged: (double newValue) {
                        setState(() {
                          height = newValue.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'WAIST',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          waist.toString(),
                          style: kNumberTextStyle,
                          //style: TextStyle(height: 5, fontSize: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  setState(() {
                                    waist--;
                                  });
                                }),
                            SizedBox(
                              width: 20.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  waist++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'NECK',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          neck.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(
                                      () {
                                    neck--;
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                onPressed: () {
                                  setState(() {
                                    neck++;
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'WEIGHT',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          weight.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  setState(() {
                                    weight--;
                                  });
                                }),
                            SizedBox(
                              width: 20.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'AGE',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          age.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(
                                      () {
                                    age--;
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                onPressed: () {
                                  setState(() {
                                    age++;
                                  });
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomButton(
            buttonTitle: 'CALCULATE',
            onTap: () {
              /*FlutterLogs.logThis(
                  tag: "Local",
                  subTag: 'Data Entry',
                  logMessage: calc.calculateBMI(),
                  error: e,
                  level: LogLevel.ERROR);
              logMessage = e.stackTrace.toString();*/
              BmiLogic calc =
              BmiLogic(height: height, weight: weight, gender:gender, waist:waist, neck:neck);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(
                    bmiResult: calc.calculateBMI(),
                    fatResult: calc.calculateFP(),
                    resultText: calc.getResult(),
                    interpretation: calc.getInterpretation(),

                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
