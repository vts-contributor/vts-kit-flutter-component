import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:vts_component/common/extension/border_ext.dart';
import 'package:vts_component/components/chart/base_chart/vts_touch_event.dart';


abstract class BaseChartData with EquatableMixin {
  BaseChartData({
    VTSBorderData? borderData,
    required this.touchData,
  }) : borderData = borderData ?? VTSBorderData();

  /// Holds data to drawing border around the chart.
  VTSBorderData borderData;

  VTSTouchData touchData;

  BaseChartData lerp(BaseChartData a, BaseChartData b, double t);

  @override
  List<Object?> get props => [
    borderData,
    touchData,
  ];
}



class VTSBorderData with EquatableMixin {
  VTSBorderData({
    bool? show,
    Border? border,
  })  : show = show ?? true,
        border = border ?? Border.all();
  final bool show;
  Border border;


  bool isVisible() => show && border.isVisible();

  static VTSBorderData lerp(VTSBorderData a, VTSBorderData b, double t) => VTSBorderData(
      show: b.show,
      border: Border.lerp(a.border, b.border, t),
    );

  VTSBorderData copyWith({
    bool? show,
    Border? border,
  }) => VTSBorderData(
      show: show ?? this.show,
      border: border ?? this.border,
    );

  @override
  List<Object?> get props => [
    show,
    border,
  ];
}

abstract class VTSTouchData<R extends BaseTouchResponse> with EquatableMixin {
  VTSTouchData(
      this.enabled,
      this.touchCallback,
      );

  final bool enabled;
  final BaseTouchCallback<R>? touchCallback;



  @override
  List<Object?> get props => [
    enabled,
    touchCallback,
  ];
}

class VTSClipData with EquatableMixin {
  VTSClipData({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  VTSClipData.all() : this(top: true, bottom: true, left: true, right: true);

  VTSClipData.vertical()
      : this(top: true, bottom: true, left: false, right: false);

  VTSClipData.horizontal()
      : this(top: false, bottom: false, left: true, right: true);

  VTSClipData.none()
      : this(top: false, bottom: false, left: false, right: false);
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  bool get any => top || bottom || left || right;

  VTSClipData copyWith({
    bool? top,
    bool? bottom,
    bool? left,
    bool? right,
  }) => VTSClipData(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );

  @override
  List<Object?> get props => [top, bottom, left, right];
}

typedef BaseTouchCallback<R extends BaseTouchResponse> = void Function(
    VTSTouchEvent,
    R?,
    );

typedef MouseCursorResolver<R extends BaseTouchResponse> = MouseCursor Function(
    VTSTouchEvent,
    R?,
    );

abstract class BaseTouchResponse {
  BaseTouchResponse();
}

enum VTSHorizontalAlignment {
  center,
  left,
  right,
}
