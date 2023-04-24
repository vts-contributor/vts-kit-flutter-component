import 'dart:ui';
import 'package:flutter/material.dart';
import 'axis/axit_chart_data.dart';
import 'bar_chart/vts_bar_chart_data.dart';
import 'line_chart/vts_line_chart_data.dart';

@visibleForTesting
List<T>? lerpList<T>(
  List<T>? a,
  List<T>? b,
  double t, {
  required T Function(T, T, double) lerp,
}) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) => lerp(a[i], b[i], t));
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) => lerp(i >= a.length ? b[i] : a[i], b[i], t));
  } else {
    return b;
  }
}

List<int>? lerpIntList(List<int>? a, List<int>? b, double t) =>
    lerpList(a, b, t, lerp: lerpInt);

int lerpInt(int a, int b, double t) => (a + (b - a) * t).round();


List<VTSSpot>? lerpVTSSpotList(List<VTSSpot>? a, List<VTSSpot>? b, double t) =>
    lerpList(a, b, t, lerp: VTSSpot.lerp);

List<HorizontalLine>? lerpHorizontalLineList(
  List<HorizontalLine>? a,
  List<HorizontalLine>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: HorizontalLine.lerp);

List<VerticalLine>? lerpVerticalLineList(
  List<VerticalLine>? a,
  List<VerticalLine>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: VerticalLine.lerp);

List<HorizontalRangeAnnotation>? lerpHorizontalRangeAnnotationList(
  List<HorizontalRangeAnnotation>? a,
  List<HorizontalRangeAnnotation>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: HorizontalRangeAnnotation.lerp);

List<VerticalRangeAnnotation>? lerpVerticalRangeAnnotationList(
  List<VerticalRangeAnnotation>? a,
  List<VerticalRangeAnnotation>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: VerticalRangeAnnotation.lerp);

/// Lerps [BarChartGroupData] list based on [t] value, check [Tween.lerp].
List<BarChartGroupData>? lerpBarChartGroupDataList(
    List<BarChartGroupData>? a,
    List<BarChartGroupData>? b,
    double t,
    ) =>
    lerpList(a, b, t, lerp: BarChartGroupData.lerp);



List<LineChartBarData>? lerpLineChartBarDataList(
  List<LineChartBarData>? a,
  List<LineChartBarData>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: LineChartBarData.lerp);

/// Lerps [BarChartRodData] list based on [t] value, check [Tween.lerp].
List<BarChartRodData>? lerpBarChartRodDataList(
    List<BarChartRodData>? a,
    List<BarChartRodData>? b,
    double t,
    ) =>
    lerpList(a, b, t, lerp: BarChartRodData.lerp);


Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  final length = colors.length;
  if (stops.length != length) {
    stops = List.generate(length, (i) => (i + 1) / length);
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];

    final leftColor = colors[s];
    final rightColor = colors[s + 1];

    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
