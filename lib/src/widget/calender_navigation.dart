import 'package:flutter/material.dart';
import 'package:gantt_calendar/src/extension/date_ext.dart';

class CalenderNavigation extends StatelessWidget {
  const CalenderNavigation({
    super.key,
    required this.dateTime,
    required this.navigateToPrevPage,
    required this.navigateToNextPage,
  });

  final DateTime dateTime;
  final VoidCallback navigateToPrevPage;
  final VoidCallback navigateToNextPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: navigateToPrevPage,
          icon: Icon(Icons.keyboard_arrow_left_outlined),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(dateTime.months, textAlign: TextAlign.center),
            SizedBox(height: 4),
            Text('${dateTime.year}', textAlign: TextAlign.center),
          ],
        ),
        IconButton(
          onPressed: navigateToNextPage,
          icon: Icon(Icons.keyboard_arrow_right_outlined),
        ),
      ],
    );
  }
}
