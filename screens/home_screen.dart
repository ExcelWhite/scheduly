import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/functions/animated_functions.dart';
import 'package:scheduly/screens/add_event.dart';
import 'package:scheduly/screens/schedule_screen.dart';
import 'package:scheduly/state/theme_manager.dart';
import 'package:scheduly/widgets/clock.dart';
import 'package:scheduly/widgets/quotes_widget.dart';
import 'package:scheduly/widgets/reusables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    
    void changeTheme(int index){
      Provider.of<ThemeManager>(context, listen: false).changeTheme(index);
    }

    AnimatePageSlide animatePageSlide = AnimatePageSlide(context);
    void goToSchedulesPage(){
      animatePageSlide.animatedPageSlide(const ScheduleScreen());
    }

    void goToAddEventPage(){
      animatePageSlide.animatedPageSlide(const AddEvent());
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Scheduly')),
        backgroundColor: theme.backgroundColor,
        actions: [
          theme.name == 'light'
          ? IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            onPressed: () => changeTheme(1),
            )
          : IconButton(
            icon: const Icon(Icons.light_mode),
            onPressed: () => changeTheme(0),
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 100, left: 10, right: 10, bottom: 80),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 40),
                    width: deviceWidth*0.45,
                    height: deviceHeight*0.4,
                    decoration: BoxDecoration(
                      color: theme.buttonColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Add an Event',
                          style: TextStyle(fontSize: 20, color: theme.buttonTextColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 50,),
                        GestureDetector(
                          onTap: goToAddEventPage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.buttonShadeColor,
                            ),
                            child: Icon(Icons.add, color: theme.buttonTextColor, size: 60,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //const Spacer(),
                const ClockWidget(),
              ],
            ),
            const Spacer(),
            const QuotesWidget(),
            const Spacer(),
            ReusableButtonWidget(
              text: 'View my Schedules',
              onTap: goToSchedulesPage,
            ),
          ],
        ),
      ),
    );
  }
}