import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vts_component/components/date_picker/src/customization/calendar_style.dart';
import 'package:vts_component/components/date_picker/src/customization/days_of_week_style.dart';
import 'package:vts_component/components/date_picker/src/customization/header_style.dart';
import 'package:vts_component/components/date_picker/src/shared/utils.dart';
import 'package:vts_component/vts_component.dart';

import 'src/table_calendar.dart';

class VTSDatePicker extends StatefulWidget {
  const VTSDatePicker({
    Key? key,
    this.firstDay,
    this.lastDay,
    this.onDaySelected,
  }) : super(key: key);

  /// The first active day of `VTSDatePicker`.
  /// Blocks swiping to days before it.
  ///
  /// Days before it will use `disabledStyle` and trigger `onDisabledDayTapped` callback.
  final DateTime? firstDay;

  /// The last active day of `VTSDatePicker`.
  /// Blocks swiping to days after it.
  ///
  /// Days after it will use `disabledStyle` and trigger `onDisabledDayTapped` callback.
  final DateTime? lastDay;

  final Function(DateTime)? onDaySelected;

  @override
  State<VTSDatePicker> createState() => _VTSDatePickerState();
}

class _VTSDatePickerState extends State<VTSDatePicker> {
  final Map<String, int> _months = {
    'Jan': DateTime.january,
    'Feb': DateTime.february,
    'Mar': DateTime.march,
    'Apr': DateTime.april,
    'May': DateTime.may,
    'Jun': DateTime.june,
    'Jul': DateTime.july,
    'Aug': DateTime.august,
    'Sep': DateTime.september,
    'Oct': DateTime.october,
    'Nov': DateTime.november,
    'Dec': DateTime.december,
  };
  DateTime _today = DateTime.now();
  late int _now = _today.hour > 0 && _today.hour < 12 ? 0 : 1;
  late final PageController _pageController;
  late DateTime _pivot = _today;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 30),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                focusedDay: _today,
                firstDay: widget.firstDay ?? DateTime.utc(-271821, 04, 20),
                lastDay: widget.lastDay ?? DateTime.utc(275760, 09, 13),
                onCalendarCreated: (controller) => _pageController = controller,
                onPageChanged: (focusedDay) => _pivot = focusedDay,
                onHeaderTapped: (focusedDay) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Year: ${focusedDay.year}',
                            style: VTSCommon.TEXT_STYLE_SUBTITLE_2_18,
                          ),
                          VTSButton(
                            onPressed: () => Navigator.of(context).pop(),
                            vtsSize: VTSButtonSize.SM,
                            blockButton: false,
                            vtsType: VTSButtonType.SECONDARY,
                            vtsShape: VTSButtonShape.CIRCLE,
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      content: Container(
                        width: double.maxFinite,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          children: _months.keys
                              .map(
                                (el) => VTSButton(
                                  onPressed: () {
                                    var _curPage =
                                        _pageController.page!.round();
                                    final _range = _months[el]! - _pivot.month;

                                    if (_range > 0) {
                                      for (var i = 0; i < _range; i++) {
                                        _pageController.animateToPage(
                                          _curPage + 1,
                                          duration: const Duration(
                                            microseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                        _curPage++;
                                      }
                                    } else {
                                      for (var i = 0; i < -_range; i++) {
                                        _pageController.animateToPage(
                                          _curPage - 1,
                                          duration: const Duration(
                                            microseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                        _curPage--;
                                      }
                                    }
                                  },
                                  text: el,
                                  vtsSize: VTSButtonSize.SM,
                                  blockButton: true,
                                  vtsType: VTSButtonType.SECONDARY,
                                  vtsShape: VTSButtonShape.STANDARD,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },

                selectedDayPredicate: (day) => isSameDay(day, _today),
                onDaySelected: (selectedDay, focusedDay) {
                  _today = DateTime.utc(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                    _today.hour,
                    _today.minute,
                    _today.second,
                  );
                  setState(() {});
                  widget.onDaySelected!(_today);
                },
                // TODO: FIXED STYLES FOR HEADER
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: VTSCommon.TEXT_STYLE_SUBTITLE_1_18,
                  leftChevronMargin: const EdgeInsets.all(0),
                  rightChevronMargin: const EdgeInsets.all(0),
                  leftChevronPadding: const EdgeInsets.all(0),
                  rightChevronPadding: const EdgeInsets.all(0),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left_rounded,
                    color: VTSColors.BLACK_1,
                    size: 36,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right_rounded,
                    color: VTSColors.BLACK_1,
                    size: 36,
                  ),
                ),
                // TODO: FIXED STYLES FOR TITLE
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (day, locale) =>
                      DateFormat.E(locale).format(day).toUpperCase(),
                  weekdayStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: VTSColors.GRAY_3,
                  ),
                  weekendStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: VTSColors.GRAY_3,
                  ),
                ),
                // TODO: FIXED STYLES FOR CONTENT
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(color: VTSColors.BLACK_1),
                  weekendTextStyle: TextStyle(color: VTSColors.BLACK_1),
                  todayTextStyle: TextStyle(color: VTSColors.PRIMARY_1),
                  todayDecoration: BoxDecoration(),
                  selectedTextStyle: TextStyle(color: VTSColors.PRIMARY_1),
                  selectedDecoration: BoxDecoration(
                    color: VTSColors.PRIMARY_5,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const Divider(height: 3, color: VTSColors.GRAY_3),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Time', style: VTSCommon.TEXT_STYLE_SUBTITLE_1_18),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          color: VTSColors.GRAY_5,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Text(
                          '${_today.hour}: ${_today.minute}',
                          style: VTSCommon.TEXT_STYLE_BODY_1_16,
                        ),
                      ),
                      CupertinoSlidingSegmentedControl<int>(
                        groupValue: _now,
                        children: {
                          0: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text('AM'),
                          ),
                          1: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text('PM'),
                          ),
                        },
                        onValueChanged: (value) {
                          _now = value ?? _now;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
