import 'package:flutter/material.dart';
import 'package:flutter_bmi_calculator/constants.dart';

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        )
      ],
    );
  }
}
