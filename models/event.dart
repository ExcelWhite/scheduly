

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scheduly/constants.dart';

class Event{
  int _id;
  String _name;
  String _description;
  DateTime _startTime;
  DateTime _finishTime;
  Categories _category;
  Color? _categoryColor;
  
  Event({
    required int id, 
    required String name,
    required String description,
    required DateTime startTime,
    required DateTime finishTime,
    required Categories category,
  }):
  _id = id,
  _name = name,
  _description = description,
  _startTime = startTime,
  _finishTime = finishTime,
  _category = category{
    _categoryColor = _findCategoryColor(category);
  }
  

  int get eventId => _id;
  String get eventName => _name;
  String get eventDescription => _description;
  DateTime get eventStartTime => _startTime;
  DateTime get eventFinishTime => _finishTime;
  Categories get eventCategory => _category;
  Color get eventCategoryColor => _categoryColor!;

  set eventId(int id) => _id = id;
  set eventName(String name) => _name = name;
  set eventDescription(String description) => _description = description;
  set eventStartTime(DateTime startTime) => _startTime = startTime;
  set eventFinishTime(DateTime finishTime) => _finishTime = finishTime;
  set eventCategory(Categories category) {
    _category = category;
    _categoryColor = _findCategoryColor(category);
  }

  Color _findCategoryColor(Categories category) {
    switch(category){
      case Categories.none:
        return Colors.transparent;
      case Categories.work:
        return AppColors.workCategory;
      case Categories.personal:
        return AppColors.personalCategory;
      case Categories.errands:
        return AppColors.errandsCategory;
      case Categories.shopping:
        return AppColors.shoppingCategory;
      case Categories.meeting:
        return AppColors.meetingCategory;
      case Categories.family:
        return AppColors.familyCategory;
      case Categories.wellness:
        return AppColors.wellnessCategory;
      case Categories.travel:
        return AppColors.travelCategory;
      case Categories.urgent:
        return AppColors.urgentCategory;
      case Categories.lowPriority:
        return AppColors.lowPriorityCategory;
      default:
        throw Exception('Invalid category');
    }
  }


  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name,
    'description': _description,
    'startTime': _startTime.toIso8601String(),
    'finishTime': _finishTime.toIso8601String(),
    'category': _category.index,
  };

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      finishTime: DateTime.parse(json['finishTime']),
      category: Categories.values[json['category']],
    );
  }

}