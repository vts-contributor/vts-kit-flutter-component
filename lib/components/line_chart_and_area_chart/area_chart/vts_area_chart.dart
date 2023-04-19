import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../axis/axit_chart_data.dart';

/// Holds data for filling an area (above or below) of the line with a color or gradient.
class BarAreaData with EquatableMixin {
  BarAreaData({
    bool? show,
    Color? color,
    this.gradient,
    // BarAreaSpotsLine? spotsLine,
    // double? cutOffY,
    // bool? applyCutOffY,
  })  : show = show ?? false,
        color = color ??
            ((color == null && gradient == null)
                ? Colors.blueGrey.withOpacity(0.5)
                : null);
        // spotsLine = spotsLine ?? BarAreaSpotsLine(),
        // cutOffY = cutOffY ?? 0,
        // applyCutOffY = applyCutOffY ?? false,
        // assert(applyCutOffY == true ? cutOffY != null : true);
  final bool show;

  /// If provided, this [BarAreaData] draws with this [color]
  /// Otherwise we use  [gradient] to draw the background.
  /// It throws an exception if you provide both [color] and [gradient]
  final Color? color;

  /// If provided, this [BarAreaData] draws with this [gradient].
  /// Otherwise we use [color] to draw the background.
  /// It throws an exception if you provide both [color] and [gradient]
  final Gradient? gradient;

  // /// holds data for drawing a line from each spot the the bottom, or top of the chart
  // final BarAreaSpotsLine spotsLine;
  //
  // /// cut the drawing below or above area to this y value
  // final double cutOffY;
  //
  // /// determines should or shouldn't apply cutOffY
  // final bool applyCutOffY;

  /// Lerps a [BarAreaData] based on [t] value, check [Tween.lerp].
  static BarAreaData lerp(BarAreaData a, BarAreaData b, double t) => BarAreaData(
    show: b.show,
    // spotsLine: BarAreaSpotsLine.lerp(a.spotsLine, b.spotsLine, t),
    color: Color.lerp(a.color, b.color, t),
    // ignore: invalid_use_of_protected_member
    gradient: Gradient.lerp(a.gradient, b.gradient, t),
    // cutOffY: lerpDouble(a.cutOffY, b.cutOffY, t),
    // applyCutOffY: b.applyCutOffY,
  );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
    show,
    color,
    gradient,
    // spotsLine,
    // cutOffY,
    // applyCutOffY,
  ];
}


/// Holds data for drawing line on the spots under the [BarAreaData].
class BarAreaSpotsLine with EquatableMixin {
  /// If [show] is true, [LineChart] draws some lines on above or below the spots,
  /// you can customize the appearance of the lines using [vtsLineStyle]
  /// and you can decide to show or hide the lines on each spot using [checkToShowSpotLine].
  BarAreaSpotsLine({
    bool? show,
    VTSLine? vtsLineStyle,
    CheckToShowSpotLine? checkToShowSpotLine,
    bool? applyCutOffY,
  })  : show = show ?? false,
        vtsLineStyle = vtsLineStyle ?? VTSLine(),
        checkToShowSpotLine = checkToShowSpotLine ?? showAllSpotsBelowLine,
        applyCutOffY = applyCutOffY ?? true;

  /// Determines to show or hide all the lines.
  final bool show;

  /// Holds appearance of drawing line on the spots.
  final VTSLine vtsLineStyle;

  /// Checks to show or hide lines on the spots.
  final CheckToShowSpotLine checkToShowSpotLine;

  /// Determines to inherit the cutOff properties from its parent [BarAreaData]
  final bool applyCutOffY;

  /// Lerps a [BarAreaSpotsLine] based on [t] value, check [Tween.lerp].
  static BarAreaSpotsLine lerp(
      BarAreaSpotsLine a,
      BarAreaSpotsLine b,
      double t,
      ) => BarAreaSpotsLine(
    show: b.show,
    checkToShowSpotLine: b.checkToShowSpotLine,
    vtsLineStyle: VTSLine.lerp(a.vtsLineStyle, b.vtsLineStyle, t),
    applyCutOffY: b.applyCutOffY,
  );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
    show,
    vtsLineStyle,
    checkToShowSpotLine,
    applyCutOffY,
  ];
}

/// It used for determine showing or hiding [BarAreaSpotsLine]s
///
/// Gives you the checking spot, and you have to decide to
/// show or not show the line on the provided spot.
typedef CheckToShowSpotLine = bool Function(VTSSpot spot);

/// Shows all spot lines.
bool showAllSpotsBelowLine(VTSSpot spot) => true;