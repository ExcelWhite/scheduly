import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/screens/add_event.dart';
import 'package:scheduly/screens/home_screen.dart';
import 'package:scheduly/state/theme_manager.dart';

class Scheduly extends StatelessWidget {
  const Scheduly({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Scheduly',
          theme: themeManager.currentTheme.getTheme(),
          home: const HomeScreen(),

          routes: {
            '/home': (context) => const HomeScreen(),
            '/add_event': (context) => const AddEvent(),
          },
        );

      }
      
    );
  }
}