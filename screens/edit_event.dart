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

class EditEvent extends StatefulWidget {
  final Event event;

  EditEvent({required this.event});
  
  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  bool _isCategoryListVisible = false;
  bool _isFocusedOnEventName = false;
  bool _isFocusedOnEventDescription = false;
  bool _isFocusedOnEventStartTime = false;
  bool _isFocusedOnEventFinishTime = false;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

  final FocusNode _eventNameFocusNode = FocusNode();
  final FocusNode _eventDescriptionFocusNode = FocusNode();

  //late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    initFocusListeners();

    _eventNameController.text = widget.event.eventName;
    _eventDescriptionController.text = widget.event.eventDescription;
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventNameFocusNode.dispose();
    _eventDescriptionController.dispose();
    _eventDescriptionFocusNode.dispose();
    //_animationController.dispose();
    super.dispose();
  }

  void _updateEventName() {
    setState(() {
      widget.event.eventName = _eventNameController.text;
    });
  }

  void _updateEventDescription() {
    setState(() {
      widget.event.eventDescription = _eventDescriptionController.text;
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
          color: widget.event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Text(widget.event.eventName,
          style: TextStyle(
            fontSize: 16,
            color: theme.primaryTextColor
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
          color: widget.event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Text(widget.event.eventDescription,
          style: TextStyle(
            fontSize: 16,
            color: theme.primaryTextColor
          ),
        ),
      ),
    );
  }

  Widget eventStartTimeWidget(){
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
          color: widget.event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Text('${getWeekday(widget.event.eventStartTime.weekday)}, ${widget.event.eventStartTime.day}${getDaySuffix(widget.event.eventStartTime.day)} ${getMonth(widget.event.eventStartTime.month)}'),
            Text('${widget.event.eventStartTime.hour.toString().padLeft(2, '0')} : ${widget.event.eventStartTime.minute.toString().padLeft(2, '0')}'),
          ],
        ),
      ),
    );
  }

  Widget eventFinishTimeWidget(){
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
          color: widget.event.eventCategoryColor.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Text('${getWeekday(widget.event.eventFinishTime.weekday)}, ${widget.event.eventFinishTime.day}${getDaySuffix(widget.event.eventFinishTime.day)} ${getMonth(widget.event.eventFinishTime.month)}'),
            Text('${widget.event.eventFinishTime.hour.toString().padLeft(2, '0')} : ${widget.event.eventFinishTime.minute.toString().padLeft(2, '0')}'),
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
      return 'Edit Event';
    }
  }

  @override
  Widget build(BuildContext context) {
    var schedule = Provider.of<Schedule>(context, listen: false);
    Event updatedEvent = widget.event;
    _eventNameController.addListener(_updateEventName);
    _eventDescriptionController.addListener(_updateEventDescription);

    var theme = Provider.of<ThemeManager>(context).currentTheme;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    AnimatePageSlide animatePageSlide = AnimatePageSlide(context);
    void goToSchedulesPage() {
      animatePageSlide.animatedPageSlide(const ScheduleScreen());
    }

    void _unfocus(FocusNode focus){
      focus.unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(_getAppBarTitle())),
      ),

      body: Stack(
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
                    onTap: (){
                      setState(() {
                        _isCategoryListVisible = true;
                      });
                    },
                    child: SizedBox(
                      width: 160,
                      height: 44,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(child: getCategoryIcon(widget.event.eventCategory),),
                              Text(widget.event.eventCategory.toString().split('.').last),
                              Icon(Icons.expand_circle_down_outlined, color: theme.iconColor),
                            ],
                          ),
                          Divider(height: 10, color: widget.event.eventCategoryColor,)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: widget.event.eventCategoryColor, width: 4),
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
                  ReusableButtonWidget(
                    text: 'Done', 
                    onTap: () {
                      schedule.updateEvent(updatedEvent);
                      goToSchedulesPage();
                    }
                  )
                ],
              ),
            ),
          ),

          CategoryScreen(
            event: widget.event, 
            onCategoryChanged: (value){
              setState(() {
                widget.event.eventCategory = value;
                _isCategoryListVisible = false;
              });
            }, 
            isCategoryListVisible: _isCategoryListVisible
          ),

          EventNameScreen(
            event: widget.event, 
            onEventNameChanged: (value){
              setState(() {
                widget.event.eventName = value;
              });
            }, 
            isFocusedOnEventName: _isFocusedOnEventName, 
            eventNameFocusNode: _eventNameFocusNode, 
            eventNameController: _eventNameController,
            selectedCategory: widget.event.eventCategory,
          ),

          EventDescriptionScreen(
            event: widget.event, 
            onEventDescriptionChanged: (value){
              setState(() {
                widget.event.eventDescription = value;
              });
            }, 
            isFocusedOnEventDescription: _isFocusedOnEventDescription, 
            eventDescriptionFocusNode: _eventDescriptionFocusNode, 
            eventDescriptionController: _eventDescriptionController,
            selectedCategory: widget.event.eventCategory,
          ),

          EventStartTimeScreen(
            event: widget.event, 
            isFocusedOnEventStartTime: _isFocusedOnEventStartTime,
            onEventStartTimeChanged: (value){
              setState(() {
                widget.event.eventStartTime = value;
              });
            },
            onFocusChanged: (value) {
              setState(() {
                _isFocusedOnEventStartTime = value;
              });
            },
            selectedCategory: widget.event.eventCategory,
          ),

          EventFinishTimeScreen(
            event: widget.event, 
            isFocusedOnEventFinishTime: _isFocusedOnEventFinishTime, 
            onEventFinishTimeChanged: (value){
              setState(() {
                widget.event.eventFinishTime = value;
              });
            }, 
            onFocusChanged: (value){
              setState(() {
                _isFocusedOnEventFinishTime = value;
              });
            }
          ),
        ]
      ),
    );
  }
}