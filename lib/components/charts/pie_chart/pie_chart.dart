// ignore_for_file: prefer_expression_function_bodies

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/charts/pie_chart/pie_chart_painter.dart';

import 'data_item.dart';
import 'test.dart';

class PieChart extends StatefulWidget {
  const PieChart({
    Key? key,
    required this.dataset,
    this.chartBackgroundColor,
    this.chartScale = 0.9,
    this.chartSize,
    this.secsToComplete = 5,
    this.startAngle = -pi / 2,
    this.labelStyle = const TextStyle(color: VTSColors.WHITE_1),
    this.showSeparator = true,
    this.separatorWidth = 3,
    this.showBorder = true,
    this.borderWidth = 5,
    this.showLegend = true,
    this.legendTextColor = VTSColors.WHITE_1,
    this.legendFontFamily = VTSCommon.DEFAULT_FONT_FAMILY,
    this.isDonut = false,
    this.donutTitle,
    this.donutSubTitle,
    this.donutTitleStyle,
    this.donutSubTitleStyle,
    this.onSectionClicked,
  }) : super(key: key);

  final List<DataItem> dataset;

  /// Background color of the canvas part
  final Color? chartBackgroundColor;

  /// Size of the canvas part
  final double chartScale;

  /// Size of entire chart
  final Size? chartSize;

  /// Animation time for completing to load the chart
  final double secsToComplete;

  final double startAngle;
  final TextStyle labelStyle;

  final bool showSeparator;
  final double separatorWidth;
  final bool showBorder;
  final double borderWidth;
  final bool showLegend;
  final Color legendTextColor;
  final String legendFontFamily;

  final bool isDonut;
  final String? donutTitle;
  final String? donutSubTitle;
  final TextStyle? donutTitleStyle;
  final TextStyle? donutSubTitleStyle;

  final Function(DataItem)? onSectionClicked;

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  late Size chartSize;
  late Timer timer;
  final fps = 1000 ~/ 60;
  double fullAngle = 0.0;
  double datasetSum = 0.0;
  double legendSpace = 50;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: fps), (timer) {
      fullAngle += 360.0 / (widget.secsToComplete * fps);
      if (fullAngle > 360.0) {
        fullAngle = 360;
        timer.cancel();
      }
      setState(() {});
    });

    for (final el in widget.dataset) {
      datasetSum += el.value;
    }

    for (final el in widget.dataset) {
      el.percentage = el.value / datasetSum;
      print(el.toString());
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chartSize = widget.chartSize ??
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 2,
        );

    // return CustomPaint(
    //   size: const Size(400, 300),
    //   painter: TestCustomPainter(),
    // );

    return CanvasTouchDetector(
      gesturesToOverride: const [
        GestureType.onTapDown,
      ], // Note: must override gesture type that you want to use
      builder: (context) => CustomPaint(
        size: chartSize,
        child: widget.showLegend
            ? Container(
                margin: EdgeInsets.only(top: legendSpace),
                width: chartSize.width,
                height: chartSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: widget.dataset
                          .map(
                            (el) => Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 3),
                                  width: 8,
                                  height: 8,
                                  color: el.color,
                                ),
                                Text(
                                  el.label,
                                  style: TextStyle(
                                    color: widget.legendTextColor,
                                    fontFamily: widget.legendFontFamily,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              )
            : null,
        painter: PieChartPainter(
          context,
          fullAngle,
          dataset: widget.dataset,
          chartBackgroundColor: widget.chartBackgroundColor,
          chartScale: widget.chartScale,
          startAngle: widget.startAngle,
          labelStyle: widget.labelStyle,
          showSeparator: widget.showSeparator,
          separatorWidth: widget.separatorWidth,
          showBorder: widget.showBorder,
          borderWidth: widget.borderWidth,
          isDonut: widget.isDonut,
          donutTitle: widget.donutTitle,
          donutSubTitle: widget.donutSubTitle,
          donutTitleStyle: widget.donutTitleStyle,
          donutSubTitleStyle: widget.donutSubTitleStyle,
          onSectionClicked: widget.onSectionClicked,
        ),
      ),
    );
  }
}
