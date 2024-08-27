import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/functions/time_functions.dart';
import 'package:scheduly/models/event.dart';
import 'package:scheduly/state/theme_manager.dart';
import 'package:scheduly/widgets/reusables.dart';
import 'package:table_calendar/table_calendar.dart';

class EventFinishTimeScreen extends StatefulWidget {
  final Event event;
  final bool isFocusedOnEventFinishTime;
  final Function(DateTime) onEventFinishTimeChanged;
  final Function(bool) onFocusChanged;
  final Categories? selectedCategory;

  const EventFinishTimeScreen({
    super.key,
    required this.event,
    required this.isFocusedOnEventFinishTime,
    required this.onEventFinishTimeChanged,
    required this.onFocusChanged,
    this.selectedCategory
  });

  @override
  State<EventFinishTimeScreen> createState() => _EventFinishTimeScreenState();
}

class _EventFinishTimeScreenState extends State<EventFinishTimeScreen> {
  DateTime _selectedDateTime = DateTime.now();
  int _inferredPeriodIndex = 0;
  List<String> _inferredPeriodOptions = [];
  final PageController _inferredPeriodController = PageController(viewportFraction: 0.5);
  final PageController _exactDayController = PageController(viewportFraction: 0.5);
  List<DateTime> _exactDays = [];
  
  List<int> _remainingHours = [];
  int _selectedHourIndex = 0;
  int _selectedHour = 0;

  List<int> _remainingMinutes = [];
  int _selectedMinuteIndex = 0;
  int _selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.event.eventFinishTime;
    _selectedHour = _selectedDateTime.hour;
    _selectedMinute = _selectedDateTime.minute;
    _updateInferredPeriodList();
    _updateExactDays();
  }

  void _fixSelectedDateTime(){
    _selectedDateTime = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      _selectedHour,
      _selectedMinute
    );
  }

  void _updateInferredPeriodList(){
    int todayDate = DateTime.now().day;
    int todayWeekDay = DateTime.now().weekday;
    int startDate = widget.event.eventStartTime.day;
    int startWeekDay = widget.event.eventStartTime.weekday;

    if(startDate - todayDate >= 7){
      _inferredPeriodOptions = ['Choose Date'];
    } else if(startDate - todayDate > 1 && startWeekDay <= todayWeekDay){
      _inferredPeriodOptions = ['Choose Date'];
    } else if(startWeekDay - todayWeekDay > 1 && startWeekDay > todayWeekDay){
      _inferredPeriodOptions = ['This Week', 'Choose Date'];
    } else if(startDate - todayDate == 1){
      _inferredPeriodOptions = ['Tomorrow', 'This Week', 'Choose Date'];
    } else {
      _inferredPeriodOptions = ['Today', 'Tomorrow', 'This Week', 'Choose Date'];
    }
  }
  void _updateExactDays() {
    _exactDays.clear();
    DateTime now = DateTime.now();
    DateTime start = widget.event.eventStartTime;

    Map<String, Function> optionsMap = {
      'Today': () {
        _selectedDateTime = isSameDay(_selectedDateTime, start) ? _selectedDateTime : start;
        _exactDays = [start];
      },
      'Tomorrow': () {
        DateTime tomorrow = now.add(const Duration(days: 1));
        _selectedDateTime = isSameDay(_selectedDateTime, tomorrow) ? _selectedDateTime : tomorrow;
        _exactDays = [tomorrow];
      },
      'This Week': () {
        int startDay = start.weekday;

        for (int i = startDay; i <= 7; i++) {
          _exactDays.add(start.add(Duration(days: i - startDay)));
        }
      },
      'Choose Date': () {
        // Maintain the current selected date if it was chosen manually
      },

    };
    if (_inferredPeriodIndex >= 0 && _inferredPeriodIndex < _inferredPeriodOptions.length) {
      optionsMap[_inferredPeriodOptions[_inferredPeriodIndex]]?.call();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_exactDayController.hasClients && _exactDays.isNotEmpty) {
        _exactDayController.jumpToPage(_exactDays.indexWhere((day) => isSameDay(day, _selectedDateTime)));
      }
    });
  }

  void _calculateRemainingHours() {
    _remainingHours.clear();
    DateTime startDay = widget.event.eventStartTime;
    
    int startHour = startDay.hour;
    int startMinute = startDay.minute;

    int finishHour = 0;

    if(_selectedDateTime.day == startDay.day){
      if(startMinute > 30){
        finishHour = startHour + 1;
      }
      finishHour = startHour;
    } 

    

    for (int i = finishHour; i < 24; i++) {
      _remainingHours.add(i);
    }

    if (!_remainingHours.contains(_selectedHour)) {
      _selectedHour = _remainingHours.first;
    } else{ 
      _selectedHourIndex = _remainingHours.indexOf(_selectedHour);
    }

    _fixSelectedDateTime();
  }

  void _calculateRemainingMinutes() {
    _remainingMinutes.clear();
    //DateTime now = DateTime.now();
    DateTime startDay = widget.event.eventStartTime;

    // If the selected hour is the start hour and on the start day
    if (_selectedDateTime.day == startDay.day && _selectedHour == startDay.hour) {
      int finishMinute = startDay.minute + 30; // Set the minimum selectable minute to start time + 15
      for (int i = finishMinute; i < 60; i++) {
        _remainingMinutes.add(i);
      }
    } else {
      // Otherwise, allow all minutes
      for (int i = 0; i < 60; i++) {
        _remainingMinutes.add(i);
      }
    }

    if (!_remainingMinutes.contains(_selectedMinute)) {
      _selectedMinute = _remainingMinutes.first;
    } else{ 
      _selectedMinuteIndex = _remainingMinutes.indexOf(_selectedMinute);
    }

    _fixSelectedDateTime();
  }

  Widget calendarWidget() {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    DateTime start = widget.event.eventStartTime;

    if (_selectedDateTime.isBefore(start)) {
      _selectedDateTime = start;
    }
    return TableCalendar(
      focusedDay: _selectedDateTime,
      firstDay: start,
      lastDay: start.add(const Duration(days: 365)),
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      selectedDayPredicate: (day) => isSameDay(_selectedDateTime, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDateTime = selectedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _selectedDateTime = focusedDay;
        });
      },

      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.selectedCategory != null 
              ? widget.event.eventCategoryColor.withOpacity(0.6)
              : theme.buttonShadeColor.withOpacity(0.6),
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.selectedCategory != null
              ? widget.event.eventCategoryColor
              : theme.buttonShadeColor,
        ),
      ),
    );
  }

  Widget inferredPeriodWidget() {
    var theme = Provider.of<ThemeManager>(context).currentTheme;

    _updateInferredPeriodList();
    _updateExactDays();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inferredPeriodController.hasClients) {
        _inferredPeriodController.jumpToPage(_inferredPeriodIndex);
      }
    });



    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.6,
      child: PageView.builder(
        controller: _inferredPeriodController,
        onPageChanged: (index) {
          setState(() {
            _inferredPeriodIndex = index;
            _updateExactDays();
          });
        },
        itemCount: _inferredPeriodOptions.length,
        itemBuilder: (context, index) {
          final bool isCurrentOption = index == _inferredPeriodIndex;

          return AnimatedBuilder(
            animation: _inferredPeriodController,
            builder: (context, child) {
              double value = 1.0;
              if (_inferredPeriodController.position.haveDimensions) {
                value = _inferredPeriodController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Center(
                  child: Text(
                    _inferredPeriodOptions[index],
                    style: TextStyle(
                      fontSize: isCurrentOption ? 20 : 16,
                      color: isCurrentOption ? theme.primaryTextColor : theme.clockColor,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget exactDayWidget() {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_exactDayController.hasClients && _exactDays.isNotEmpty) {
        int pageIndex = _exactDays.indexWhere((day) => isSameDay(day, _selectedDateTime));
        if (pageIndex >= 0) {
          _exactDayController.jumpToPage(pageIndex);
        }
      }
    });

    if (_inferredPeriodIndex == _inferredPeriodOptions.length-1) {

      return Column(
        key: ValueKey(_selectedDateTime),
        children: [
          calendarWidget(),
        ],
      );
    } else {
      _calculateRemainingHours();
      _calculateRemainingMinutes();
      return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.6,
        child: PageView.builder(
          controller: _exactDayController,
          onPageChanged: (index) {
            setState(() {

              _selectedDateTime = _exactDays[index];
              _selectedHour = _remainingHours[_selectedHourIndex];
              _selectedDateTime = _selectedDateTime.add(Duration(hours: _selectedHour - _selectedDateTime.hour));
              _selectedMinute = _remainingMinutes[_selectedMinuteIndex];
              _selectedDateTime = _selectedDateTime.add(Duration(minutes: _selectedMinute - _selectedDateTime.minute));
            });
          },
          itemCount: _exactDays.length,
          itemBuilder: (context, index) {
            DateTime day = _exactDays[index];
            return AnimatedBuilder(
              animation: _exactDayController,
              builder: (context, child) {
                double value = 1.0;
                if (_exactDayController.position.haveDimensions) {
                  value = _exactDayController.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Center(
                    child: Text(
                      getExactDay(day.weekday),
                      style: TextStyle(
                        fontSize: index == _exactDays.indexWhere((day) => isSameDay(day, _selectedDateTime)) ? 20 : 16,
                        color: index == _exactDays.indexWhere((day) => isSameDay(day, _selectedDateTime)) ? theme.primaryTextColor : theme.clockColor,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }

  Widget selectHourWidget() {
    var theme = Provider.of<ThemeManager>(context).currentTheme;

    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.2,
      child: ListWheelScrollView.useDelegate(
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 50,
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedHourIndex = index;
            _selectedHour = _remainingHours[index];
            _fixSelectedDateTime();
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final hour = _remainingHours[index];
            return Center(
              child: Text(
                hour.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 20,
                  color: index == _selectedHourIndex ? theme.primaryTextColor : theme.clockColor,
                ),
              ),
            );
          },
          childCount: _remainingHours.length,
        ),
      ),
    );
  }

  Widget selectMinuteWidget() {
    var theme = Provider.of<ThemeManager>(context).currentTheme;

    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.2,
      child: ListWheelScrollView.useDelegate(
        physics: const FixedExtentScrollPhysics(),
        itemExtent: 50,
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedMinuteIndex = index;
            _selectedMinute = _remainingMinutes[index];
            _fixSelectedDateTime();
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final minute = _remainingMinutes[index];
            return Center(
              child: Text(
                minute.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 20,
                  color: index == _selectedMinuteIndex ? theme.primaryTextColor : theme.clockColor,
                ),
              ),
            );
          },
          childCount: _remainingMinutes.length,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return Visibility(
      visible: widget.isFocusedOnEventFinishTime,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                widget.onFocusChanged(false);
              },
              child: Container(
                color: theme.backgroundColor.withOpacity(0.9),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: theme.backgroundColor.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    inferredPeriodWidget(),
                    const SizedBox(height: 10),
                    exactDayWidget(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectHourWidget(),
                        const SizedBox(width: 10),
                        Text(
                          ':',
                          style: TextStyle(
                            fontSize: 24,
                            color: theme.primaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        selectMinuteWidget(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ReusableButtonWidget(
                      onTap: () {
                        widget.onEventFinishTimeChanged(_selectedDateTime);
                        widget.onFocusChanged(false);
                      },
                      text: 'Set Finish Time',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
