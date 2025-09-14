import 'package:flutter/material.dart';

/// A controller for the GanttCalendar widget.
///
/// This controller allows you to programmatically control the GanttCalendar,
/// including navigation between months, jumping to specific dates, and
/// getting information about the current state.
class GanttCalendarController with ChangeNotifier {
  /// The page controller used by the GanttCalendar.
  PageController? _pageController;

  /// The list of generated months in the calendar.
  List<DateTime> _generatedMonths = [];

  /// The current date being displayed.
  DateTime _currentDate = DateTime.now();

  /// Whether the controller has been attached to a GanttCalendar.
  bool _isAttached = false;

  /// Returns whether the controller is attached to a GanttCalendar.
  bool get isAttached => _isAttached;

  /// Returns the current date being displayed.
  DateTime get currentDate => _currentDate;

  /// Returns the current page index.
  int get currentPageIndex => _pageController?.page?.round() ?? 0;

  /// Returns the total number of pages.
  int get pageCount => _generatedMonths.length;

  /// Attaches the controller to a GanttCalendar.
  /// This is called internally by the GanttCalendar widget.
  void attach(
    PageController pageController,
    List<DateTime> generatedMonths,
    DateTime currentDate,
  ) {
    _pageController = pageController;
    _generatedMonths = generatedMonths;
    _currentDate = currentDate;
    _isAttached = true;
    notifyListeners();
  }

  /// Updates the current date.
  /// This is called internally by the GanttCalendar widget.
  void updateCurrentDate(DateTime date) {
    _currentDate = date;
    notifyListeners();
  }

  /// Navigates to the previous month.
  ///
  /// Returns true if navigation was successful, false otherwise.
  bool previousMonth() {
    if (!_isAttached || _pageController == null) return false;

    final currentPage = _pageController!.page;
    if (currentPage! > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return true;
    }
    return false;
  }

  /// Navigates to the next month.
  ///
  /// Returns true if navigation was successful, false otherwise.
  bool nextMonth() {
    if (!_isAttached || _pageController == null) return false;

    final currentPage = _pageController!.page;
    if (currentPage! < _generatedMonths.length - 1) {
      _pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return true;
    }
    return false;
  }

  /// Jumps to a specific date.
  ///
  /// Returns true if jump was successful, false otherwise.
  bool jumpToDate(DateTime date) {
    if (!_isAttached || _pageController == null) return false;

    final index = _generatedMonths.indexWhere(
      (month) => month.year == date.year && month.month == date.month,
    );

    if (index != -1) {
      _pageController!.jumpToPage(index);
      return true;
    }
    return false;
  }

  /// Animates to a specific date.
  ///
  /// Returns true if animation was successful, false otherwise.
  bool animateToDate(
    DateTime date, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  }) {
    if (!_isAttached || _pageController == null) return false;

    final index = _generatedMonths.indexWhere(
      (month) => month.year == date.year && month.month == date.month,
    );

    if (index != -1) {
      _pageController!.animateToPage(index, duration: duration, curve: curve);
      return true;
    }
    return false;
  }

  /// Returns the list of months available in the calendar.
  List<DateTime> get availableMonths => List.unmodifiable(_generatedMonths);

  /// Checks if the controller can navigate to the previous month.
  bool get canGoToPreviousMonth {
    if (!_isAttached || _pageController == null) return false;
    return _pageController!.page! > 0;
  }

  /// Checks if the controller can navigate to the next month.
  bool get canGoToNextMonth {
    if (!_isAttached || _pageController == null) return false;
    return _pageController!.page! < _generatedMonths.length - 1;
  }

  @override
  void dispose() {
    _isAttached = false;
    super.dispose();
  }
}
