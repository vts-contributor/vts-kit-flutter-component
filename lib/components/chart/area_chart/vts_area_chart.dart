import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


/// Holds data for filling an area (above or below) of the line with a color or gradient.
class BarAreaData with EquatableMixin {
  BarAreaData({
    bool? show,
    Color? color,
    this.gradient,
  })  : show = show ?? false,
        color = color ??
            ((color == null && gradient == null)
                ? Colors.blueGrey.withOpacity(0.5)
                : null);
  final bool show;

  ///get color for Area
  final Color? color;

  /// If provided, this [BarAreaData] draws with this [gradient].
  final Gradient? gradient;

  /// Lerps a [BarAreaData] based on [t] value, check [Tween.lerp].
  static BarAreaData lerp(BarAreaData a, BarAreaData b, double t) => BarAreaData(
    show: b.show,
    color: Color.lerp(a.color, b.color, t),
    gradient: Gradient.lerp(a.gradient, b.gradient, t),
  );

  @override
  List<Object?> get props => [
    show,
    color,
    gradient,
  ];
}
