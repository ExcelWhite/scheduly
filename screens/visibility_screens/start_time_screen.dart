import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/functions/time_functions.dart';
import 'package:scheduly/models/event.dart';
import 'package:scheduly/state/theme_manager.dart';
import 'package:scheduly/widgets/reusables.dart';
import 'package:table_calendar/table_calendar.dart';

class EventStartTimeScreen extends StatefulWidget {
  final Event event;
  final bool isFocusedOnEventStartTime;
  final Function(DateTime) onEventStartTimeChanged;
  final Function(bool) onFocusChanged;
  final Categories? selectedCategory;

  const EventStartTimeScreen({
    super.key,
    required this.event,
    required this.isFocusedOnEventStartTime,
    required this.onEventStartTimeChanged,
    required this.onFocusChanged,
    this.selectedCategory,
  });

  @override
  State<EventStartTimeScreen> createState() => _EventStartTimeScreenState();
}

class _EventStartTimeScreenState extends State<EventStartTimeScreen> {
  DateTime _selectedDateTime = DateTime.now();
  int _inferredPeriodIndex = 0;
  final List<String> _inferredPeriodOptions = ['Today', 'Tomorrow', 'This Week', 'Choose Date'];
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
    _selectedDateTime = widget.event.eventStartTime;
    _selectedHour = _selectedDateTime.hour;
    _selectedMinute = _selectedDateTime.minute;
    _updateExactDays();
  }

  void _fixSelectedDateTime(){
    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        _selectedHour,
        _selectedMinute,
      );
    });
  }

  void _updateExactDays() {
    _exactDays.clear();
    DateTime now = DateTime.now();

    switch (_inferredPeriodIndex) {
      case 0: // Today
        _selectedDateTime = isSameDay(_selectedDateTime, now) ? _selectedDateTime : now;
        _exactDays = [now];
        break;
      case 1: // Tomorrow
        DateTime tomorrow = now.add(const Duration(days: 1));
        _selectedDateTime = isSameDay(_selectedDateTime, tomorrow) ? _selectedDateTime : tomorrow;
        _exactDays = [tomorrow];
        break;
      case 2: // This Week
        int currentDay = now.weekday;
        for (int i = currentDay; i <= 7; i++) {
          _exactDays.add(now.add(Duration(days: i - currentDay)));
        }
        if (!_exactDays.contains(_selectedDateTime)) {
          _selectedDateTime = _exactDays.first;
        }
        break;
      case 3: // Choose Date
        // Maintain the current selected date if it was chosen manually
        break;
    }

    // Update hours and minutes after updating the exact days
    _calculateRemainingHours();
    _calculateRemainingMinutes();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_exactDayController.hasClients && _exactDays.isNotEmpty) {
        _exactDayController.jumpToPage(_exactDays.indexWhere((day) => isSameDay(day, _selectedDateTime)));
      }
    });
  }


  void _calculateRemainingHours() {
    _remainingHours.clear();
    DateTime now = DateTime.now();
    int startHour = (_selectedDateTime.day == now.day) ? now.hour : 0;

    for (int i = startHour; i < 24; i++) {
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
    DateTime now = DateTime.now();
    int startMinute = (_selectedDateTime.day == now.day && _selectedHour == now.hour) ? now.minute + 5 : 0;

    for (int i = startMinute; i < 60; i++) {
      _remainingMinutes.add(i);
    }

    if (!_remainingMinutes.contains(_selectedMinute)) {
      _selectedMinute = _remainingMinutes.first;
    }

    _selectedMinuteIndex = _remainingMinutes.indexOf(_selectedMinute);

    _fixSelectedDateTime();
  }

  Widget calendarWidget() {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return TableCalendar(
      focusedDay: _selectedDateTime,
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
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

    if (_inferredPeriodIndex == _inferredPeriodOptions.length - 1) {
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
              _fixSelectedDateTime();
              // _selectedHour = _remainingHours[_selectedHourIndex];
              // _selectedDateTime = _selectedDateTime.add(Duration(hours: _selectedHour - _selectedDateTime.hour));
              // _selectedMinute = _remainingMinutes[_selectedMinuteIndex];
              // _selectedDateTime = _selectedDateTime.add(Duration(minutes: _selectedMinute - _selectedDateTime.minute));
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
      visible: widget.isFocusedOnEventStartTime,
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
                        widget.onEventStartTimeChanged(_selectedDateTime);

                        int interval = widget.event.eventFinishTime.difference(_selectedDateTime).inMinutes;
                        if (interval < 30) {
                          DateTime adjustedFinishTime = _selectedDateTime.add(const Duration(minutes: 30));
                          widget.event.eventFinishTime = adjustedFinishTime;
                        }
                        widget.onFocusChanged(false);
                      },
                      text: 'Set Start Time',
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
