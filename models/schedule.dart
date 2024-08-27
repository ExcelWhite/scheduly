import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scheduly/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedule extends ChangeNotifier{
  final List<Event> _schedule =[];
  
  void addEvent(Event event) {
    _schedule.add(event);
    notifyListeners();
  }

  void removeEvent(Event event){
    _schedule.remove(event);
    saveSchedule();
    notifyListeners();
  }


  void updateEvent(Event updatedEvent){
    int eventIndex = _schedule.indexWhere((event) => event.eventId == updatedEvent.eventId);
    _schedule[eventIndex] =updatedEvent;
    saveSchedule();
    notifyListeners();
  }


  Future<void> saveSchedule() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodeData = jsonEncode(
      _schedule.map<Map<String, dynamic>>((event) => event.toJson()).toList(),
    );

    prefs.setString('schedule', encodeData);
  }

  Future<void> loadSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodeData = prefs.getString('schedule');
    if (encodeData != null) {
      print('schedule is not empyt');
      List<dynamic> decodedData = jsonDecode(encodeData);
      List<Map<String, dynamic>> scheduleData = decodedData.map(
        (e) => e as Map<String, dynamic>).toList();
      _schedule.clear();
      _schedule.addAll(
        scheduleData.map<Event>((event) => Event.fromJson(event)).toList()
      );
      notifyListeners();
    }
    else{
      print('shedule is empty');
    }

  }

  List<Event> get schedule => _schedule;
  
}