import 'package:flutter/material.dart';
import 'package:vts_component/components/line_chart/utils.dart';

import 'axit_chart_data.dart';

class AxisChartHelper {
  factory AxisChartHelper() => _singleton;

  AxisChartHelper._internal();
  static final _singleton = AxisChartHelper._internal();

  Iterable<double> iterateThroughAxis({
    required double min,
    bool minIncluded = true,
    required double max,
    bool maxIncluded = true,
    required double baseLine,
    required double interval,
  }) sync* {
    final initialValue = Utils()
        .getBestInitialIntervalValue(min, max, interval, baseline: baseLine);
    var axisSeek = initialValue;
    final firstPositionOverlapsWithMin = axisSeek == min;
    if (!minIncluded && firstPositionOverlapsWithMin) {
      axisSeek += interval;
    }
    final diff = max - min;
    final count = diff ~/ interval;
    final lastPosition = initialValue + (count * interval);
    final lastPositionOverlapsWithMax = lastPosition == max;
    final end =
    !maxIncluded && lastPositionOverlapsWithMax ? max - interval : max;

    final epsilon = interval / 100000;
    if (minIncluded && !firstPositionOverlapsWithMin) {
      yield min;
    }
    while (axisSeek <= end + epsilon) {
      yield axisSeek;
      axisSeek += interval;
    }
    if (maxIncluded && !lastPositionOverlapsWithMax) {
      yield max;
    }
  }

  Offset calcFitInsideOffset({
    required AxisSide axisSide,
    required double? childSize,
    required double parentAxisSize,
    required double axisPosition,
    required double distanceFromEdge,
  }) {
    if (childSize == null) return Offset.zero;

    final axisMid = parentAxisSize / 2;
    final mainAxisAlignment = (axisPosition - axisMid).isNegative
        ? MainAxisAlignment.start
        : MainAxisAlignment.end;

    late bool isOverflowed;
    if (mainAxisAlignment == MainAxisAlignment.start) {
      isOverflowed = (axisPosition - (childSize / 2)).isNegative;
    } else {
      isOverflowed = (axisPosition + (childSize / 2)) > parentAxisSize;
    }

    if (isOverflowed == false) return Offset.zero;

    late double offset;
    if (mainAxisAlignment == MainAxisAlignment.start) {
      offset = (childSize / 2) - axisPosition + distanceFromEdge;
    } else {
      offset =
          -(childSize / 2) + (parentAxisSize - axisPosition) - distanceFromEdge;
    }

    switch (axisSide) {
      case AxisSide.left:
      case AxisSide.right:
        return Offset(0, offset);
      case AxisSide.top:
      case AxisSide.bottom:
        return Offset(offset, 0);
    }
  }
}
