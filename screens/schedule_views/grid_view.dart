import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/functions/animated_functions.dart';
import 'package:scheduly/functions/time_functions.dart';
import 'package:scheduly/models/event.dart';
import 'package:scheduly/models/schedule.dart';
import 'package:scheduly/models/theme.dart';
import 'package:scheduly/screens/edit_event.dart';
import 'package:scheduly/state/theme_manager.dart';
import 'package:scheduly/widgets/reusables.dart';

class ScheduleGridView extends StatefulWidget {
  const ScheduleGridView({super.key});

  @override
  State<ScheduleGridView> createState() => _ScheduleGridViewState();
}

class _ScheduleGridViewState extends State<ScheduleGridView> {
    
  @override
  Widget build(BuildContext context) {
    var schedule = Provider.of<Schedule>(context, listen: false);
    var theme = Provider.of<ThemeManager>(context).currentTheme;

    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(schedule.schedule.length, (index) {
          var event = schedule.schedule[index];
          return Card(
            color: event.eventCategoryColor.withOpacity(0.4),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        textAlign: TextAlign.end,
                        '${getWeekday(event.eventStartTime.weekday)}, '
                        '${event.eventStartTime.day}${getDaySuffix(event.eventStartTime.day)} '
                        '${getMonth(event.eventStartTime.month)}. '
                        '${event.eventStartTime.hour.toString().padLeft(2, '0')}:'
                        '${event.eventStartTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: event.eventCategoryColor, fontSize: 12, ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    event.eventName,
                    style: TextStyle(color: event.eventCategoryColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    event.eventDescription,
                    style: TextStyle(color: event.eventCategoryColor, fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableTextWidget(
                            text: event.eventFinishTime.isBefore(DateTime.now())
                              ? 'ended'
                              : event.eventStartTime.isBefore(DateTime.now())
                                  ? 'started'
                                  : event.eventStartTime.weekday - DateTime.now().weekday == 1
                                      ? 'starts'
                                      : 'starts in',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                          ReusableTextWidget(
                            text: event.eventStartTime.isBefore(DateTime.now())
                                ? ' ' : _startTimeComment(event.eventStartTime),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(onPressed: () => _editEvent(event), icon: const Icon(Icons.edit)),
                      IconButton(onPressed: () => _deleteEvent(event, theme), icon: const Icon(Icons.delete))
                    ],
                  ),
                ]
              ),
            ),
          );
        }),
      ),
    );
  }

  void _editEvent(Event event){
    AnimatePageSlide animatePageSlide = AnimatePageSlide(context);
    animatePageSlide.animatedPageSlide(EditEvent(event: event,));
  }

  void _deleteEvent(Event event, AppTheme theme) async{
    
    bool confirm = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: theme.backgroundColor,
        title: Text('Delete Event', style: TextStyle(color: theme.primaryTextColor)),
        content: const Text('Are you sure you want to cancel this event?'),
        actions: [
          TextButton(
            child: Text('Not really', style: TextStyle(color: theme.buttonColor),),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("I'm sure", style: TextStyle(color: theme.buttonColor),),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ]
      )
    );
    if (confirm) {
      setState(() {
        Provider.of<Schedule>(context, listen: false).removeEvent(event);
      }); 
    }

  }  

  String _startTimeComment(DateTime startTime){
    DateTime now = DateTime.now();
    String comment = 'd';
    int wd = startTime.weekday - now.weekday;
    int d = startTime.difference(now).inDays;
    int h = startTime.difference(now).inHours;
    int m = startTime.difference(now).inMinutes;

    if(wd == 1 && d <=2 ){
      comment = 'tomorrow';
    }
    else if(d > 1){
      comment = '$d days';
    }else if(d == 1){
      comment = 'tomorrow';
    } else if(d==0 && h > 1){
      comment = '$h hours';
    } else if(d==0 && h == 1){
      comment = '$h hour';
    } else if(d==0 && h == 0 && m > 15){
      comment = '$m minutes';
    } else {
      comment = 'few minutes';
    } 
    return comment;
  }
}