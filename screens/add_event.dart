import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/functions/animated_functions.dart';
import 'package:scheduly/functions/time_functions.dart';
import 'package:scheduly/models/event.dart';
import 'package:scheduly/models/schedule.dart';
import 'package:scheduly/screens/schedule_screen.dart';
import 'package:scheduly/screens/visibility_screens/category_screen.dart';
import 'package:scheduly/screens/visibility_screens/event_description.dart';
import 'package:scheduly/screens/visibility_screens/event_name_screen.dart';
import 'package:scheduly/screens/visibility_screens/finish_time_screen.dart';
import 'package:scheduly/screens/visibility_screens/start_time_screen.dart';
import 'package:scheduly/state/theme_manager.dart';
import 'package:scheduly/widgets/reusables.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> with TickerProviderStateMixin{
  late Event _event;
  Categories? _selectedCategory;
  bool _isCategoryListVisible = false;
  bool _isFocusedOnEventName = false;
  bool _isFocusedOnEventDescription = false;
  bool _isFocusedOnEventStartTime = false;
  bool _isFocusedOnEventFinishTime = false;

  bool _isAddToScheduleEnabled = false;
  

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  


  final FocusNode _eventNameFocusNode = FocusNode();
  final FocusNode _eventDescriptionFocusNode = FocusNode();

  late AnimationController _animationController;

  
  @override
  void initState() {
    super.initState();
    _event = Event(
      id: _generateUniqueId(),
      name: '',
      description: '',
      startTime: DateTime.now().add(const Duration(hours: 0)).subtract(Duration (seconds: DateTime.now().second)),
      finishTime: DateTime.now().add(const Duration(hours: 3)),
      category: Categories.none,
    );

    initFocusListeners();

    _animationController = AnimationController(
      duration:  const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();   
  }  

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventNameFocusNode.dispose();
    _eventDescriptionController.dispose();
    _eventDescriptionFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateAddToScheduleButtonState() {
    print(' category: ${_event.eventCategory}');
    setState(() {
      // _isAddToScheduleEnabled = _selectedCategory != Categories.none
      //   && _event.eventName.isNotEmpty
      //   && _event.eventDescription.isNotEmpty
      //   && _event.eventFinishTime.difference(
      //       _event.eventStartTime
      //       ).inMinutes > 30;

      if(_event.eventCategory != Categories.none
        && _event.eventName.isNotEmpty
        && _event.eventDescription.isNotEmpty
        && _event.eventFinishTime.difference(
            _event.eventStartTime
            ).inMinutes > 30){
        _isAddToScheduleEnabled = true;
      }          
    });
  }
  
  void initFocusListeners(){
    _eventNameFocusNode.addListener(() {
      if (!_eventNameFocusNode.hasFocus) {
        setState(() {
          _isFocusedOnEventName = false;
        });
      }
    });
    _eventDescriptionFocusNode.addListener(() {
      if (!_eventDescriptionFocusNode.hasFocus) {
        setState(() {
          _isFocusedOnEventDescription = false;
        });
      }
    });
  }

  Widget eventNameWidget(){
    var theme = Provider.of<ThemeManager>(context).currentTheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isFocusedOnEventName = true;
        });
        _eventNameFocusNode.requestFocus();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _selectedCategory == null
              ? theme.primaryTextColor.withOpacity(0.2)
              : _event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Text(
          _event.eventName == '' 
              ? 'Make breakfast|'
              : _event.eventName,
          style: TextStyle(
            fontSize: 16,
            color: _event.eventName == ''
                ? theme.primaryTextColor.withOpacity(0.2)
                : theme.primaryTextColor
          ),
        ),
      ),
    );
  }

  Widget eventDescriptionWidget(){
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFocusedOnEventDescription = true;
        });
        _eventDescriptionFocusNode.requestFocus();
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _selectedCategory == null
              ? theme.primaryTextColor.withOpacity(0.2)
              : _event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Text(
          _event.eventDescription == '' 
              ? 'Oat meal and scrambled e...|'
              : _event.eventDescription,
          style: TextStyle(
            fontSize: 16,
            color: _event.eventDescription == ''
                ? theme.primaryTextColor.withOpacity(0.2)
                : theme.primaryTextColor
          ),
        ),
      ),
    );
  }

  Widget eventStartTimeWidget(){
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFocusedOnEventStartTime = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _selectedCategory == null
              ? theme.primaryTextColor.withOpacity(0.2)
              : _event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Text('${getWeekday(_event.eventStartTime.weekday)}, ${_event.eventStartTime.day}${getDaySuffix(_event.eventStartTime.day)} ${getMonth(_event.eventStartTime.month)}'),
            Text('${_event.eventStartTime.hour.toString().padLeft(2, '0')} : ${_event.eventStartTime.minute.toString().padLeft(2, '0')}'),
          ],
        ),
      ),
    );
  }

  Widget eventFinishTimeWidget(){
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFocusedOnEventFinishTime = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _selectedCategory == null
              ? theme.primaryTextColor.withOpacity(0.2)
              : _event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Text('${getWeekday(_event.eventFinishTime.weekday)}, ${_event.eventFinishTime.day}${getDaySuffix(_event.eventFinishTime.day)} ${getMonth(_event.eventFinishTime.month)}'),
            Text('${_event.eventFinishTime.hour.toString().padLeft(2, '0')} : ${_event.eventFinishTime.minute.toString().padLeft(2, '0')}'),
          ],
        ),
      ),
    );
  }
  
  String _getAppBarTitle() {
    if (_isCategoryListVisible) {
      return 'Choose Category';
    } else if (_isFocusedOnEventName) {
      return 'Event Name';
    } else if (_isFocusedOnEventDescription) {
      return 'Event Description';
    } else if (_isFocusedOnEventStartTime) {
      return 'Set Start Time';
    } else if (_isFocusedOnEventFinishTime) {
      return 'Set Finish Time';
    } else {
      return 'Add an Event';
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    var theme = Provider.of<ThemeManager>(context).currentTheme;

    AnimatePageSlide animatePageSlide = AnimatePageSlide(context);
    void goToSchedulesPage() {
      animatePageSlide.animatedPageSlide(const ScheduleScreen());
    }

    void addEventToSchedule() async {
      final schedule = Provider.of<Schedule>(context, listen: false);
      schedule.addEvent(_event);
      await schedule.saveSchedule();

      goToSchedulesPage();
    }

    void _unfocus(FocusNode focus){
      focus.unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              AnimatedIcon(
                icon: AnimatedIcons.event_add,
                progress: _animationController,
                size: 30,
                color: theme.iconColor,
              ),
              const SizedBox(width: 10),
              Text(_getAppBarTitle()),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (_isFocusedOnEventName) {
            _unfocus(_eventNameFocusNode);
          } else if(_isFocusedOnEventDescription){
            _unfocus(_eventDescriptionFocusNode);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: deviceWidth,
                height: deviceHeight,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: theme.backgroundColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCategoryListVisible = true;
                        });
                      },
                      child: Container(
                        width: 160,
                        height: 44,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: _selectedCategory == null
                                      ? null
                                      : getCategoryIcon(_event.eventCategory),
                                ),
                                Text(
                                  _selectedCategory == null
                                      ? 'Choose Category'
                                      : _selectedCategory.toString().split('.').last,
                                ),
                                Icon(
                                  Icons.expand_circle_down_outlined,
                                  color: theme.iconColor,
                                ),
                              ],
                            ),
                            Divider(
                              height: 10,
                              color: _selectedCategory == null
                                  ? theme.clockColor
                                  : _event.eventCategoryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Event card container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedCategory == null
                              ? theme.clockColor
                              : _event.eventCategoryColor,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Event Name: '),
                          eventNameWidget(),
                          const SizedBox(height: 10),
                          const Text('Event Description: '),
                          eventDescriptionWidget(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Start time'),
                              eventStartTimeWidget(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Finish time'),
                              eventFinishTimeWidget(),
                            ],
                          ),
              
                        ],
                      ),
                    ),
                    const SizedBox(height: 100,),
                    ReusableConditionedButtonWidget(
                      text: 'Add to Schedule',
                      onTap: _isAddToScheduleEnabled ? addEventToSchedule : (){},
                      condition: _isAddToScheduleEnabled,
                    ),
                  ],
                ),
              ),
            ),
            
            CategoryScreen(
              event: _event, 
              onCategoryChanged: (value){
                setState(() {
                  _selectedCategory = value;
                  _event.eventCategory = value;
                  _isCategoryListVisible = false;
                  _updateAddToScheduleButtonState();
                });
              },
              isCategoryListVisible: _isCategoryListVisible,
            ),

            EventNameScreen(
              event: _event, 
              onEventNameChanged: (value){
                setState(() {
                  _event.eventName = value;
                  _updateAddToScheduleButtonState();
                });
              }, 
              isFocusedOnEventName: _isFocusedOnEventName, 
              eventNameFocusNode: _eventNameFocusNode, 
              eventNameController: _eventNameController,
              selectedCategory: _selectedCategory,
            ),

            EventDescriptionScreen(
              event: _event, 
              onEventDescriptionChanged: (value){
                setState(() {
                  _event.eventDescription = value;
                  _updateAddToScheduleButtonState();
                });
              }, 
              isFocusedOnEventDescription: _isFocusedOnEventDescription, 
              eventDescriptionFocusNode: _eventDescriptionFocusNode, 
              eventDescriptionController: _eventDescriptionController,
              selectedCategory: _selectedCategory,
            ),

            EventStartTimeScreen(
              event: _event, 
              isFocusedOnEventStartTime: _isFocusedOnEventStartTime,
              onEventStartTimeChanged: (value){
                setState(() {
                  _event.eventStartTime = value;
                  _updateAddToScheduleButtonState();
                });
              },
              onFocusChanged: (value) {
                setState(() {
                  _isFocusedOnEventStartTime = value;
                });
              },
              selectedCategory: _selectedCategory,
            ),

            EventFinishTimeScreen(
              event: _event, 
              isFocusedOnEventFinishTime: _isFocusedOnEventFinishTime, 
              onEventFinishTimeChanged: (value){
                setState(() {
                  _event.eventFinishTime = value;
                  _updateAddToScheduleButtonState();
                });
              }, 
              onFocusChanged: (value){
                setState(() {
                  _isFocusedOnEventFinishTime = value;
                });
              }
            ),
          ],
        ),
      ),
    );
  }

  int _generateUniqueId(){
    Random random = Random();
    int id;

    final schedule = Provider.of<Schedule>(context, listen: false);

    List<int> existingIds = schedule.schedule.map((event) => event.eventId).toList();
    print(existingIds);

    do {
      id = random.nextInt(900000) + 99999;
    } while (existingIds.contains(id));

    return id;
  }
}
