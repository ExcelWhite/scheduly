import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduly/constants.dart';
import 'package:scheduly/models/event.dart';
import 'package:scheduly/state/theme_manager.dart';

class CategoryScreen extends StatefulWidget {
  final Event event;
  final ValueChanged<Categories> onCategoryChanged;
  final bool isCategoryListVisible;

  const CategoryScreen({
    super.key, 
    required this.event, 
    required this.onCategoryChanged,
    required this.isCategoryListVisible
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeManager>(context).currentTheme;

    return Visibility(
      visible: widget.isCategoryListVisible,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.backgroundColor.withOpacity(0.8),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: Categories.values
                .where((category) => category != Categories.none)
                .map((Categories category) {
                  return Column(
                    children: [
                      ListTile(
                        leading: getCategoryIcon(category),
                        title: Text(
                          category == Categories.lowPriority
                              ? 'low priority'
                              : category.toString().split('.').last,
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.primaryTextColor,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            widget.onCategoryChanged(category);
                            
                          });
                        },
                      ),
                      Divider(
                        thickness: 1,
                        color: theme.clockColor,
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  // void showCategoryList() {
  //   setState(() {
  //     _isCategoryListVisible = true;
  //   });
  // }
}