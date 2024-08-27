import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/state/theme_manager.dart';

class ReusableTextWidget extends StatelessWidget{
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const ReusableTextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: theme.primaryTextColor,
      ),
    );
  }
}

class ReusableButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ReusableButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width*0.7,
        height: 44,
        decoration: BoxDecoration(
          color: theme.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text, 
          style: TextStyle(color: theme.buttonTextColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



class ReusableConditionedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool condition;

  const ReusableConditionedButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    required this.condition,
  });


  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width*0.7,
        height: 44,
        decoration: BoxDecoration(
          color: condition ? theme.buttonColor : theme.clockColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text, 
          style: TextStyle(
            color: condition ? theme.buttonTextColor : theme.primaryTextColor, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

