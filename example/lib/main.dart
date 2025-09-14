import 'package:flutter/material.dart';
import 'package:gantt_calendar/gantt_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<GanntTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _generateTasks();
  }

  void _generateTasks() {
    final now = DateTime.now();

    // Last month tasks
    final lastMonth = DateTime(now.year, now.month - 1, 15);

    _tasks.addAll([
      GanntTask(
        startDate: DateTime(lastMonth.year, lastMonth.month, 2),
        endDate: DateTime(lastMonth.year, lastMonth.month, 12),
        color: Colors.purple.shade300,
        textColor: Colors.white,
        assignedTo: 'Alice Chen',
        task: 'Research Phase',
      ),
      GanntTask(
        startDate: DateTime(lastMonth.year, lastMonth.month, 5),
        endDate: DateTime(lastMonth.year, lastMonth.month, 15),
        color: Colors.purple.shade200,
        textColor: Colors.white,
        assignedTo: 'Alice Chen',
        task: 'Competitor Analysis',
      ),
      GanntTask(
        startDate: DateTime(lastMonth.year, lastMonth.month, 14),
        endDate: DateTime(lastMonth.year, lastMonth.month, 24),
        color: Colors.indigo.shade300,
        textColor: Colors.white,
        assignedTo: 'Mike Wilson',
        task: 'Requirements Gathering',
      ),
      GanntTask(
        startDate: DateTime(lastMonth.year, lastMonth.month, 16),
        endDate: DateTime(lastMonth.year, lastMonth.month, 26),
        color: Colors.indigo.shade200,
        textColor: Colors.white,
        assignedTo: 'Mike Wilson',
        task: 'User Story Creation',
      ),
      GanntTask(
        startDate: DateTime(lastMonth.year, lastMonth.month, 8),
        endDate: DateTime(lastMonth.year, lastMonth.month, 18),
        color: Colors.cyan.shade300,
        textColor: Colors.white,
        assignedTo: 'Chris Green',
        task: 'Market Analysis',
      ),
      GanntTask(
        startDate: DateTime(lastMonth.year, lastMonth.month, 20),
        endDate: DateTime(now.year, now.month, 2),
        color: Colors.lime.shade400,
        textColor: Colors.black,
        assignedTo: 'Patricia Clark',
        task: 'Initial Prototyping',
      ),
    ]);

    // Tasks spanning from last month to current month
    _tasks.add(
      GanntTask(
        startDate: DateTime(lastMonth.year, lastMonth.month, 25),
        endDate: DateTime(now.year, now.month, 5),
        color: Colors.teal.shade300,
        textColor: Colors.white,
        assignedTo: 'Sarah Johnson',
        task: 'Architecture Planning',
      ),
    );

    // Current month tasks
    _tasks.addAll([
      GanntTask(
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 3)),
        color: Colors.blue.shade300,
        textColor: Colors.white,
        assignedTo: 'John Doe',
        task: 'Design UI',
      ),
      GanntTask(
        startDate: now.subtract(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 4)),
        color: Colors.blue.shade200,
        textColor: Colors.white,
        assignedTo: 'John Doe',
        task: 'Wireframing',
      ),
      GanntTask(
        startDate: now.add(const Duration(days: 4)),
        endDate: now.add(const Duration(days: 8)),
        color: Colors.green.shade300,
        textColor: Colors.white,
        assignedTo: 'Jane Smith',
        task: 'Develop Backend',
      ),
      GanntTask(
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 10)),
        color: Colors.green.shade200,
        textColor: Colors.white,
        assignedTo: 'Jane Smith',
        task: 'Database Design',
      ),
      GanntTask(
        startDate: now.add(const Duration(days: 9)),
        endDate: now.add(const Duration(days: 12)),
        color: Colors.orange.shade300,
        textColor: Colors.white,
        assignedTo: 'Bob Johnson',
        task: 'Testing',
      ),
      GanntTask(
        startDate: now.add(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 7)),
        color: Colors.pink.shade200,
        textColor: Colors.white,
        assignedTo: 'Emily Davis',
        task: 'Frontend Development',
      ),
      GanntTask(
        startDate: now.add(const Duration(days: 6)),
        endDate: now.add(const Duration(days: 14)),
        color: Colors.brown.shade300,
        textColor: Colors.white,
        assignedTo: 'Daniel Martinez',
        task: 'API Integration',
      ),
    ]);

    // Next month tasks
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    _tasks.addAll([
      GanntTask(
        startDate: DateTime(nextMonth.year, nextMonth.month, 5),
        endDate: DateTime(nextMonth.year, nextMonth.month, 15),
        color: Colors.red.shade300,
        textColor: Colors.white,
        assignedTo: 'David Lee',
        task: 'User Acceptance Testing',
      ),
      GanntTask(
        startDate: DateTime(nextMonth.year, nextMonth.month, 8),
        endDate: DateTime(nextMonth.year, nextMonth.month, 18),
        color: Colors.red.shade200,
        textColor: Colors.white,
        assignedTo: 'David Lee',
        task: 'Bug Fixing',
      ),
      GanntTask(
        startDate: DateTime(nextMonth.year, nextMonth.month, 10),
        endDate: DateTime(nextMonth.year, nextMonth.month, 20),
        color: Colors.amber.shade300,
        textColor: Colors.black,
        assignedTo: 'Emma Garcia',
        task: 'Documentation',
      ),
      GanntTask(
        startDate: DateTime(nextMonth.year, nextMonth.month, 12),
        endDate: DateTime(nextMonth.year, nextMonth.month, 22),
        color: Colors.amber.shade200,
        textColor: Colors.black,
        assignedTo: 'Emma Garcia',
        task: 'Release Notes',
      ),
      GanntTask(
        startDate: DateTime(nextMonth.year, nextMonth.month, 18),
        endDate: DateTime(nextMonth.year, nextMonth.month, 28),
        color: Colors.deepOrange.shade300,
        textColor: Colors.white,
        assignedTo: 'James White',
        task: 'Performance Tuning',
      ),
      GanntTask(
        startDate: DateTime(nextMonth.year, nextMonth.month, 25),
        endDate: DateTime(nextMonth.year, nextMonth.month + 1, 5),
        color: Colors.blueGrey.shade400,
        textColor: Colors.white,
        assignedTo: 'Olivia Harris',
        task: 'Launch Preparation',
      ),
    ]);

    // Task spanning current to next month
    _tasks.add(
      GanntTask(
        startDate: now.add(const Duration(days: 20)),
        endDate: DateTime(nextMonth.year, nextMonth.month, 10),
        color: Colors.deepPurple.shade300,
        textColor: Colors.white,
        assignedTo: 'Team',
        task: 'Final Review & Deployment',
      ),
    );
  
  
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Gantt Calendar Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GanttCalendar(tasks: _tasks, taskHeaderText: 'Tasks'),
        ),
      ),
    );
  }
}
