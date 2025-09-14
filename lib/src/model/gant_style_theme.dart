import 'package:flutter/material.dart';

class GanntStyleTheme {
  // Layout and Sizing
  final double? cellHeight;
  final double? cellWidth;
  final double? headerHeight;
  final double? leftColumnWidth;
  final double? taskBarHeight;

  // Colors
  final Color? headerBackgroundColor;
  final Color? gridLineColor;
  final double? gridLineWidth;
  final Color? todayColumnColor;
  final Color? weekendColumnColor;

  // Text Styling
  final TextStyle? headerTextStyle;
  final TextStyle? propertyNameTextStyle;
  final TextStyle? taskTextStyle;

  /// Text style for the header day number
  final TextStyle? headerDayTextStyle;

  /// Text style for the header weekday name
  final TextStyle? headerWeekdayTextStyle;

  /// Text style for the task header
  final TextStyle? taskHeaderTextStyle;

  /// Text style for today's date in the header
  final TextStyle? todayTextStyle;

  /// Text style for weekend dates in the header
  final TextStyle? weekendTextStyle;

  // Task Appearance
  final double? taskBorderRadius;
  final EdgeInsets? taskPadding;
  final EdgeInsets? taskMargin;

  // Interaction
  final Color? hoverColor;

  const GanntStyleTheme({
    this.cellHeight = 42,
    this.cellWidth = 36,
    this.headerHeight,
    this.leftColumnWidth = 130,
    this.taskBarHeight = 20,
    this.headerBackgroundColor,
    this.gridLineColor,
    this.gridLineWidth = 1.0,
    this.todayColumnColor,
    this.weekendColumnColor,
    this.headerTextStyle,
    this.propertyNameTextStyle,
    this.taskTextStyle,
    this.headerDayTextStyle,
    this.headerWeekdayTextStyle,
    this.taskHeaderTextStyle,
    this.todayTextStyle,
    this.weekendTextStyle,
    this.taskBorderRadius = 5.0,
    this.taskPadding,
    this.taskMargin,
    this.hoverColor,
  });
}
