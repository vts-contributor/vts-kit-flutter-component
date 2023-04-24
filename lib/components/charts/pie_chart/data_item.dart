import 'package:flutter/material.dart';

class DataItem {
  DataItem({
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
  String toString() => 'DataItem($value, $label, $color, $percentage)';
}
