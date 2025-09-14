# Gantt Calendar

A flexible and customizable Gantt chart calendar widget for Flutter applications. This package provides an elegant way to visualize tasks and projects across time periods with a clean, responsive interface.

## Preview

<p align="center">
  <img src="https://github.com/user-attachments/assets/07762d27-ad7f-4971-9b09-3382424e0a87" alt="Gantt Calendar Demo" width="300">
</p>

## Features

- **Multi-month view**: Display tasks spanning across multiple months
- **Customizable styling**: Extensive theming options for colors, fonts, and dimensions
- **Task visualization**: Clear representation of tasks with customizable colors and text
- **Month navigation**: Built-in controls for navigating between months
- **Programmatic control**: Controller for programmatically navigating and managing the calendar
- **Custom builders**: Flexibility to customize header cells, task cells, and navigation components
- **Responsive layout**: Adapts to different screen sizes
- **Task interaction**: Support for tapping on tasks with callbacks

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  gantt_calendar: ^1.0.0
```

Then run:

```
flutter pub get
```

Import the package in your Dart code:

```dart
import 'package:gantt_calendar/gantt_calendar.dart';
```

## Usage

### Basic Usage

Create a simple Gantt calendar with a list of tasks:

```dart
final tasks = [
  GanntTask(
    startDate: DateTime.now().subtract(const Duration(days: 2)),
    endDate: DateTime.now().add(const Duration(days: 3)),
    color: Colors.blue.shade300,
    textColor: Colors.white,
    assignedTo: 'John Doe',
    task: 'Design UI',
  ),
  GanntTask(
    startDate: DateTime.now().add(const Duration(days: 4)),
    endDate: DateTime.now().add(const Duration(days: 8)),
    color: Colors.green.shade300,
    textColor: Colors.white,
    assignedTo: 'Jane Smith',
    task: 'Develop Backend',
  ),
];

GanttCalendar(
  tasks: tasks,
  taskHeaderText: 'Tasks',
)
```

### Tasks Spanning Multiple Months

You can create tasks that span across different months:

```dart
final now = DateTime.now();
final lastMonth = DateTime(now.year, now.month - 1, 15);
final nextMonth = DateTime(now.year, now.month + 1, 1);

final tasks = [
  // Task in last month
  GanntTask(
    startDate: DateTime(lastMonth.year, lastMonth.month, 10),
    endDate: DateTime(lastMonth.year, lastMonth.month, 20),
    color: Colors.purple.shade300,
    textColor: Colors.white,
    assignedTo: 'Alice Chen',
    task: 'Research Phase',
  ),

  // Task spanning from last month to current month
  GanntTask(
    startDate: DateTime(lastMonth.year, lastMonth.month, 25),
    endDate: DateTime(now.year, now.month, 5),
    color: Colors.teal.shade300,
    textColor: Colors.white,
    assignedTo: 'Sarah Johnson',
    task: 'Architecture Planning',
  ),

  // Task spanning from current month to next month
  GanntTask(
    startDate: now.add(const Duration(days: 20)),
    endDate: DateTime(nextMonth.year, nextMonth.month, 10),
    color: Colors.deepPurple.shade300,
    textColor: Colors.white,
    assignedTo: 'Team',
    task: 'Final Review & Deployment',
  ),
]
```

### Customizing Appearance

You can customize the appearance of the Gantt calendar using `GanntStyleTheme`:

```dart
GanttCalendar(
  tasks: tasks,
  styleTheme: GanntStyleTheme(
    cellWidth: 60,
    cellHeight: 40,
    headerHeight: 50,
    leftColumnWidth: 150,
    taskBarHeight: 25,
    gridLineColor: Colors.grey.shade300,
    gridLineWidth: 1.0,
    todayColumnColor: Colors.blue.shade50,
    weekendColumnColor: Colors.grey.shade100,
    headerBackgroundColor: Colors.blue.shade100,
    taskBorderRadius: 8.0,
    headerTextStyle: TextStyle(fontWeight: FontWeight.bold),
    taskTextStyle: TextStyle(fontSize: 12, color: Colors.white),
  ),
)
```

### Using a Controller

You can programmatically control the calendar using `GanttCalendarController`:

```dart
final controller = GanttCalendarController();

// In your build method
GanttCalendar(
  tasks: tasks,
  controller: controller,
)

// Later in your code, you can:
controller.nextMonth();
controller.previousMonth();
controller.jumpToDate(DateTime(2023, 6, 1));
controller.animateToDate(
  DateTime(2023, 7, 1),
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
);
```

### Custom Builders

You can customize various parts of the calendar using builder functions:

```dart
GanttCalendar(
  tasks: tasks,
  // Custom header cell builder
  headerCellBuilder: (context, date, isToday, isWeekend) {
    return Container(
      decoration: BoxDecoration(
        color: isToday ? Colors.amber : (isWeekend ? Colors.grey.shade200 : Colors.white),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat('E').format(date)),
          Text(date.day.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  },

  // Custom task header cell builder
  taskHeaderCellBuilder: (context, propertyName, isHeader) {
    return Container(
      padding: EdgeInsets.all(8),
      color: isHeader ? Colors.blue.shade100 : Colors.white,
      child: Text(
        propertyName ?? '',
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  },

  // Custom task builder
  taskBuilder: (context, task, width, isStartDate, isEndDate) {
    return Container(
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.horizontal(
          left: isStartDate ? Radius.circular(8) : Radius.zero,
          right: isEndDate ? Radius.circular(8) : Radius.zero,
        ),
      ),
      child: Center(
        child: Text(
          task.assignedTo,
          style: TextStyle(color: task.textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  },

  // Custom navigation builder
  navigationBuilder: (context, currentDate, onPrevious, onNext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: Icon(Icons.arrow_back), onPressed: onPrevious),
        Text(
          DateFormat('MMMM yyyy').format(currentDate),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(icon: Icon(Icons.arrow_forward), onPressed: onNext),
      ],
    );
  },
)
```

### Handling Task Taps

You can respond to task taps using the `onTaskTap` callback:

```dart
GanttCalendar(
  tasks: tasks,
  onTaskTap: (task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.task),
        content: Text('Assigned to: ${task.assignedTo}\n'
            'From: ${DateFormat('MMM d, yyyy').format(task.startDate!)}\n'
            'To: ${DateFormat('MMM d, yyyy').format(task.endDate!)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  },
)
```

## Additional information

### Model Classes

- **GanntTask**: Represents a task in the Gantt chart with properties like start date, end date, color, assigned person, and task name.
- **GanntStyleTheme**: Contains styling properties for customizing the appearance of the Gantt calendar.
- **GanttCalendarController**: Provides methods to programmatically control the calendar.

### Limitations

- The calendar is designed for day-level granularity, not for hour-level scheduling.
- For very large datasets (hundreds of tasks), consider implementing pagination or filtering.

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
