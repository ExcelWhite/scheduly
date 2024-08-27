import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/models/event.dart';
import 'package:scheduly/state/theme_manager.dart';

class EventDescriptionScreen extends StatefulWidget {
  final Event event;
  final Categories? selectedCategory;
  final Function(String) onEventDescriptionChanged;
  final bool isFocusedOnEventDescription;
  final FocusNode eventDescriptionFocusNode;
  final TextEditingController eventDescriptionController;

  const EventDescriptionScreen({
    super.key,
    required this.event,
    this.selectedCategory,
    required this.onEventDescriptionChanged,
    required this.isFocusedOnEventDescription,
    required this.eventDescriptionFocusNode,
    required this.eventDescriptionController,
  });

  @override
  State<EventDescriptionScreen> createState() => _EventDescriptionScreenState();
}

class _EventDescriptionScreenState extends State<EventDescriptionScreen> {
  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeManager>(context).currentTheme;

    return Visibility(
      visible: widget.isFocusedOnEventDescription,
      
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: theme.backgroundColor.withOpacity(0.95),
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: widget.eventDescriptionController,
                focusNode: widget.eventDescriptionFocusNode,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.primaryTextColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.selectedCategory == null
                      ? theme.clockColor.withOpacity(0.2)
                      : widget.event.eventCategoryColor.withOpacity(0.2),
                ),
                maxLength: 64,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                maxLines: 2,

                onChanged: (value) {
                  setState(() {
                    widget.onEventDescriptionChanged(widget.eventDescriptionController.text);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}