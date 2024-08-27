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

class ScheduleListView extends StatefulWidget {
  const ScheduleListView({super.key});

  @override
  State<ScheduleListView> createState() => _ScheduleListViewState();
}

class _ScheduleListViewState extends State<ScheduleListView> {
  int _openedTileIndex = -1;

  @override
  Widget build(BuildContext context) {
    var schedule = Provider.of<Schedule>(context, listen: false);
    var theme = Provider.of<ThemeManager>(context).currentTheme;    

    return Expanded(
      child: ListView.builder(
        itemCount: schedule.schedule.length,
        itemBuilder: (context, index){
          var event = schedule.schedule[index];
            
          return GestureDetector(
            onTap: (){
              setState(() {
                if(_openedTileIndex == index){
                  _openedTileIndex = -1;
                } else {
                  _openedTileIndex = index;
                }
              });
            },
            child: ListTile(
              title: Container(
                height: _openedTileIndex == index ? 150 : 50,
                decoration: BoxDecoration(
                  color: event.eventCategoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10, 
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                        color: event.eventCategoryColor
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _openedTileIndex == index
                          ? ReusableTextWidget(
                            text: '#${event.eventId}', 
                            fontSize: 10, 
                            fontWeight: FontWeight.normal,
                          )
                          : const SizedBox(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.65,
                          child: Text(
                            _openedTileIndex == index
                              ? event.eventName
                              : event.eventName.length > 20 ? '${event.eventName.substring(0,20)}...' : event.eventName,
                            style: TextStyle(color: event.eventCategoryColor, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.65,
                          child: Text(
                            _openedTileIndex == index
                              ? event.eventDescription
                              :event.eventDescription.length > 20 ? '${event.eventDescription.substring(0,20)}...' : event.eventDescription,
                            style: TextStyle(color: event.eventCategoryColor, fontSize: 12),
                          ),
                        ),
                        _openedTileIndex == index
                          ? ReusableTextWidget(
                            text: 'starts on ${getWeekday(event.eventStartTime.weekday)}, '
                                  '${event.eventStartTime.day}${getDaySuffix(event.eventStartTime.day)} '
                                  '${getMonth(event.eventStartTime.month)}. '
                                  '${event.eventStartTime.hour.toString().padLeft(2, '0')}:'
                                  '${event.eventStartTime.minute.toString().padLeft(2, '0')}',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          )
                          : const SizedBox(),
                        _openedTileIndex == index
                          ? ReusableTextWidget(
                            text: 'finishes on ${getWeekday(event.eventFinishTime.weekday)}, '
                                  '${event.eventFinishTime.day}${getDaySuffix(event.eventFinishTime.day)} '
                                  '${getMonth(event.eventFinishTime.month)}. '
                                  '${event.eventFinishTime.hour.toString().padLeft(2, '0')}:'
                                  '${event.eventFinishTime.minute.toString().padLeft(2, '0')}',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          )
                          : const SizedBox(),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                        _openedTileIndex == index
                          ? IconButton(
                            onPressed: () => _editEvent(event), 
                            icon: Icon(Icons.edit, color: theme.iconColor,),
                          ) : const SizedBox(),
                        _openedTileIndex == index
                          ? IconButton(
                            onPressed: () => _deleteEvent(event, theme), 
                            icon: Icon(Icons.delete, color: theme.iconColor),
                          ) : const SizedBox(),
                      ]
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          );
        }
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