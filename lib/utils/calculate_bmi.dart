import 'dart:math';

class BmiLogic {
  BmiLogic({this.height, this.weight,this.gender,this.waist,this.neck});

  //final Gender selectedGender;
  final int gender;
  final int height;
  final int weight;
  final int waist;
  final int neck;

  double _bmi;
  double _fp;

  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String calculateFP()
  {
    if(gender==1)
      _fp = (495/(1.0324-0.19077*(log(waist-neck)/log(10))+ 0.15456*log(height)/log(10))) - 450;
    else
      _fp = (495/(1.29597-0.35004*(log(waist-neck)/log(10))+ 0.22100*log(height)/log(10))) - 450;
    return _fp.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi >= 25) {
      return 'Overweight';
    } else if (_bmi > 18.5) {
      return 'Normal';
    } else {
      return 'Underweight';
    }
  }

  String getInterpretation() {
    if (_bmi >= 25) {
      return 'You have a higher than normal body weight.\n Try to exercise more.\n ';
    } else if (_bmi >= 18.5) {
      return 'You have a normal body weight try maintaining it.\n Good job!\n ';
    } else {
      return 'You have a lower than normal body weight.\n You can eat a bit more & exercise.\n ';
    }
  }
}