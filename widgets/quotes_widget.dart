import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/state/theme_manager.dart';

class QuotesWidget extends StatefulWidget {
  const QuotesWidget({super.key});

  @override
  State<QuotesWidget> createState() => _QuotesWidgetState();
}

class _QuotesWidgetState extends State<QuotesWidget> {
  int _quoteIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 8), 
      (timer) {
        _updateQuote();
      });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        transitionBuilder: (child, animation) {
          final inAnimation = Tween<Offset>(
            begin: const Offset(-2, 0),
            end: Offset.zero,
          ).animate(animation);

          final outAnimation = Tween<Offset>(
            begin: const Offset(2, 0),
            end: Offset.zero,
          ).animate(animation);

          final fade = Tween<double> (begin: 0.0, end: 1.0).animate(animation);

          if(child.key == ValueKey(quotes[_quoteIndex])){
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
          quotes[_quoteIndex],
          key: ValueKey(quotes[_quoteIndex]),
          style: TextStyle(fontSize: 20, color: theme.iconColor),
          ),
      ),
    );
  }
  
  void _updateQuote() {
    setState(() {
      _quoteIndex = Random().nextInt(quotes.length);
    });
  }
}