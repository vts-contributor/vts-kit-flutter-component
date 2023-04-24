import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/color_ext.dart';
import '../axis/axit_chart_data.dart';
import '../base_chart/base_chart_data.dart';
import '../lerp.dart';
import '../utils.dart';
import 'vts_bar_chart_helper.dart';

class VTSBarChartData extends AxisChartData with EquatableMixin {
  VTSBarChartData({
    List<BarChartGroupData>? barGroups,
    double? groupsSpace,
    BarChartAlignment? alignment,
    VTSTitlesData? titlesData,
    BarTouchData? barTouchData,
    double? maxY,
    double? minY,
    super.baselineY,
    VTSGridData? gridData,
    super.borderData,
    super.backgroundColor,
  })  : barGroups = barGroups ?? const [],
        groupsSpace = groupsSpace ?? 16,
        alignment = alignment ?? BarChartAlignment.spaceEvenly,
        barTouchData = barTouchData ?? BarTouchData(),
        super(
          titlesData: titlesData ??
              VTSTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
          gridData: gridData ?? VTSGridData(),
          touchData: barTouchData ?? BarTouchData(),
          minX: 0,
          maxX: 1,
          maxY: maxY ??
              VTSBarChartHelper.calculateMaxAxisValues(barGroups ?? []).maxY,
          minY: minY ??
              VTSBarChartHelper.calculateMaxAxisValues(barGroups ?? []).minY,
        );

  /// [BarChartGroupData] draws [barGroups] that each of them contains a list of [BarChartRodData].
  final List<BarChartGroupData> barGroups;

  /// Apply space between the [barGroups].
  final double groupsSpace;

  /// Arrange the [barGroups], see [BarChartAlignment].
  final BarChartAlignment alignment;

  /// Handles touch behaviors and responses.
  final BarTouchData barTouchData;

  VTSBarChartData copyWith({
    List<BarChartGroupData>? barGroups,
    double? groupsSpace,
    BarChartAlignment? alignment,
    VTSTitlesData? titlesData,
    BarTouchData? barTouchData,
    VTSGridData? gridData,
    VTSBorderData? borderData,
    double? maxY,
    double? minY,
    double? baselineY,
    Color? backgroundColor,
  }) => VTSBarChartData(
      barGroups: barGroups ?? this.barGroups,
      groupsSpace: groupsSpace ?? this.groupsSpace,
      alignment: alignment ?? this.alignment,
      titlesData: titlesData ?? this.titlesData,
      barTouchData: barTouchData ?? this.barTouchData,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      maxY: maxY ?? this.maxY,
      minY: minY ?? this.minY,
      baselineY: baselineY ?? this.baselineY,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );

  @override
  VTSBarChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is VTSBarChartData && b is VTSBarChartData) {
      return VTSBarChartData(
        barGroups: lerpBarChartGroupDataList(a.barGroups, b.barGroups, t),
        groupsSpace: lerpDouble(a.groupsSpace, b.groupsSpace, t),
        alignment: b.alignment,
        titlesData: VTSTitlesData.lerp(a.titlesData, b.titlesData, t),
        barTouchData: b.barTouchData,
        gridData: VTSGridData.lerp(a.gridData, b.gridData, t),
        borderData: VTSBorderData.lerp(a.borderData, b.borderData, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        minY: lerpDouble(a.minY, b.minY, t),
        baselineY: lerpDouble(a.baselineY, b.baselineY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );
    } else {
      throw Exception('');
    }
  }

  @override
  List<Object?> get props => [
        barGroups,
        groupsSpace,
        alignment,
        titlesData,
        barTouchData,
        maxY,
        minY,
        baselineY,
        gridData,
        borderData,
        backgroundColor,
      ];
}

enum BarChartAlignment {
  start,
  end,
  center,
  spaceEvenly,
  spaceAround,
  spaceBetween,
}

/// Represents a group of rods (or bars) inside the [BarChart].
class BarChartGroupData with EquatableMixin {
  BarChartGroupData({
    required this.x,
    List<BarChartRodData>? barRods,
    double? barsSpace,
    List<int>? showingTooltipIndicators,
  })  : barRods = barRods ?? const [],
        barsSpace = barsSpace ?? 2,
        showingTooltipIndicators = showingTooltipIndicators ?? const [];

  /// Order along the x axis in which titles, and titles only, will be shown.
  @required
  final int x;

  /// [VTSBarChart] renders [barRods] that represents a rod (or a bar) in the bar chart.
  final List<BarChartRodData> barRods;

  /// Use to set the distance between BarChartRodData in the same BarRods of BarChartGroupData
  final double barsSpace;

  /// show some tooltipIndicators (a popup with an information)
  final List<int> showingTooltipIndicators;

  /// width of the group (sum of all [BarChartRodData]'s width and spaces)
  double get width {
    if (barRods.isEmpty) {
      return 0;
    }
    final sumWidth = barRods
        .map((rodData) => rodData.width)
        .reduce((first, second) => first + second);
    final spaces = (barRods.length - 1) * barsSpace;
    return sumWidth + spaces;
  }


  BarChartGroupData copyWith({
    int? x,
    List<BarChartRodData>? barRods,
    double? barsSpace,
    List<int>? showingTooltipIndicators,
  }) => BarChartGroupData(
      x: x ?? this.x,
      barRods: barRods ?? this.barRods,
      barsSpace: barsSpace ?? this.barsSpace,
      showingTooltipIndicators:
          showingTooltipIndicators ?? this.showingTooltipIndicators,
    );

  static BarChartGroupData lerp(
    BarChartGroupData a,
    BarChartGroupData b,
    double t,
  ) => BarChartGroupData(
      x: (a.x + (b.x - a.x) * t).round(),
      barRods: lerpBarChartRodDataList(a.barRods, b.barRods, t),
      barsSpace: lerpDouble(a.barsSpace, b.barsSpace, t),
      showingTooltipIndicators: lerpIntList(
        a.showingTooltipIndicators,
        b.showingTooltipIndicators,
        t,
      ),
    );

  @override
  List<Object?> get props => [
        x,
        barRods,
        barsSpace,
        showingTooltipIndicators,
      ];
}

class BarChartRodData with EquatableMixin {
  BarChartRodData({
    double? fromY,
    required this.toY,
    Color? color,
    double? width,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
  })  : fromY = fromY ?? 0,
        color =
            color ?? ((color == null) ? Colors.cyan : null),
        width = width ?? 8,
        borderRadius = Utils().normalizeBorderRadius(borderRadius, width ?? 8),
        borderSide = Utils().normalizeBorderSide(borderSide, width ?? 8);


  /// [VTSBarChart] renders rods vertically from [fromY].
  final double fromY;

  /// [VTSBarChart] renders rods vertically from [fromY] to [toY].
  final double toY;

  /// If provided, this [BarChartRodData] draws with this [color]
  final Color? color;

  /// [VTSBarChart] renders each rods with this value.
  final double width;

  /// If you want to have a rounded rod, set this value.
  final BorderRadius? borderRadius;

  /// If you want to have a border for rod, set this value.
  final BorderSide borderSide;

  /// Determines the upward or downward direction
  bool isUpward() => toY >= fromY;

  BarChartRodData copyWith({
    double? fromY,
    double? toY,
    Color? color,
    double? width,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
  }) => BarChartRodData(
      fromY: fromY ?? this.fromY,
      toY: toY ?? this.toY,
      color: color ?? this.color,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
    );


  static BarChartRodData lerp(BarChartRodData a, BarChartRodData b, double t) => BarChartRodData(
      color: Color.lerp(a.color, b.color, t),
      width: lerpDouble(a.width, b.width, t),
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t),
      borderSide: BorderSide.lerp(a.borderSide, b.borderSide, t),
      fromY: lerpDouble(a.fromY, b.fromY, t),
      toY: lerpDouble(a.toY, b.toY, t)!,
    );

  @override
  List<Object?> get props => [
        fromY,
        toY,
        width,
        borderRadius,
        borderSide,
        color,
      ];
}


class BarTouchData extends VTSTouchData<BarTouchResponse> with EquatableMixin {
  BarTouchData({
    bool? enabled,
    BaseTouchCallback<BarTouchResponse>? touchCallback,
    BarTouchTooltipData? touchTooltipData,
  })  : touchTooltipData = touchTooltipData ?? BarTouchTooltipData(),
        super(
          enabled ?? true,
          touchCallback,
        );

  /// Configs of how touch tooltip popup.
  final BarTouchTooltipData touchTooltipData;

  BarTouchData copyWith({
    bool? enabled,
    BaseTouchCallback<BarTouchResponse>? touchCallback,
    BarTouchTooltipData? touchTooltipData,
  }) => BarTouchData(
      enabled: enabled ?? this.enabled,
      touchCallback: touchCallback ?? this.touchCallback,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
    );

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        touchTooltipData,
      ];
}

/// Controls showing tooltip on top or bottom.
enum TooltipDirection {
  /// Tooltip shows on top if value is positive, on bottom if value is negative.
  auto,

  /// Tooltip always shows on top.
  top,

  /// Tooltip always shows on bottom.
  bottom,
}

/// Holds representation data for showing tooltip popup on top of rods.
class BarTouchTooltipData with EquatableMixin {
  BarTouchTooltipData({
    Color? tooltipBgColor,
    double? tooltipRoundedRadius,
    EdgeInsets? tooltipPadding,
    double? tooltipMargin,
    VTSHorizontalAlignment? tooltipHorizontalAlignment,
    GetBarTooltipItem? getTooltipItem,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    TooltipDirection? direction,
    double? rotateAngle,
    BorderSide? tooltipBorder,
  })  : tooltipBgColor = tooltipBgColor ?? Colors.blueGrey.darken(15),
        tooltipRoundedRadius = tooltipRoundedRadius ?? 4,
        tooltipPadding = tooltipPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipMargin = tooltipMargin ?? 16,
        tooltipHorizontalAlignment =
            tooltipHorizontalAlignment ?? VTSHorizontalAlignment.center,
        getTooltipItem = getTooltipItem ?? defaultBarTooltipItem,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
        direction = direction ?? TooltipDirection.auto,
        rotateAngle = rotateAngle ?? 0.0,
        tooltipBorder = tooltipBorder ?? BorderSide.none,
        super();

  /// The tooltip background color.
  final Color tooltipBgColor;

  /// Sets a rounded radius for the tooltip.
  final double tooltipRoundedRadius;

  /// Applies a padding for showing contents inside the tooltip.
  final EdgeInsets tooltipPadding;

  /// Applies a bottom margin for showing tooltip on top of rods.
  final double tooltipMargin;

  /// Controls showing tooltip on left side, right side or center aligned with rod, default is center
  final VTSHorizontalAlignment tooltipHorizontalAlignment;

  /// Retrieves data for showing content inside the tooltip.
  final GetBarTooltipItem getTooltipItem;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

  /// Controls showing tooltip on top or bottom, default is auto.
  final TooltipDirection direction;

  /// Controls the rotation of the tooltip.
  final double rotateAngle;

  /// The tooltip border color.
  final BorderSide tooltipBorder;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        tooltipBgColor,
        tooltipRoundedRadius,
        tooltipPadding,
        tooltipMargin,
        tooltipHorizontalAlignment,
        getTooltipItem,
        fitInsideHorizontally,
        fitInsideVertically,
        rotateAngle,
        tooltipBorder,
      ];
}


typedef GetBarTooltipItem = BarTooltipItem? Function(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
);

/// Default implementation for [BarTouchTooltipData.getTooltipItem].
BarTooltipItem? defaultBarTooltipItem(
  BarChartGroupData group,
  int groupIndex,
  BarChartRodData rod,
  int rodIndex,
) {
  final color =  rod.color;
  final textStyle = TextStyle(
    color: color,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  return BarTooltipItem(rod.toY.toString(), textStyle);
}

class BarTooltipItem with EquatableMixin {
  BarTooltipItem(
    this.text,
    this.textStyle, {
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
    this.children,
  });

  /// Text of the content.
  final String text;

  /// TextStyle of the showing content.
  final TextStyle textStyle;

  /// TextAlign of the showing content.
  final TextAlign textAlign;

  /// Direction of showing text.
  final TextDirection textDirection;

  /// List<TextSpan> add further style and format to the text of the tooltip
  final List<TextSpan>? children;

  @override
  List<Object?> get props => [
        text,
        textStyle,
        textAlign,
        textDirection,
        children,
      ];
}

class BarTouchResponse extends BaseTouchResponse {
  BarTouchResponse(this.spot) : super();

  /// Gives information about the touched spot
  final BarTouchedSpot? spot;

  BarTouchResponse copyWith({
    BarTouchedSpot? spot,
  }) => BarTouchResponse(
      spot ?? this.spot,
    );
}

/// It gives you information about the touched spot.
class BarTouchedSpot extends TouchedSpot with EquatableMixin {
  BarTouchedSpot(
    this.touchedBarGroup,
    this.touchedBarGroupIndex,
    this.touchedRodData,
    this.touchedRodDataIndex,
    this.touchedStackItemIndex,
    VTSSpot spot,
    Offset offset,
  ) : super(spot, offset);
  final BarChartGroupData touchedBarGroup;
  final int touchedBarGroupIndex;

  final BarChartRodData touchedRodData;
  final int touchedRodDataIndex;


  /// It can be -1, if nothing found
  final int touchedStackItemIndex;

  @override
  List<Object?> get props => [
        touchedBarGroup,
        touchedBarGroupIndex,
        touchedRodData,
        touchedRodDataIndex,
        touchedStackItemIndex,
        spot,
        offset,
      ];
}

/// It lerps a [VTSBarChartData] to another [VTSBarChartData] (handles animation for updating values)
class BarChartDataTween extends Tween<VTSBarChartData> {
  BarChartDataTween({required VTSBarChartData begin, required VTSBarChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [VTSBarChartData] based on [t] value, check [Tween.lerp].
  @override
  VTSBarChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}
