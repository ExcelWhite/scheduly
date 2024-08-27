import 'package:flutter/material.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/models/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier{
  final List<AppTheme> _themes = [
    AppTheme(
      name: 'light',
      primaryTextColor: AppColors.lightThemePrimaryTextColor,
      buttonTextColor: AppColors.buttonTextColor,
      buttonColor: AppColors.buttonColor,
      buttonShadeColor: AppColors.buttonShadeColor,
      backgroundColor: AppColors.lightThemeBackgroundColor,
      clockColor: AppColors.lightThemeClockColor,
      iconColor: AppColors.lightThemeIconColor,
    ),


    AppTheme(
      name: 'dark',
      primaryTextColor: AppColors.darkThemePrimaryTextColor,
      buttonTextColor: AppColors.buttonTextColor,
      buttonColor: AppColors.buttonColor,
      buttonShadeColor: AppColors.buttonShadeColor,
      backgroundColor: AppColors.darkThemeBackgroundColor,
      clockColor: AppColors.darkThemeClockColor,
      iconColor: AppColors.darkThemeIconColor,
    ),
  ];

  int _currentTheme = 0;


  AppTheme get currentTheme => _themes[_currentTheme];
  List<AppTheme> get themes => _themes;

  ThemeManager(){
    initTheme();
    print('inits');
  }

  void changeTheme(int index){
    _currentTheme = index;
    _saveTheme();
    notifyListeners();
  }

  static Future<void> initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('theme');
    if (themeName == null) {
      await prefs.setString('theme', 'light');
    }
  }
  
  Future<void> initTheme() async{
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString('theme');
    if (themeName == null) {
      await _setDefaultTheme();
    } else {
      _currentTheme = _themes.indexWhere((theme) => theme.name == themeName);
    }
    notifyListeners();
    print(themeName);
  }
  _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', _themes[_currentTheme].name);
  }

  _setDefaultTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', 'light');
    _currentTheme = 0;
  }
}