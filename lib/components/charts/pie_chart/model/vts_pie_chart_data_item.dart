import 'package:flutter/material.dart';

class VTSPieChartDataItem {
  VTSPieChartDataItem({
    required this.value,
    required this.label,
    required this.color,
    this.percentage,
  });

  final double value;
  final String label;
  final Color color;
  double? percentage;

  @override
  String toString() =>
      'VTSPieChartDataItem($value, $label, $color, $percentage)';
}
