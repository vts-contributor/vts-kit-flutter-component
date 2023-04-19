import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:vts_component/components/line_chart_and_area_chart/base_chart/base_chart_data.dart';
import 'package:vts_component/components/line_chart_and_area_chart/line_chart/vts_line_chart_data.dart';

import '../lerp.dart';
import 'axis_chart_widgets.dart';

abstract class AxisChartData extends BaseChartData with EquatableMixin {
  AxisChartData({
    VTSGridData? gridData,
    required this.titlesData,
    required this.minX,
    required this.maxX,
    double? baselineX,
    required this.minY,
    required this.maxY,
    double? baselineY,
    Color? backgroundColor,
    super.borderData,
    required super.touchData,
    ExtraLinesData? extraLinesData,
  })  : gridData = gridData ?? VTSGridData(),
        baselineX = baselineX ?? 0,
        baselineY = baselineY ?? 0,
        backgroundColor = backgroundColor ?? Colors.transparent,
        extraLinesData = extraLinesData ?? ExtraLinesData();
  final VTSGridData gridData;
  final VTSTitlesData titlesData;


  double minX;
  double maxX;
  double baselineX;
  double minY;
  double maxY;
  double baselineY;

  /// clip the chart to the border (prevent draw outside the border)
  FlClipData clipData = FlClipData.none();

  /// A background color which is drawn behind the chart.
  Color backgroundColor;

  /// Difference of [maxY] and [minY]
  double get verticalDiff => maxY - minY;

  /// Difference of [maxX] and [minX]
  double get horizontalDiff => maxX - minX;

  /// Extra horizontal or vertical lines to draw on the chart.
  final ExtraLinesData extraLinesData;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
    gridData,
    titlesData,
    minX,
    maxX,
    baselineX,
    minY,
    maxY,
    baselineY,
    clipData,
    backgroundColor,
    borderData,
    touchData,
    extraLinesData,
  ];
}

enum AxisSide { left, top, right, bottom }

class TitleMeta {
  TitleMeta({
    required this.min,
    required this.max,
    required this.parentAxisSize,
    required this.axisPosition,
    required this.appliedInterval,
    required this.sideTitles,
    required this.formattedValue,
    required this.axisSide,
  });

  /// min axis value
  final double min;

  /// max axis value
  final double max;

  /// parent axis max width/height
  final double parentAxisSize;

  /// The position (in pixel) that applied to
  /// this drawing title along its axis.
  final double axisPosition;

  /// The interval that applied to this drawing title
  final double appliedInterval;

  /// Reference of [SideTitles] object.
  final SideTitles sideTitles;

  /// Formatted value that is suitable to show, for example 100, 2k, 5m, ...
  final String formattedValue;

  /// Determines the axis side of titles (left, top, right, bottom)
  final AxisSide axisSide;
}

typedef GetTitleWidgetFunction = Widget Function(double value, TitleMeta meta);

Widget defaultGetTitle(double value, TitleMeta meta) => SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      meta.formattedValue,
    ),
  );

class SideTitles with EquatableMixin {
  SideTitles({
    bool? showTitles,
    GetTitleWidgetFunction? getTitlesWidget,
    double? reservedSize,
    this.interval,
  })  : showTitles = showTitles ?? false,
        getTitlesWidget = getTitlesWidget ?? defaultGetTitle,
        reservedSize = reservedSize ?? 22 {
    if (interval == 0) {
      throw ArgumentError("SideTitles.interval couldn't be zero");
    }
  }

  /// Determines showing or hiding this side titles
  final bool showTitles;

  /// You can override it to pass your custom widget to show in each axis value
  /// We recommend you to use [SideTitleWidget].
  final GetTitleWidgetFunction getTitlesWidget;

  /// It determines the maximum space that your titles need,
  /// (All titles will stretch using this value)
  final double reservedSize;

  /// Texts are showing with provided [interval]. If you don't provide anything,
  /// we try to find a suitable value to set as [interval] under the hood.
  final double? interval;

  static SideTitles lerp(SideTitles a, SideTitles b, double t) => SideTitles(
      showTitles: b.showTitles,
      getTitlesWidget: b.getTitlesWidget,
      reservedSize: lerpDouble(a.reservedSize, b.reservedSize, t),
      interval: lerpDouble(a.interval, b.interval, t),
    );

  /// Copies current [SideTitles] to a new [SideTitles],
  /// and replaces provided values.
  SideTitles copyWith({
    bool? showTitles,
    GetTitleWidgetFunction? getTitlesWidget,
    double? reservedSize,
    double? interval,
  }) => SideTitles(
      showTitles: showTitles ?? this.showTitles,
      getTitlesWidget: getTitlesWidget ?? this.getTitlesWidget,
      reservedSize: reservedSize ?? this.reservedSize,
      interval: interval ?? this.interval,
    );

  @override
  List<Object?> get props => [
    showTitles,
    getTitlesWidget,
    reservedSize,
    interval,
  ];
}


class SideTitleFitInsideData with EquatableMixin {
  const SideTitleFitInsideData({
    required this.enabled,
    required this.axisPosition,
    required this.parentAxisSize,
    required this.distanceFromEdge,
  });


  factory SideTitleFitInsideData.disable() => const SideTitleFitInsideData(
    enabled: false,
    distanceFromEdge: 0,
    parentAxisSize: 0,
    axisPosition: 0,
  );

  factory SideTitleFitInsideData.fromTitleMeta(
      TitleMeta meta, {
        bool enabled = true,
        double distanceFromEdge = 6,
      }) =>
      SideTitleFitInsideData(
        enabled: enabled,
        distanceFromEdge: distanceFromEdge,
        parentAxisSize: meta.parentAxisSize,
        axisPosition: meta.axisPosition,
      );

  /// Whether to enable fit inside to SideTitleWidget
  final bool enabled;

  /// Distance between child widget and its closest corresponding axis edge
  final double distanceFromEdge;

  /// Parent axis max width/height
  final double parentAxisSize;

  /// The position (in pixel) that applied to
  /// the child widget along its corresponding axis.
  final double axisPosition;

  @override
  List<Object?> get props => [
    enabled,
    distanceFromEdge,
    parentAxisSize,
    axisPosition,
  ];
}

class AxisTitles with EquatableMixin {
  AxisTitles({
    this.axisNameWidget,
    SideTitles? sideTitles,
  })  : sideTitles = sideTitles ?? SideTitles();


  /// It shows the name of axis, for example your x-axis shows year,
  /// then you might want to show it using [axisNameWidget] property as a widget
  final Widget? axisNameWidget;

  /// It is responsible to show your axis side labels.
  final SideTitles sideTitles;

  /// If there is something to show as axisTitles, it returns true
  bool get showAxisTitles => axisNameWidget != null ;

  /// If there is something to show as sideTitles, it returns true
  bool get showSideTitles =>
      sideTitles.showTitles && sideTitles.reservedSize != 0;

  static AxisTitles lerp(AxisTitles a, AxisTitles b, double t) => AxisTitles(
      axisNameWidget: b.axisNameWidget,
      sideTitles: SideTitles.lerp(a.sideTitles, b.sideTitles, t),
    );

  AxisTitles copyWith({
    Widget? axisNameWidget,
    SideTitles? sideTitles,
  }) => AxisTitles(
      axisNameWidget: axisNameWidget ?? this.axisNameWidget,
      sideTitles: sideTitles ?? this.sideTitles,
    );

  @override
  List<Object?> get props => [
    axisNameWidget,
    sideTitles,
  ];
}

class VTSTitlesData with EquatableMixin {
  VTSTitlesData({
    bool? show,
    AxisTitles? leftTitles,
    AxisTitles? topTitles,
    AxisTitles? rightTitles,
    AxisTitles? bottomTitles,
  })  : show = show ?? true,
        leftTitles = leftTitles ??
            AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 44,
                showTitles: true,
              ),
            ),
        topTitles = topTitles ??
            AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
              ),
            ),
        rightTitles = rightTitles ??
            AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 44,
                showTitles: true,
              ),
            ),
        bottomTitles = bottomTitles ??
            AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 30,
                showTitles: true,
              ),
            );
  final bool show;

  final AxisTitles leftTitles;
  final AxisTitles topTitles;
  final AxisTitles rightTitles;
  final AxisTitles bottomTitles;

  static VTSTitlesData lerp(VTSTitlesData a, VTSTitlesData b, double t) => VTSTitlesData(
      show: b.show,
      leftTitles: AxisTitles.lerp(a.leftTitles, b.leftTitles, t),
      rightTitles: AxisTitles.lerp(a.rightTitles, b.rightTitles, t),
      bottomTitles: AxisTitles.lerp(a.bottomTitles, b.bottomTitles, t),
      topTitles: AxisTitles.lerp(a.topTitles, b.topTitles, t),
    );

  VTSTitlesData copyWith({
    bool? show,
    AxisTitles? leftTitles,
    AxisTitles? topTitles,
    AxisTitles? rightTitles,
    AxisTitles? bottomTitles,
  }) => VTSTitlesData(
      show: show ?? this.show,
      leftTitles: leftTitles ?? this.leftTitles,
      topTitles: topTitles ?? this.topTitles,
      rightTitles: rightTitles ?? this.rightTitles,
      bottomTitles: bottomTitles ?? this.bottomTitles,
    );

  @override
  List<Object?> get props => [
    show,
    leftTitles,
    topTitles,
    rightTitles,
    bottomTitles,
  ];
}

class VTSSpot with EquatableMixin {
  const VTSSpot(this.x, this.y);
  final double x;
  final double y;

  VTSSpot copyWith({
    double? x,
    double? y,
  }) => VTSSpot(
      x ?? this.x,
      y ?? this.y,
    );

  @override
  String toString() => '($x, $y)';

  /// Used for splitting lines, or maybe other concepts.
  static const VTSSpot nullSpot = VTSSpot(double.nan, double.nan);

  /// Sets zero for x and y
  static const VTSSpot zero = VTSSpot(0, 0);

  /// Determines if [x] or [y] is null.
  bool isNull() => this == nullSpot;

  /// Determines if [x] and [y] is not null.
  bool isNotNull() => !isNull();

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
    x,
    y,
  ];

  static VTSSpot lerp(VTSSpot a, VTSSpot b, double t) {
    if (a == VTSSpot.nullSpot) {
      return b;
    }

    if (b == VTSSpot.nullSpot) {
      return a;
    }

    return VTSSpot(
      lerpDouble(a.x, b.x, t)!,
      lerpDouble(a.y, b.y, t)!,
    );
  }
}

/// Responsible to hold grid data,
class VTSGridData with EquatableMixin {
  VTSGridData({
    bool? show,
    bool? drawHorizontalLine,
    this.horizontalInterval,
    GetDrawingGridLine? getDrawingHorizontalLine,
    bool? drawVerticalLine,
    GetDrawingGridLine? getDrawingVerticalLine,
  })  : show = show ?? true,
        drawHorizontalLine = drawHorizontalLine ?? true,
        getDrawingHorizontalLine = getDrawingHorizontalLine ?? defaultGridLine,
        drawVerticalLine = drawVerticalLine ?? true,
        getDrawingVerticalLine = getDrawingVerticalLine ?? defaultGridLine
  {
    if (horizontalInterval == 0) {
      throw ArgumentError("VTSGridData.horizontalInterval couldn't be zero");
    }
  }

  /// Determines showing or hiding all horizontal and vertical lines.
  final bool show;

  /// Determines showing or hiding all horizontal lines.
  final bool drawHorizontalLine;

  /// Determines interval between horizontal lines, left it null to be auto calculated.
  final double? horizontalInterval;

  /// Gives you a y value, and gets a [VTSLine] that represents specified line.
  final GetDrawingGridLine getDrawingHorizontalLine;


  /// Determines showing or hiding all vertical lines.
  final bool drawVerticalLine;

  /// Gives you a x value, and gets a [VTSLine] that represents specified line.
  final GetDrawingGridLine getDrawingVerticalLine;


  static VTSGridData lerp(VTSGridData a, VTSGridData b, double t) => VTSGridData(
      show: b.show,
      drawHorizontalLine: b.drawHorizontalLine,
      horizontalInterval:
      lerpDouble(a.horizontalInterval, b.horizontalInterval, t),
      getDrawingHorizontalLine: b.getDrawingHorizontalLine,
      drawVerticalLine: b.drawVerticalLine,
      getDrawingVerticalLine: b.getDrawingVerticalLine,
    );

  VTSGridData copyWith({
    bool? show,
    bool? drawHorizontalLine,
    double? horizontalInterval,
    GetDrawingGridLine? getDrawingHorizontalLine,
    bool? drawVerticalLine,
    GetDrawingGridLine? getDrawingVerticalLine,
  }) => VTSGridData(
      show: show ?? this.show,
      drawHorizontalLine: drawHorizontalLine ?? this.drawHorizontalLine,
      horizontalInterval: horizontalInterval ?? this.horizontalInterval,
      getDrawingHorizontalLine:
      getDrawingHorizontalLine ?? this.getDrawingHorizontalLine,
      drawVerticalLine: drawVerticalLine ?? this.drawVerticalLine,
      getDrawingVerticalLine:
      getDrawingVerticalLine ?? this.getDrawingVerticalLine,
    );

  @override
  List<Object?> get props => [
    show,
    drawHorizontalLine,
    horizontalInterval,
    getDrawingHorizontalLine,
    drawVerticalLine,
    getDrawingVerticalLine,
  ];
}

typedef GetDrawingGridLine = VTSLine Function(double value);

VTSLine defaultGridLine(double value) => VTSLine(
    color: Colors.blueGrey,
    strokeWidth: 0.4,
    dashArray: [8, 4],
  );

class VTSLine with EquatableMixin {
  VTSLine({
    Color? color,
    double? strokeWidth,
    this.dashArray,
  })  : color = color ?? Colors.black,
        strokeWidth = strokeWidth ?? 2;

  final Color color;

  final double strokeWidth;


  final List<int>? dashArray;

  static VTSLine lerp(VTSLine a, VTSLine b, double t) => VTSLine(
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
    );

  VTSLine copyWith({
    Color? color,
    double? strokeWidth,
    List<int>? dashArray,
  }) => VTSLine(
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashArray: dashArray ?? this.dashArray,
    );

  @override
  List<Object?> get props => [
    color,
    strokeWidth,
    dashArray,
  ];
}

abstract class TouchedSpot with EquatableMixin {
  TouchedSpot(
      this.spot,
      this.offset,
      );

  final VTSSpot spot;


  final Offset offset;

  @override
  List<Object?> get props => [
    spot,
    offset,
  ];
}

class RangeAnnotations with EquatableMixin {
  RangeAnnotations({
    List<HorizontalRangeAnnotation>? horizontalRangeAnnotations,
    List<VerticalRangeAnnotation>? verticalRangeAnnotations,
  })  : horizontalRangeAnnotations = horizontalRangeAnnotations ?? const [],
        verticalRangeAnnotations = verticalRangeAnnotations ?? const [];
  final List<HorizontalRangeAnnotation> horizontalRangeAnnotations;
  final List<VerticalRangeAnnotation> verticalRangeAnnotations;

  static RangeAnnotations lerp(
      RangeAnnotations a,
      RangeAnnotations b,
      double t,
      ) => RangeAnnotations(
      horizontalRangeAnnotations: lerpHorizontalRangeAnnotationList(
        a.horizontalRangeAnnotations,
        b.horizontalRangeAnnotations,
        t,
      ),
      verticalRangeAnnotations: lerpVerticalRangeAnnotationList(
        a.verticalRangeAnnotations,
        b.verticalRangeAnnotations,
        t,
      ),
    );

  RangeAnnotations copyWith({
    List<HorizontalRangeAnnotation>? horizontalRangeAnnotations,
    List<VerticalRangeAnnotation>? verticalRangeAnnotations,
  }) => RangeAnnotations(
      horizontalRangeAnnotations:
      horizontalRangeAnnotations ?? this.horizontalRangeAnnotations,
      verticalRangeAnnotations:
      verticalRangeAnnotations ?? this.verticalRangeAnnotations,
    );

  @override
  List<Object?> get props => [
    horizontalRangeAnnotations,
    verticalRangeAnnotations,
  ];
}

class HorizontalRangeAnnotation with EquatableMixin {
  HorizontalRangeAnnotation({
    required this.y1,
    required this.y2,
    Color? color,
  }) : color = color ?? Colors.white;

  /// Determines starting point in vertical (y) axis.
  final double y1;

  /// Determines ending point in vertical (y) axis.
  final double y2;

  /// Fills the area with this color.
  final Color color;

  static HorizontalRangeAnnotation lerp(
      HorizontalRangeAnnotation a,
      HorizontalRangeAnnotation b,
      double t,
      ) => HorizontalRangeAnnotation(
      y1: lerpDouble(a.y1, b.y1, t)!,
      y2: lerpDouble(a.y2, b.y2, t)!,
      color: Color.lerp(a.color, b.color, t),
    );

  HorizontalRangeAnnotation copyWith({
    double? y1,
    double? y2,
    Color? color,
  }) => HorizontalRangeAnnotation(
      y1: y1 ?? this.y1,
      y2: y2 ?? this.y2,
      color: color ?? this.color,
    );

  @override
  List<Object?> get props => [
    y1,
    y2,
    color,
  ];
}

class VerticalRangeAnnotation with EquatableMixin {
  VerticalRangeAnnotation({
    required this.x1,
    required this.x2,
    Color? color,
  }) : color = color ?? Colors.white;

  /// Determines starting point in horizontal (x) axis.
  final double x1;

  /// Determines ending point in horizontal (x) axis.
  final double x2;

  /// Fills the area with this color.
  final Color color;

  /// Lerps a [VerticalRangeAnnotation] based on [t] value, check [Tween.lerp].
  static VerticalRangeAnnotation lerp(
      VerticalRangeAnnotation a,
      VerticalRangeAnnotation b,
      double t,
      ) => VerticalRangeAnnotation(
      x1: lerpDouble(a.x1, b.x1, t)!,
      x2: lerpDouble(a.x2, b.x2, t)!,
      color: Color.lerp(a.color, b.color, t),
    );

  VerticalRangeAnnotation copyWith({
    double? x1,
    double? x2,
    Color? color,
  }) => VerticalRangeAnnotation(
      x1: x1 ?? this.x1,
      x2: x2 ?? this.x2,
      color: color ?? this.color,
    );

  @override
  List<Object?> get props => [
    x1,
    x2,
    color,
  ];
}

class HorizontalLine extends VTSLine with EquatableMixin {
  HorizontalLine({
    required this.y,
    HorizontalLineLabel? label,
    Color? color,
    double? strokeWidth,
    super.dashArray,
    this.image,
    this.sizedPicture,
  })  : label = label ?? HorizontalLineLabel(),
        super(
        color: color ?? Colors.black,
        strokeWidth: strokeWidth ?? 2,
      );

  /// Draws from left to right of the chart using the [y] value.
  final double y;

  /// Use it for any kind of image, to draw it in left side of the chart.
  Image? image;

  /// Use it for vector images, to draw it in left side of the chart.
  SizedPicture? sizedPicture;

  /// Draws a text label over the line.
  final HorizontalLineLabel label;

  static HorizontalLine lerp(HorizontalLine a, HorizontalLine b, double t) => HorizontalLine(
      y: lerpDouble(a.y, b.y, t)!,
      label: HorizontalLineLabel.lerp(a.label, b.label, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );

  @override
  List<Object?> get props => [
    y,
    label,
    color,
    strokeWidth,
    dashArray,
    image,
    sizedPicture,
  ];
}

class VerticalLine extends VTSLine with EquatableMixin {
  VerticalLine({
    required this.x,
    VerticalLineLabel? label,
    Color? color,
    double? strokeWidth,
    super.dashArray,
    this.image,
    this.sizedPicture,
  })  : label = label ?? VerticalLineLabel(),
        super(
        color: color ?? Colors.black,
        strokeWidth: strokeWidth ?? 2,
      );

  final double x;

  Image? image;

  SizedPicture? sizedPicture;

  final VerticalLineLabel label;

  static VerticalLine lerp(VerticalLine a, VerticalLine b, double t) => VerticalLine(
      x: lerpDouble(a.x, b.x, t)!,
      label: VerticalLineLabel.lerp(a.label, b.label, t),
      color: Color.lerp(a.color, b.color, t),
      strokeWidth: lerpDouble(a.strokeWidth, b.strokeWidth, t),
      dashArray: lerpIntList(a.dashArray, b.dashArray, t),
      image: b.image,
      sizedPicture: b.sizedPicture,
    );

  VerticalLine copyVerticalLineWith({
    double? x,
    VerticalLineLabel? label,
    Color? color,
    double? strokeWidth,
    List<int>? dashArray,
    Image? image,
    SizedPicture? sizedPicture,
  }) => VerticalLine(
      x: x ?? this.x,
      label: label ?? this.label,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      dashArray: dashArray ?? this.dashArray,
      image: image ?? this.image,
      sizedPicture: sizedPicture ?? this.sizedPicture,
    );

  @override
  List<Object?> get props => [
    x,
    label,
    color,
    strokeWidth,
    dashArray,
    image,
    sizedPicture,
  ];
}

class HorizontalLineLabel extends VTSLineLabel with EquatableMixin {
  HorizontalLineLabel({
    EdgeInsets? padding,
    super.style,
    Alignment? alignment,
    super.show = false,
    String Function(HorizontalLine)? labelResolver,
  })  : labelResolver =
      labelResolver ?? HorizontalLineLabel.defaultLineLabelResolver,
        super(
        padding: padding ?? const EdgeInsets.all(6),
        alignment: alignment ?? Alignment.topLeft,
      );

  final String Function(HorizontalLine) labelResolver;

  static String defaultLineLabelResolver(HorizontalLine line) =>
      line.y.toStringAsFixed(1);

  static HorizontalLineLabel lerp(
      HorizontalLineLabel a,
      HorizontalLineLabel b,
      double t,
      ) => HorizontalLineLabel(
      padding:
      EdgeInsets.lerp(a.padding as EdgeInsets, b.padding as EdgeInsets, t),
      style: TextStyle.lerp(a.style, b.style, t),
      alignment: Alignment.lerp(a.alignment, b.alignment, t),
      labelResolver: b.labelResolver,
      show: b.show,
    );

  @override
  List<Object?> get props => [
    labelResolver,
    show,
    padding,
    style,
    alignment,
  ];
}

class VerticalLineLabel extends VTSLineLabel with EquatableMixin {
  VerticalLineLabel({
    EdgeInsets? padding,
    TextStyle? style,
    Alignment? alignment,
    bool? show,
    String Function(VerticalLine)? labelResolver,
  })  : labelResolver =
      labelResolver ?? VerticalLineLabel.defaultLineLabelResolver,
        super(
        show: show ?? false,
        padding: padding ?? const EdgeInsets.all(6),
        style: style ??
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
        alignment: alignment ?? Alignment.bottomRight,
      );

  final String Function(VerticalLine) labelResolver;

  static String defaultLineLabelResolver(VerticalLine line) =>
      line.x.toStringAsFixed(1);

  static VerticalLineLabel lerp(
      VerticalLineLabel a,
      VerticalLineLabel b,
      double t,
      ) => VerticalLineLabel(
      padding:
      EdgeInsets.lerp(a.padding as EdgeInsets, b.padding as EdgeInsets, t),
      style: TextStyle.lerp(a.style, b.style, t),
      alignment: Alignment.lerp(a.alignment, b.alignment, t),
      labelResolver: b.labelResolver,
      show: b.show,
    );

  @override
  List<Object?> get props => [
    labelResolver,
    show,
    padding,
    style,
    alignment,
  ];
}

class SizedPicture with EquatableMixin {
  SizedPicture(this.picture, this.width, this.height);

  Picture picture;

  int width;

  int height;

  @override
  List<Object?> get props => [
    picture,
    width,
    height,
  ];
}

class ExtraLinesData with EquatableMixin {
  ExtraLinesData({
    List<HorizontalLine>? horizontalLines,
    List<VerticalLine>? verticalLines,
    bool? extraLinesOnTop,
  })  : horizontalLines = horizontalLines ?? const [],
        verticalLines = verticalLines ?? const [],
        extraLinesOnTop = extraLinesOnTop ?? true;
  final List<HorizontalLine> horizontalLines;
  final List<VerticalLine> verticalLines;

  final bool extraLinesOnTop;

  static ExtraLinesData lerp(ExtraLinesData a, ExtraLinesData b, double t) => ExtraLinesData(
      extraLinesOnTop: b.extraLinesOnTop,
      horizontalLines:
      lerpHorizontalLineList(a.horizontalLines, b.horizontalLines, t),
      verticalLines: lerpVerticalLineList(a.verticalLines, b.verticalLines, t),
    );

  @override
  List<Object?> get props => [
    horizontalLines,
    verticalLines,
    extraLinesOnTop,
  ];
}
