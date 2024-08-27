import 'package:flutter/material.dart';

class AppColors{
  static const Color lightThemePrimaryTextColor = Colors.black;
  static const Color darkThemePrimaryTextColor = Colors.white;

  static const Color buttonTextColor = Colors.white;
  static const Color buttonColor = Colors.pink;
  static const Color buttonShadeColor = Color.fromARGB(255, 202, 44, 97);

  static const Color lightThemeBackgroundColor = Colors.white;
  static const Color darkThemeBackgroundColor = Colors.black;

  static const Color lightThemeClockColor = Colors.black54;
  static const Color darkThemeClockColor = Colors.white60;

  static const Color lightThemeIconColor = Colors.black;
  static const Color darkThemeIconColor = Colors.white;

  static const Color workCategory = Color(0xff4567b7);
  static const Color personalCategory = Color(0xff8bc34a);
  static const Color errandsCategory = Color(0xfff7dc6f);
  static const Color shoppingCategory = Color(0xffffa07a);
  static const Color meetingCategory = Color(0xff7a288a);
  static const Color familyCategory = Color(0xff34c759);
  static const Color wellnessCategory = Color(0xffb2fffc);
  static const Color travelCategory = Color(0xff0097a7);
  static const Color urgentCategory = Color(0xffff3737);
  static const Color lowPriorityCategory = Color(0xffe5e5ea);



}

List<String> quotes = [
  "Believe you can and you're halfway there. - Theodore Roosevelt",
  "Dream big, work hard. - Anonymous",
  "Start where you are. Use what you have. Do what you can. - Arthur Ashe",
  "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
  "The only limit to our realization of tomorrow is our doubts of today. - Franklin D. Roosevelt",
  "Your only limit is your mind. - Anonymous",
  "Don't watch the clock; do what it does. Keep going. - Sam Levenson",
  "It always seems impossible until it's done. - Nelson Mandela",
  "Turn your wounds into wisdom. - Oprah Winfrey",
  "The harder the struggle, the more glorious the triumph. - Anonymous",
  "Success is the sum of small efforts, repeated day in and day out. - Robert Collier",
  "Push yourself, because no one else is going to do it for you. - Anonymous",
  "Believe in your dreams and they may come true; believe in yourself and they will come true. - Anonymous",
  "The best way to predict the future is to create it. - Peter Drucker",
  "Challenges are what make life interesting. Overcoming them is what makes life meaningful. - Joshua J. Marine",
  "You are stronger than you think. - Anonymous",
  "Do something today that your future self will thank you for. - Anonymous",
  "Every accomplishment starts with the decision to try. - John F. Kennedy",
  "Failure is the opportunity to begin again more intelligently. - Henry Ford",
  "You don’t have to be great to start, but you have to start to be great. - Zig Ziglar",
];

enum Categories {
  none,
  work,
  personal,
  errands,
  shopping,
  meeting,
  family,
  wellness,
  travel,
  urgent,
  lowPriority,
}

Icon getCategoryIcon(Categories category) {
  switch (category) {
    case Categories.work:
      return const Icon(Icons.work, color: AppColors.workCategory);
    case Categories.personal:
      return const Icon(Icons.person, color: AppColors.personalCategory);
    case Categories.errands:
      return const Icon(Icons.shopping_bag, color: AppColors.errandsCategory);
    case Categories.shopping:
      return const Icon(Icons.shopping_cart, color: AppColors.shoppingCategory);
    case Categories.meeting:
      return const Icon(Icons.meeting_room, color: AppColors.meetingCategory);
    case Categories.family:
      return const Icon(Icons.family_restroom, color: AppColors.familyCategory);
    case Categories.wellness:
      return const Icon(Icons.fitbit, color: AppColors.wellnessCategory);
    case Categories.travel:
      return const Icon(Icons.flight, color: AppColors.travelCategory);
    case Categories.urgent:
      return const Icon(Icons.warning, color: AppColors.urgentCategory);
    case Categories.lowPriority:
      return const Icon(Icons.low_priority, color: AppColors.lowPriorityCategory);
    default:
      return const Icon(Icons.help);
  }
}