import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/vts_common.dart';

class Utils {
  factory Utils() => _singleton;

  Utils._internal();
  static final Utils _singleton = Utils._internal();

  static const double _degrees2Radians = math.pi / 180.0;

  double radians(double degrees) => degrees * _degrees2Radians;

  Offset calculateRotationOffset(Size size, double degree) {
    final rotatedHeight = (size.width * math.sin(radians(degree))).abs() +
        (size.height * cos(radians(degree))).abs();
    final rotatedWidth = (size.width * cos(radians(degree))).abs() +
        (size.height * sin(radians(degree))).abs();
    return Offset(
      (size.width - rotatedWidth) / 2,
      (size.height - rotatedHeight) / 2,
    );
  }

  double getEfficientInterval(
    double axisViewSize,
    double diffInAxis, {
    double pixelPerInterval = 40,
  }) {
    final allowedCount = math.max(axisViewSize ~/ pixelPerInterval, 1);
    if (diffInAxis == 0) {
      return 1;
    }
    final accurateInterval =
        diffInAxis == 0 ? axisViewSize : diffInAxis / allowedCount;
    if (allowedCount <= 2) {
      return accurateInterval;
    }
    return roundInterval(accurateInterval);
  }

  @visibleForTesting
  double roundInterval(double input) {
    if (input < 1) {
      return _roundIntervalBelowOne(input);
    }
    return _roundIntervalAboveOne(input);
  }

  double _roundIntervalBelowOne(double input) {
    assert(input < 1.0);

    if (input < 0.000001) {
      return input;
    }

    final inputString = input.toString();
    var precisionCount = inputString.length - 2;

    var zeroCount = 0;
    for (var i = 2; i <= inputString.length; i++) {
      if (inputString[i] != '0') {
        break;
      }
      zeroCount++;
    }

    final afterZerosNumberLength = precisionCount - zeroCount;
    if (afterZerosNumberLength > 2) {
      final numbersToRemove = afterZerosNumberLength - 2;
      precisionCount -= numbersToRemove;
    }

    final pow10onPrecision = pow(10, precisionCount);
    input *= pow10onPrecision;
    return _roundIntervalAboveOne(input) / pow10onPrecision;
  }

  /// Default value for BorderSide where borderSide value is not exists
  static const BorderSide defaultBorderSide = BorderSide(width: 0);

  /// Decreases [borderSide] to <= width / 2
  BorderSide normalizeBorderSide(BorderSide? borderSide, double width) {
    if (borderSide == null) {
      return defaultBorderSide;
    }

    double borderWidth;
    if (borderSide.width > width / 2) {
      borderWidth = width / 2.toDouble();
    } else {
      borderWidth = borderSide.width;
    }

    return borderSide.copyWith(width: borderWidth);
  }

  /// Decreases [borderRadius] to <= width / 2
  BorderRadius? normalizeBorderRadius(
      BorderRadius? borderRadius,
      double width,
      ) {
    if (borderRadius == null) {
      return null;
    }

    Radius topLeft;
    if (borderRadius.topLeft.x > width / 2 ||
        borderRadius.topLeft.y > width / 2) {
      topLeft = Radius.circular(width / 2);
    } else {
      topLeft = borderRadius.topLeft;
    }

    Radius topRight;
    if (borderRadius.topRight.x > width / 2 ||
        borderRadius.topRight.y > width / 2) {
      topRight = Radius.circular(width / 2);
    } else {
      topRight = borderRadius.topRight;
    }

    Radius bottomLeft;
    if (borderRadius.bottomLeft.x > width / 2 ||
        borderRadius.bottomLeft.y > width / 2) {
      bottomLeft = Radius.circular(width / 2);
    } else {
      bottomLeft = borderRadius.bottomLeft;
    }

    Radius bottomRight;
    if (borderRadius.bottomRight.x > width / 2 ||
        borderRadius.bottomRight.y > width / 2) {
      bottomRight = Radius.circular(width / 2);
    } else {
      bottomRight = borderRadius.bottomRight;
    }

    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  double _roundIntervalAboveOne(double input) {
    assert(input >= 1.0);
    final decimalCount = input.toInt().toString().length - 1;
    input /= pow(10, decimalCount);

    final scaled = input >= 10 ? input.round() / 10 : input;

    if (scaled >= 7.6) {
      return 10 * pow(10, decimalCount).toInt().toDouble();
    } else if (scaled >= 2.6) {
      return 5 * pow(10, decimalCount).toInt().toDouble();
    } else if (scaled >= 1.6) {
      return 2 * pow(10, decimalCount).toInt().toDouble();
    } else {
      return 1 * pow(10, decimalCount).toInt().toDouble();
    }
  }



  String formatNumber(double number) {
    final isNegative = number < 0;

    if (isNegative) {
      number = number.abs();
    }

    String resultNumber;
    String symbol;
    if (number >= VTSCommon.billion) {
      resultNumber = (number / VTSCommon.billion).toStringAsFixed(1);
      symbol = 'B';
    } else if (number >= VTSCommon.million) {
      resultNumber = (number / VTSCommon.million).toStringAsFixed(1);
      symbol = 'M';
    } else if (number >= VTSCommon.kilo) {
      resultNumber = (number / VTSCommon.kilo).toStringAsFixed(1);
      symbol = 'K';
    } else {
      resultNumber = number.toStringAsFixed(1);
      symbol = '';
    }

    if (resultNumber.endsWith('.0')) {
      resultNumber = resultNumber.substring(0, resultNumber.length - 2);
    }

    if (isNegative) {
      resultNumber = '-$resultNumber';
    }

    if (resultNumber == '-0') {
      resultNumber = '0';
    }

    return resultNumber + symbol;
  }

  TextStyle getThemeAwareTextStyle(
    BuildContext context,
    TextStyle? providedStyle,
  ) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = providedStyle;
    if (providedStyle == null || providedStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(providedStyle);
    }
    if (MediaQuery.boldTextOverride(context)) {
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    return effectiveTextStyle!;
  }

  double getBestInitialIntervalValue(
    double min,
    double max,
    double interval, {
    double baseline = 0.0,
  }) {
    final diff = baseline - min;
    final mod = diff % interval;
    if ((max - min).abs() <= mod) {
      return min;
    }
    if (mod == 0) {
      return min;
    }
    return min + mod;
  }

  double convertRadiusToSigma(double radius) => radius * 0.57735 + 0.5;
}
