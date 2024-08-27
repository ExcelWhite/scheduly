import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/functions/animated_functions.dart';
import 'package:scheduly/models/schedule.dart';
import 'package:scheduly/screens/add_event.dart';
import 'package:scheduly/screens/home_screen.dart';
import 'package:scheduly/screens/schedule_views/grid_view.dart';
import 'package:scheduly/screens/schedule_views/list_view.dart';
import 'package:scheduly/state/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>  {
  String _currentView = '';

  @override
  void initState() {
    super.initState();
    _loadScehdule();
    _initView();

  }

  void _loadScehdule() async {
    var schedule = Provider.of<Schedule>(context, listen: false);
    await schedule.loadSchedule();
    setState(() {});
  }

  Widget _loadView() {
    if (_currentView == 'list'){
      return const ScheduleListView();
    }
    else if (_currentView == 'grid'){
      return const ScheduleGridView();
    }
    else if (_currentView.isEmpty){
      return const Center(child: CircularProgressIndicator(),);
    }
    else{
      return Container();
    }
  }

  void _initView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? view = prefs.getString('view');

    if(view == null){
      prefs.setString('view', 'list');
      setState(() {
        _currentView = 'list';
      });
    } else {
      setState(() {
        _currentView = view;
      });
    }

    _loadView();
  }

void _saveView() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('view', _currentView);
}



  @override
  Widget build(BuildContext context) {
    AnimatePageSlide animatePageSlide = AnimatePageSlide(context);
    void goToAddEventPage(){
      animatePageSlide.animatedPageSlide(const AddEvent());
    }

    void goToHomeScreen(){
      animatePageSlide.animatedPageSlide(const HomeScreen());
    }
    
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('My Schedule')
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: goToHomeScreen,
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.backgroundColor
        ),

        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                IconButton(
                  onPressed: (){
                    setState(() {
                      _currentView = 'list';
                    });
                    _saveView();
                  }, 
                  icon: Icon(
                    Icons.list_rounded,
                    color: _currentView == 'list'
                      ? theme.buttonColor
                      : theme.iconColor,
                  ),
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      _currentView = 'grid';
                    });
                    _saveView();
                  }, 
                  icon: Icon(
                    Icons.grid_view_rounded,
                    color: _currentView == 'grid'
                      ? theme.buttonColor
                      : theme.iconColor
                  ),
                ),
               ],
              ),
              _loadView(),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.buttonColor,
        foregroundColor: theme.buttonTextColor,
        onPressed: goToAddEventPage,
        tooltip: 'Add and event',
        child: const Icon(Icons.add, size: 40,),
      ),
    );
  }
}