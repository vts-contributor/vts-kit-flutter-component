// ignore_for_file: prefer_expression_function_bodies

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/charts/pie_chart/painter/pie_chart_foreground_painter.dart';
import 'package:vts_component/components/charts/pie_chart/painter/pie_chart_painter.dart';

import 'model/vts_pie_chart_data_item.dart';

class VTSPieChart extends StatefulWidget {
  const VTSPieChart({
    Key? key,
    required this.dataset,
    this.chartBackgroundColor,
    this.chartScale = 0.9,
    this.chartSize,
    this.secsToComplete = 5,
    this.startAngle = -pi / 2,
    this.labelStyle = const TextStyle(
      color: VTSColors.WHITE_1,
      fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
    ),
    this.showSeparator = true,
    this.separatorWidth = 3,
    this.showBorder = false,
    this.borderWidth = 3,
    this.showLegend = true,
    this.legendTextStyle = const TextStyle(
      color: VTSColors.BLACK_1,
      fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
      fontSize: 16,
    ),
    this.legendTopMargin = 0,
    this.legendHorizontalMargin = 10,
    this.isDonut = false,
    this.donutTitle,
    this.donutSubTitle,
    this.donutTitleStyle,
    this.donutSubTitleStyle,
    this.onSectionClicked,
  }) : super(key: key);

  final List<VTSPieChartDataItem> dataset;

  /// Background color of the canvas part
  final Color? chartBackgroundColor;

  /// Size of the canvas part
  final double chartScale;

  /// Size of entire chart
  final Size? chartSize;

  /// Animation time for completing to load the chart
  final double secsToComplete;

  /// Angle is used to draw first section of the chart
  final double startAngle;

  final TextStyle labelStyle;

  final bool showSeparator;
  final double separatorWidth;
  final bool showBorder;
  final double borderWidth;
  final bool showLegend;
  final TextStyle legendTextStyle;
  final double legendTopMargin;
  final double legendHorizontalMargin;

  final bool isDonut;
  final String? donutTitle;
  final String? donutSubTitle;
  final TextStyle? donutTitleStyle;
  final TextStyle? donutSubTitleStyle;

  final Function(VTSPieChartDataItem)? onSectionClicked;

  @override
  State<VTSPieChart> createState() => _VTSPieChartState();
}

class _VTSPieChartState extends State<VTSPieChart> {
  late Size chartSize;
  late Timer timer;
  final fps = 1000 ~/ 60;
  double fullAngle = 0.0;
  double datasetSum = 0.0;

  Rect? _rect;
  double? _startAngle;
  double? _sweepAngle;
  VTSPieChartDataItem? _item;

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
                margin: EdgeInsets.only(top: widget.legendTopMargin),
                width: chartSize.width,
                height: chartSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: widget.legendHorizontalMargin,
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
                                Text(el.label, style: widget.legendTextStyle),
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
          onSectionClicked: (rect, startAngle, sweepAngle, item) {
            updateSection(rect, startAngle, sweepAngle, item);
            widget.onSectionClicked!(item);
          },
        ),
        foregroundPainter: PieChartForegroundPainter(
          context,
          rect: _rect,
          startAngle: _startAngle,
          sweepAngle: _sweepAngle,
          item: _item,
          isDonut: widget.isDonut,
          donutTitle: widget.donutTitle,
          donutSubTitle: widget.donutSubTitle,
          donutTitleStyle: widget.donutTitleStyle,
          donutSubTitleStyle: widget.donutSubTitleStyle,
          onSectionClicked: (rect, startAngle, sweepAngle, item) {
            updateSection(null, null, null, null);
          },
        ),
      ),
    );
  }

  void updateSection(
    Rect? rect,
    double? startAngle,
    double? sweepAngle,
    VTSPieChartDataItem? item,
  ) {
    _rect = rect;
    _startAngle = startAngle;
    _sweepAngle = sweepAngle;
    _item = item;
    setState(() {});
  }
}
