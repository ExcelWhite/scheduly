import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/models/schedule.dart';
import 'package:scheduly/scheduly.dart';
import 'package:scheduly/state/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initializeTheme();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeManager(),
        ),
        ChangeNotifierProvider(
          create: (_) => Schedule()
        )
      ],
      child: const Scheduly(),
    )
  );
}

