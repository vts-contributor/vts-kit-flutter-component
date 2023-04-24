// ignore_for_file: slash_for_doc_comments, prefer_expression_function_bodies

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vts_component/vts_component.dart';

import 'date/customization/calendar_style.dart';
import 'date/customization/days_of_week_style.dart';
import 'date/customization/header_style.dart';
import 'date/shared/utils.dart';
import 'date/table_calendar.dart';

class VTSDateTimePicker extends StatefulWidget {
  const VTSDateTimePicker({
    Key? key,
    this.firstDay,
    this.lastDay,
    this.showTime = true,
    this.timeLocale = LocaleType.en,
    this.timeMode = VTSTimePickerMode.mode24h,
    this.timeTheme = const DatePickerTheme(
      cancelStyle: TextStyle(
        fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
        fontWeight: FontWeight.bold,
        color: VTSColors.GRAY_3,
      ),
      doneStyle: TextStyle(
        fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
        fontWeight: FontWeight.bold,
        color: VTSColors.PRIMARY_1,
      ),
      itemStyle: TextStyle(
        fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
      ),
    ),
    this.textCancel = 'Cancel',
    this.textOK = 'OK',
    this.onOK,
    this.onCancel,
  }) : super(key: key);

  /**
   * For picking date
   */

  /// The first active day.
  /// Blocks swiping to days before it.
  final DateTime? firstDay;

  /// The last active day.
  /// Blocks swiping to days after it.
  final DateTime? lastDay;

  /**
   * For picking time
   */

  final bool showTime;

  final LocaleType timeLocale;

  final VTSTimePickerMode timeMode;

  final DatePickerTheme timeTheme;

  /**
   * For applying date and time after picking
   */

  final String textCancel;

  final String textOK;

  final Function(DateTime)? onOK;

  final Function()? onCancel;

  @override
  State<VTSDateTimePicker> createState() => _VTSDateTimePickerState();
}

class _VTSDateTimePickerState extends State<VTSDateTimePicker> {
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
  late DateTime _pivot = _today;
  late bool _isAM;
  late final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    _isAM = _today.hour > 0 && _today.hour < 12;

    return Container(
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
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Year: ${focusedDay.year}',
                            style: VTSCommon.TEXT_STYLE_SUBTITLE_1_18,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: VTSColors.BLACK_1,
                            ),
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
                          children: _months.keys.map(
                            (el) {
                              return VTSButton(
                                onPressed: () {
                                  var _curPage = _pageController.page!.round();
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

                                  Navigator.pop(context);
                                },
                                text: el,
                                vtsSize: VTSButtonSize.SM,
                                blockButton: true,
                                vtsType: VTSButtonType.SECONDARY,
                                vtsShape: VTSButtonShape.STANDARD,
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    );
                  },
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
                  fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                  fontWeight: FontWeight.bold,
                  color: VTSColors.GRAY_3,
                ),
                weekendStyle: const TextStyle(
                  fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                  fontWeight: FontWeight.bold,
                  color: VTSColors.GRAY_3,
                ),
              ),
              // TODO: FIXED STYLES FOR CONTENT
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle: TextStyle(
                  fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                  fontSize: VTSCommon.FONT_SIZE_SM,
                  color: VTSColors.BLACK_1,
                ),
                weekendTextStyle: TextStyle(
                  fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                  fontSize: VTSCommon.FONT_SIZE_SM,
                  color: VTSColors.BLACK_1,
                ),
                todayTextStyle: TextStyle(
                  fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                  fontSize: VTSCommon.FONT_SIZE_SM,
                  color: VTSColors.PRIMARY_1,
                ),
                todayDecoration: BoxDecoration(),
                selectedTextStyle: TextStyle(
                  fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                  fontSize: VTSCommon.FONT_SIZE_SM,
                  color: VTSColors.PRIMARY_1,
                ),
                selectedDecoration: BoxDecoration(
                  color: VTSColors.PRIMARY_5,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Divider(height: 3, color: VTSColors.GRAY_3),
            const SizedBox(height: 10),
            if (widget.showTime)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.timeMode == VTSTimePickerMode.mode24h) {
                            DatePicker.showTimePicker(
                              context,
                              locale: widget.timeLocale,
                              currentTime: _today,
                              theme: widget.timeTheme,
                              onConfirm: (selectedTime) {
                                _today = DateTime.utc(
                                  _today.year,
                                  _today.month,
                                  _today.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                  selectedTime.second,
                                );
                                setState(() {});
                              },
                            );
                          } else {
                            DatePicker.showTime12hPicker(
                              context,
                              locale: widget.timeLocale,
                              currentTime: _today,
                              theme: widget.timeTheme,
                              onConfirm: (selectedTime) {
                                _today = DateTime.utc(
                                  _today.year,
                                  _today.month,
                                  _today.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                  selectedTime.second,
                                );
                                setState(() {});
                              },
                            );
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Time',
                              style: VTSCommon.TEXT_STYLE_SUBTITLE_1_18,
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              '${_today.hour}: ${_today.minute}',
                              style: VTSCommon.TEXT_STYLE_BODY_1_16,
                            ),
                          ),
                          CupertinoSlidingSegmentedControl<bool>(
                            groupValue: _isAM,
                            children: {
                              true: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'AM',
                                  style: TextStyle(
                                    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                                  ),
                                ),
                              ),
                              false: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'PM',
                                  style: TextStyle(
                                    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
                                  ),
                                ),
                              ),
                            },
                            onValueChanged: (value) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 3, color: VTSColors.GRAY_3),
                  const SizedBox(height: 10),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: VTSButton(
                    onPressed: () {
                      widget.onCancel!();
                      Navigator.pop(context);
                    },
                    vtsSize: VTSButtonSize.SM,
                    blockButton: false,
                    vtsType: VTSButtonType.SECONDARY,
                    vtsShape: VTSButtonShape.STANDARD,
                    text: widget.textCancel,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: VTSButton(
                    onPressed: () {
                      widget.onOK!(_today);
                      Navigator.pop(context);
                    },
                    vtsSize: VTSButtonSize.SM,
                    blockButton: false,
                    vtsType: VTSButtonType.PRIMARY,
                    vtsShape: VTSButtonShape.STANDARD,
                    text: widget.textOK,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
