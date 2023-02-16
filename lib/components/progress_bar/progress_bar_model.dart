import 'package:flutter/material.dart';

import '../../common/style/vts_color.dart';

class VTSProgressBarModel {
  VTSProgressBarModel(
      {required this.currentValue,
      required this.maxValue,
      this.speedRate,
      this.loadingColor = VTSColors.PRIMARY_1,
      this.backgroundColor = VTSColors.GRAY_5,
      required this.unit,
      this.unitTextStyle = const TextStyle(
        fontSize: 14,
        color: VTSColors.GRAY_1,
        height: 22.0 / 14,
      ),
      this.label,
      this.labelStyle = const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        height: 24.0 / 16,
      ),
      this.size = 72,
      this.fontSizePercentage = 20,
      this.progressBarSize = 8});

  /// Current value of the progress bar.
  final double currentValue;

  /// Maximum value of the progress bar. When the current value meets the
  /// max value, the loading is completed.
  final double maxValue;

  /// Loading speed, e.g. download speed is 1MB/s. Nullable.
  final double? speedRate;

  /// Color of the completed loading part, default is `PRIMARY_1`
  final Color loadingColor;

  /// Color of the uncompleted loading part, default is `GRAY_5`
  final Color backgroundColor;

  /// Unit of value, e.g. byte, kilogram, etc.
  final String unit;

  /// Unit text style, 14 - w400 - `GRAY_1`
  final TextStyle unitTextStyle;

  /// Label is nullable. If it is null, do not show.
  final String? label;

  /// Label style, default is 16 - w700 - black
  final TextStyle labelStyle;

  /// Size of the progress bar (width x height), default is [72]
  final double size;

  /// Font size of the center percentage, default is [20]
  final double fontSizePercentage;

  /// size of progress bar (`strokeWidth` in circular, `minHeight` in linear),
  /// default is [8]
  final double progressBarSize;
}
