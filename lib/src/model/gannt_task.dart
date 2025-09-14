import 'package:flutter/material.dart';

class GanntTask {
  final DateTime? startDate;
  final DateTime? endDate;
  final Color color;
  final Color textColor;
  final String assignedTo;
  final String task;

  GanntTask({
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.textColor,
    required this.assignedTo,
    required this.task,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GanntTask && other.task == task;
  }

  @override
  int get hashCode => task.hashCode;
}
