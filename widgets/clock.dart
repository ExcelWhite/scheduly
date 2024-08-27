import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/functions/time_functions.dart';
import 'package:scheduly/state/theme_manager.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  String _currentDate = '';
  String _currentTime = '';
  String _previousTime = '';
  Timer? _timer;
  

  @override
    void initState() {
      super.initState();
      _updateTime();
    }

    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    List<String> timeDigits = _currentTime.split('');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50,),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _currentDate, 
              style: TextStyle(color: theme.clockColor),
              key: ValueKey(_currentDate),
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: timeDigits.asMap().entries.map((entry){
              String digit = entry.value;
              String previousDigit = _previousTime.isNotEmpty && _previousTime.length > entry.key ? _previousTime[entry.key] : '';
              double fontSize = entry.key < 6 ? 40 : 20;
              return Baseline(
                baseline: 48,
                baselineType: TextBaseline.alphabetic,
                child: _buildAnimatedDigit(digit, previousDigit, const Duration(milliseconds: 500), fontSize));
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedDigit(String digit, String previousDigit, Duration duration, double fontSize){

    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return SizedBox(
      width: fontSize*0.54,
      child: Center(
        child: AnimatedSwitcher(
          duration: duration,
          transitionBuilder: (child, animation){
            final inAnimation = Tween<Offset>(
              begin: const Offset(0, -0.7),
              end: Offset.zero,
            ).animate(animation);
        
            final outAnimation = Tween<Offset>(
              begin: const Offset(0, 0.7),
              end: Offset.zero,
            ).animate(animation);
        
            final fade = Tween<double> (begin: 0.0, end: 1.0).animate(animation);
        
            if(child.key == ValueKey(digit)){
              return FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: inAnimation,
                  child: child,
                ),
              );
            } else {
              return FadeTransition(
                opacity: fade,
                child: SlideTransition(
                  position: outAnimation,
                  child: child,
                ),
              );
            }
          },
        
          child: Text(
            digit,
            key: ValueKey<String>(digit),
            style: GoogleFonts.spaceMono(color: theme.clockColor, fontSize: fontSize, ),
          ),
        ),
      ),
    );
  }


  void _updateTime(){
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        DateTime now = DateTime.now();
        _currentDate = '${getWeekday(now.weekday)}, ${now.day}${getDaySuffix(now.day)} ${getMonth(now.month)}, ${now.year}';
        _previousTime = _currentTime;
        _currentTime = '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';
      });
    });
  }
}