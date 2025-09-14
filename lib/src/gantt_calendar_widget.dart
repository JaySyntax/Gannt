import 'package:flutter/material.dart';
import 'package:gantt_calendar/gantt_calendar.dart';
import 'package:gantt_calendar/src/extension/date_ext.dart';
import 'package:gantt_calendar/src/widget/calender_navigation.dart';

/// Signature for building a header cell widget
typedef HeaderCellBuilder =
    Widget Function(
      BuildContext context,
      DateTime date,
      bool isToday,
      bool isWeekend,
    );

/// Signature for building a task header cell widget
typedef TaskHeaderCellBuilder =
    Widget Function(BuildContext context, String? propertyName, bool isHeader);

/// Signature for building a task widget
typedef TaskBuilder =
    Widget Function(
      BuildContext context,
      GanntTask task,
      double width,
      bool isStartDate,
      bool isEndDate,
    );

/// Signature for building a navigation widget
typedef NavigationBuilder =
    Widget Function(
      BuildContext context,
      DateTime currentDate,
      VoidCallback onPrevious,
      VoidCallback onNext,
    );

class GanttCalendar extends StatefulWidget {
  final List<GanntTask> tasks;
  final GanntStyleTheme? styleTheme;

  /// Optional builder for customizing header cells
  final HeaderCellBuilder? headerCellBuilder;

  /// Optional builder for customizing task header cells
  final TaskHeaderCellBuilder? taskHeaderCellBuilder;

  /// Optional builder for customizing task widgets
  final TaskBuilder? taskBuilder;

  /// Custom text for the task header (defaults to 'Task')
  final String taskHeaderText;

  /// Optional builder for customizing the navigation controls
  final NavigationBuilder? navigationBuilder;

  /// Optional controller for programmatically controlling the calendar
  final GanttCalendarController? controller;

  /// Callback when a task is tapped
  final Function(GanntTask task)? onTaskTap;

  /// Initial date to display (defaults to current date)
  final DateTime? initialDate;

  /// Start date for the calendar range (defaults to 1 year before initial date)
  final DateTime? startDate;

  /// End date for the calendar range (defaults to 1 year after initial date)
  final DateTime? endDate;

  const GanttCalendar({
    super.key,
    required this.tasks,
    this.styleTheme = const GanntStyleTheme(),
    this.headerCellBuilder,
    this.taskHeaderCellBuilder,
    this.taskBuilder,
    this.taskHeaderText = '',
    this.navigationBuilder,
    this.controller,
    this.onTaskTap,
    this.initialDate,
    this.startDate,
    this.endDate,
  });

  @override
  State<GanttCalendar> createState() => _GanttCalendarState();
}

class _GanttCalendarState extends State<GanttCalendar> {
  List<GanntTask> _tasks = [];

  PageController _pageController = PageController();
  List<DateTime> _generatedMonths = [];
  late double? _cellWidth;
  late double? _cellHeight;
  late double? _headerHeight;
  late double? _leftColumnWidth;
  late double? _taskBarHeight;
  late Color? _gridLineColor;
  late double? _gridLineWidth;
  late Color? _todayColumnColor;
  late Color? _weekendColumnColor;
  late Color? _headerBackgroundColor;
  late TextStyle? _headerTextStyle;
  late TextStyle? _propertyNameTextStyle;
  late TextStyle? _taskTextStyle;
  late TextStyle? _headerDayTextStyle;
  late TextStyle? _headerWeekdayTextStyle;
  late TextStyle? _taskHeaderTextStyle;
  late TextStyle? _todayTextStyle;
  late TextStyle? _weekendTextStyle;
  late double? _taskBorderRadius;
  late EdgeInsets? _taskPadding;
  late EdgeInsets? _taskMargin;
  late Color? _hoverColor;
  late DateTime _startDate, _endDate, _presentDate;
  final ScrollController _timelineScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cellWidth = widget.styleTheme?.cellWidth;
    _cellHeight = widget.styleTheme?.cellHeight;
    _headerHeight = widget.styleTheme?.headerHeight ?? _cellHeight;
    _leftColumnWidth = widget.styleTheme?.leftColumnWidth;
    _taskBarHeight = widget.styleTheme?.taskBarHeight;
    _gridLineColor = widget.styleTheme?.gridLineColor;
    _gridLineWidth = widget.styleTheme?.gridLineWidth;
    _todayColumnColor = widget.styleTheme?.todayColumnColor;
    _weekendColumnColor = widget.styleTheme?.weekendColumnColor;
    _headerBackgroundColor = widget.styleTheme?.headerBackgroundColor;
    _headerTextStyle = widget.styleTheme?.headerTextStyle;
    _propertyNameTextStyle = widget.styleTheme?.propertyNameTextStyle;
    _taskTextStyle = widget.styleTheme?.taskTextStyle;
    _headerDayTextStyle = widget.styleTheme?.headerDayTextStyle;
    _headerWeekdayTextStyle = widget.styleTheme?.headerWeekdayTextStyle;
    _taskHeaderTextStyle = widget.styleTheme?.taskHeaderTextStyle;
    _todayTextStyle = widget.styleTheme?.todayTextStyle;
    _weekendTextStyle = widget.styleTheme?.weekendTextStyle;
    _taskBorderRadius = widget.styleTheme?.taskBorderRadius;
    _taskPadding = widget.styleTheme?.taskPadding;
    _taskMargin = widget.styleTheme?.taskMargin;
    _hoverColor = widget.styleTheme?.hoverColor;

    _presentDate = widget.initialDate ?? DateTime.now();
    _startDate = widget.startDate ?? DateTime(_presentDate.year - 1);
    _endDate = widget.endDate ?? DateTime(_presentDate.year + 1, 12, 31);
    _generatedMonths = _generateMonthDates();
    final int initialPage = _generatedMonths.indexWhere(
      (date) =>
          date.year == _presentDate.year && date.month == _presentDate.month,
    );
    _pageController = PageController(initialPage: initialPage);

    // Attach the controller if provided
    if (widget.controller != null) {
      widget.controller!.attach(
        _pageController,
        _generatedMonths,
        _presentDate,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tasks = widget.tasks;
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(GanttCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller if it changed
    if (widget.controller != oldWidget.controller) {
      if (widget.controller != null) {
        widget.controller!.attach(
          _pageController,
          _generatedMonths,
          _presentDate,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timelineScrollController.dispose();
  }

  List<DateTime> _generateMonthDates() {
    final List<DateTime> months = [];
    for (int year = _startDate.year; year <= _endDate.year; year++) {
      for (int month = 1; month <= 12; month++) {
        months.add(DateTime(year, month));
      }
    }
    return months;
  }

  void _prevMonth() {
    final currentPage = _pageController.page;

    if (currentPage! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void _nextMonth() {
    final currentPage = _pageController.page;

    if (currentPage! < _generatedMonths.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  List<DateTime> getDatesInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final nextMonth = DateTime(month.year, month.month + 1);
    final daysInMonth = nextMonth.difference(firstDay).inDays;
    return List.generate(
      daysInMonth,
      (i) => DateTime(month.year, month.month, i + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        widget.navigationBuilder != null
            ? widget.navigationBuilder!(
                context,
                _presentDate,
                _prevMonth,
                _nextMonth,
              )
            : CalenderNavigation(
                dateTime: _presentDate,
                navigateToPrevPage: _prevMonth,
                navigateToNextPage: _nextMonth,
              ),
        SizedBox(height: 24),
        Expanded(
          child: PageView.builder(
            itemCount: _generatedMonths.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _presentDate = _generatedMonths[index]);
              // Update controller's current date
              if (widget.controller != null) {
                widget.controller!.updateCurrentDate(_generatedMonths[index]);
              }
            },
            itemBuilder: (context, index) {
              final month = _generatedMonths[index];
              final datesInMonth = getDatesInMonth(month);

              return _buildGanntStyle(
                datesInMonth: datesInMonth,
                tasksInMonth: _tasks,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGanntStyle({
    required List<DateTime> datesInMonth,
    required List<GanntTask> tasksInMonth,
  }) {
    // Group reservations by guest name
    final Map<GanntTask?, List<GanntTask>> grouped = {};
    for (final res in tasksInMonth) {
      grouped.putIfAbsent(res, () => []).add(res);
    }

    final tasks = grouped.keys.toList();
    final int daysInMonth = datesInMonth.length;

    // Add empty guest row if needed
    if (tasks.isEmpty) {
      tasks.add(null);
    }

    final borderStyle = BorderSide(
      color: _gridLineColor ?? Colors.grey.shade300,
      width: _gridLineWidth ?? 1.0,
    );

    // Controllers for vertical scroll sync
    final ScrollController leftColumnController = ScrollController();
    final ScrollController timelineController = ScrollController();

    // Sync vertical scrolling
    leftColumnController.addListener(() {
      if (timelineController.offset != leftColumnController.offset) {
        timelineController.jumpTo(leftColumnController.offset);
      }
    });
    timelineController.addListener(() {
      if (leftColumnController.offset != timelineController.offset) {
        leftColumnController.jumpTo(timelineController.offset);
      }
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sticky left column (task names)
        SizedBox(
          width: _leftColumnWidth ?? 130,
          child: ListView.builder(
            controller: leftColumnController,
            itemCount: tasks.length + 1, // +1 for header
            itemBuilder: (context, rowIdx) {
              if (rowIdx == 0) {
                // Header cell
                if (widget.taskHeaderCellBuilder != null) {
                  return widget.taskHeaderCellBuilder!(
                    context,
                    widget.taskHeaderText,
                    true,
                  );
                }

                return Container(
                  height: _headerHeight ?? _cellHeight,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: _headerBackgroundColor,
                    border: Border(bottom: borderStyle, right: borderStyle),
                  ),
                  child: Text(
                    widget.taskHeaderText,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _taskHeaderTextStyle ?? _taskTextStyle,
                  ),
                );
              }

              final task = tasks[rowIdx - 1];

              if (widget.taskHeaderCellBuilder != null) {
                return widget.taskHeaderCellBuilder!(
                  context,
                  task?.task,
                  false,
                );
              }

              return InkWell(
                onTap: () {
                  if (widget.onTaskTap != null) {
                    widget.onTaskTap!(task!);
                  }
                },
                hoverColor: _hoverColor,
                child: Container(
                  height: _cellHeight,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: borderStyle, right: borderStyle),
                  ),
                  child: Text(
                    task?.task ?? '',
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _propertyNameTextStyle,
                  ),
                ),
              );
            },
          ),
        ),
        // Timeline (dates and bookings)
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _timelineScrollController,
            child: SizedBox(
              width: daysInMonth * _cellWidth!,
              child: ListView.builder(
                controller: timelineController,
                itemCount: tasks.length + 1, // +1 for header
                itemBuilder: (context, rowIdx) {
                  if (rowIdx == 0) {
                    // Timeline header row
                    return Row(
                      children: datesInMonth.map((date) {
                        final isToday =
                            date.year == DateTime.now().year &&
                            date.month == DateTime.now().month &&
                            date.day == DateTime.now().day;
                        final isWeekend =
                            date.weekday == DateTime.saturday ||
                            date.weekday == DateTime.sunday;

                        if (widget.headerCellBuilder != null) {
                          return SizedBox(
                            width: _cellWidth,
                            height: _headerHeight ?? _cellHeight,
                            child: widget.headerCellBuilder!(
                              context,
                              date,
                              isToday,
                              isWeekend,
                            ),
                          );
                        }

                        return Container(
                          width: _cellWidth,
                          height: _headerHeight ?? _cellHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isToday
                                ? _todayColumnColor
                                : isWeekend
                                ? _weekendColumnColor
                                : _headerBackgroundColor,
                            border: Border(
                              bottom: borderStyle,
                              right: borderStyle,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  date.getWeekday,
                                  textAlign: TextAlign.center,
                                  style:
                                      _headerWeekdayTextStyle ??
                                      _headerTextStyle,
                                ),
                              ),
                              SizedBox(height: 3),
                              Flexible(
                                child: Text(
                                  '${date.day}',
                                  textAlign: TextAlign.center,
                                  style: isToday
                                      ? _todayTextStyle ??
                                            _headerDayTextStyle ??
                                            _headerTextStyle
                                      : isWeekend
                                      ? _weekendTextStyle ??
                                            _headerDayTextStyle ??
                                            _headerTextStyle
                                      : _headerDayTextStyle ?? _headerTextStyle,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }

                  // Get the property and its bookings for this row
                  final task = tasks[rowIdx - 1];
                  final propertyReservations = grouped[task] ?? [];

                  return SizedBox(
                    height: _cellHeight,
                    child: Stack(
                      children: [
                        // Render background cells (grid)
                        Row(
                          children: datesInMonth.map((date) {
                            final isToday =
                                date.year == DateTime.now().year &&
                                date.month == DateTime.now().month &&
                                date.day == DateTime.now().day;
                            final isWeekend =
                                date.weekday == DateTime.saturday ||
                                date.weekday == DateTime.sunday;

                            return Container(
                              width: _cellWidth,
                              height: _cellHeight,
                              decoration: BoxDecoration(
                                color: isToday
                                    ? _todayColumnColor
                                    : isWeekend
                                    ? _weekendColumnColor
                                    : null,
                                border: Border(
                                  bottom: borderStyle,
                                  right: borderStyle,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        // Render all reservation blocks for this property
                        ...propertyReservations.map((booking) {
                          // Find all the dates between start and end
                          final reservationDates = datesInMonth.where((date) {
                            final d = date.toDateOnly;
                            final start = booking.startDate!.toDateOnly;
                            final end = booking.endDate!.toDateOnly;
                            return !d.isBefore(start) && !d.isAfter(end);
                          }).toList();

                          if (reservationDates.isEmpty) return const SizedBox();

                          final firstDate = reservationDates.first;
                          final lastDate = reservationDates.last;

                          final bookingStart = booking.startDate!.toDateOnly;
                          final bookingEnd = booking.endDate!.toDateOnly;

                          final isStartDate = firstDate.toDateOnly
                              .isAtSameMomentAs(bookingStart);
                          final isEndDate = lastDate.toDateOnly
                              .isAtSameMomentAs(bookingEnd);

                          final leftOffset =
                              datesInMonth.indexOf(firstDate) * _cellWidth!;
                          final blockWidth =
                              (datesInMonth.indexOf(lastDate) -
                                  datesInMonth.indexOf(firstDate) +
                                  1) *
                              _cellWidth!;

                          return Positioned(
                            left: leftOffset,
                            top: 0,
                            bottom: 0,
                            width: blockWidth,
                            child: widget.taskBuilder != null
                                ? widget.taskBuilder!(
                                    context,
                                    booking,
                                    blockWidth,
                                    isStartDate,
                                    isEndDate,
                                  )
                                : InkWell(
                                    onTap: () {
                                      if (widget.onTaskTap != null) {
                                        widget.onTaskTap!(booking);
                                      }
                                    },
                                    hoverColor: _hoverColor,
                                    child: Center(
                                      child: Container(
                                        height: _taskBarHeight ?? 20,
                                        margin:
                                            _taskMargin ??
                                            EdgeInsets.only(
                                              left: isStartDate
                                                  ? _cellWidth! / 1.6
                                                  : 0,
                                              right: isEndDate
                                                  ? _cellWidth! / 1.6
                                                  : 0,
                                            ),
                                        padding:
                                            _taskPadding ??
                                            EdgeInsets.symmetric(
                                              horizontal: 23,
                                            ),
                                        decoration: BoxDecoration(
                                          color: booking.color,
                                          borderRadius: BorderRadius.horizontal(
                                            left: isStartDate
                                                ? Radius.circular(
                                                    _taskBorderRadius ?? 5,
                                                  )
                                                : Radius.zero,
                                            right: isEndDate
                                                ? Radius.circular(
                                                    _taskBorderRadius ?? 5,
                                                  )
                                                : Radius.zero,
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          booking.assignedTo,
                                          style:
                                              _taskTextStyle ??
                                              TextStyle(
                                                fontSize: 10,
                                                color: booking.textColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
