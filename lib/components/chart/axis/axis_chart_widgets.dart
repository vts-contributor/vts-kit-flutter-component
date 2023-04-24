import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'axis_chart_helper.dart';
import 'axit_chart_data.dart';

class SideTitleWidget extends StatefulWidget {
  const SideTitleWidget({
    super.key,
    required this.child,
    required this.axisSide,
    this.space = 8.0,
    this.angle = 0.0,
    this.fitInside = const SideTitleFitInsideData(
      enabled: false,
      distanceFromEdge: 0,
      parentAxisSize: 0,
      axisPosition: 0,
    ),
  });

  final AxisSide axisSide;
  final double space;
  final Widget child;
  final double angle;

  /// Define fitInside options with [SideTitleFitInsideData]
  ///
  /// To makes things simpler, it's recommended to use
  /// [SideTitleFitInsideData.fromTitleMeta] and pass the
  /// TitleMeta provided from [SideTitles.getTitlesWidget]
  ///
  /// If [fitInside.enabled] is true, the widget will be placed
  /// inside the parent axis bounding box.
  ///
  /// Some translations will be applied to force
  /// children to be positioned inside the parent axis bounding box.
  ///
  /// Will override the [SideTitleWidget.space] and caused
  /// spacing between [SideTitles] children might be not equal.
  final SideTitleFitInsideData fitInside;

  @override
  State<SideTitleWidget> createState() => _SideTitleWidgetState();
}

class _SideTitleWidgetState extends State<SideTitleWidget> {
  Alignment _getAlignment() {
    switch (widget.axisSide) {
      case AxisSide.left:
        return Alignment.centerRight;
      case AxisSide.top:
        return Alignment.bottomCenter;
      case AxisSide.right:
        return Alignment.centerLeft;
      case AxisSide.bottom:
        return Alignment.topCenter;
    }
  }

  EdgeInsets _getMargin() {
    switch (widget.axisSide) {
      case AxisSide.left:
        return EdgeInsets.only(right: widget.space);
      case AxisSide.top:
        return EdgeInsets.only(bottom: widget.space);
      case AxisSide.right:
        return EdgeInsets.only(left: widget.space);
      case AxisSide.bottom:
        return EdgeInsets.only(top: widget.space);
    }
  }

  /// Calculate child width/height
  final GlobalKey widgetKey = GlobalKey();
  double? _childSize;
  void _getChildSize(_) {
    if (!widget.fitInside.enabled) return;

    if (_childSize != null) return;

    final context = widgetKey.currentContext;
    if (context == null) return;

    late double size;
    switch (widget.axisSide) {
      case AxisSide.left:
      case AxisSide.right:
        size = context.size?.height ?? 0;
        break;
      case AxisSide.top:
      case AxisSide.bottom:
        size = context.size?.width ?? 0;
        break;
    }

    if (_childSize == size) return;

    setState(() => _childSize = size);
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(_getChildSize);
  }

  @override
  void didUpdateWidget(covariant SideTitleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback(_getChildSize);
  }

  @override
  Widget build(BuildContext context) => Transform.translate(
      offset: !widget.fitInside.enabled
          ? Offset.zero
          : AxisChartHelper().calcFitInsideOffset(
              axisSide: widget.axisSide,
              childSize: _childSize,
              parentAxisSize: widget.fitInside.parentAxisSize,
              axisPosition: widget.fitInside.axisPosition,
              distanceFromEdge: widget.fitInside.distanceFromEdge,
            ),
      child: Transform.rotate(
        angle: widget.angle,
        child: Container(
          key: widgetKey,
          margin: _getMargin(),
          alignment: _getAlignment(),
          child: widget.child,
        ),
      ),
    );
}
