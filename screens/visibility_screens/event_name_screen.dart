import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/models/event.dart';
import 'package:scheduly/state/theme_manager.dart';

class EventNameScreen extends StatefulWidget {
  final Event event;
  final Categories? selectedCategory;
  final Function(String) onEventNameChanged;
  final bool isFocusedOnEventName;
  final FocusNode eventNameFocusNode;
  final TextEditingController eventNameController;

  const EventNameScreen({
    super.key,
    required this.event,
    this.selectedCategory,
    required this.onEventNameChanged,
    required this.isFocusedOnEventName,
    required this.eventNameFocusNode,
    required this.eventNameController,
  });

  @override
  State<EventNameScreen> createState() => _EventNameScreenState();
}

class _EventNameScreenState extends State<EventNameScreen> {
  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeManager>(context).currentTheme;

    return Visibility(
      visible: widget.isFocusedOnEventName,

      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: theme.backgroundColor.withOpacity(0.8),
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: widget.eventNameController,
                focusNode: widget.eventNameFocusNode,
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
                maxLength: 32,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,

                onChanged: (value) {
                  setState(() {
                    widget.onEventNameChanged(widget.eventNameController.text);
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