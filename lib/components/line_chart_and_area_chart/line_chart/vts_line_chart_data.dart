import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:vts_component/common/extension/color_ext.dart';
import 'package:vts_component/common/extension/gradient_ext.dart';
import '../area_chart/vts_area_chart.dart';
import '../axis/axit_chart_data.dart';
import '../base_chart/base_chart_data.dart';
import '../lerp.dart';
import 'vts_line_chart_helper.dart';

class VTSLineChartData extends AxisChartData with EquatableMixin {
  VTSLineChartData({
    List<LineChartBarData>? lineBarsData,
    VTSTitlesData? titlesData,
    LineTouchData? lineTouchData,
    List<ShowingTooltipIndicators>? showingTooltipIndicators,
    VTSGridData? gridData,
    super.borderData,
    double? minX,
    double? maxX,
    super.baselineX,
    double? minY,
    double? maxY,
    super.baselineY,
    super.backgroundColor,
  })  : lineBarsData = lineBarsData ?? const [],
        lineTouchData = lineTouchData ?? LineTouchData(),
        showingTooltipIndicators = showingTooltipIndicators ?? const [],
        super(
          gridData: gridData ?? VTSGridData(),
          touchData: lineTouchData ?? LineTouchData(),
          titlesData: titlesData ?? VTSTitlesData(),
          minX: minX ??
              VTSLineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).minX,
          maxX: maxX ??
              VTSLineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).maxX,
          minY: minY ??
              VTSLineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).minY,
          maxY: maxY ??
              VTSLineChartHelper.calculateMaxAxisValues(lineBarsData ?? const []).maxY,
        );

  /// [LineChart] draws some lines in various shapes and overlaps them.
  final List<LineChartBarData> lineBarsData;

  /// Handles touch behaviors and responses.
  final LineTouchData lineTouchData;

  ///  can show some tooltipIndicators (a popup with an information)
  final List<ShowingTooltipIndicators> showingTooltipIndicators;

  @override
  VTSLineChartData lerp(BaseChartData a, BaseChartData b, double t) {
    if (a is VTSLineChartData && b is VTSLineChartData) {
      return VTSLineChartData(
        minX: lerpDouble(a.minX, b.minX, t),
        maxX: lerpDouble(a.maxX, b.maxX, t),
        baselineX: lerpDouble(a.baselineX, b.baselineX, t),
        minY: lerpDouble(a.minY, b.minY, t),
        maxY: lerpDouble(a.maxY, b.maxY, t),
        baselineY: lerpDouble(a.baselineY, b.baselineY, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        borderData: VTSBorderData.lerp(a.borderData, b.borderData, t),
        gridData: VTSGridData.lerp(a.gridData, b.gridData, t),
        titlesData: VTSTitlesData.lerp(a.titlesData, b.titlesData, t),
        lineBarsData:
            lerpLineChartBarDataList(a.lineBarsData, b.lineBarsData, t),
        lineTouchData: b.lineTouchData,
        showingTooltipIndicators: b.showingTooltipIndicators,
      );
    } else {
      throw Exception('Illegal State');
    }
  }

  VTSLineChartData copyWith({
    List<LineChartBarData>? lineBarsData,
    VTSTitlesData? titlesData,
    LineTouchData? lineTouchData,
    List<ShowingTooltipIndicators>? showingTooltipIndicators,
    VTSGridData? gridData,
    VTSBorderData? borderData,
    double? minX,
    double? maxX,
    double? baselineX,
    double? minY,
    double? maxY,
    double? baselineY,
    Color? backgroundColor,
  }) => VTSLineChartData(
      lineBarsData: lineBarsData ?? this.lineBarsData,
      titlesData: titlesData ?? this.titlesData,
      lineTouchData: lineTouchData ?? this.lineTouchData,
      showingTooltipIndicators:
          showingTooltipIndicators ?? this.showingTooltipIndicators,
      gridData: gridData ?? this.gridData,
      borderData: borderData ?? this.borderData,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      baselineX: baselineX ?? this.baselineX,
      minY: minY ?? this.minY,
      maxY: maxY ?? this.maxY,
      baselineY: baselineY ?? this.baselineY,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );

  @override
  List<Object?> get props => [
        lineBarsData,
        titlesData,
        lineTouchData,
        showingTooltipIndicators,
        gridData,
        borderData,
        minX,
        maxX,
        baselineX,
        minY,
        maxY,
        baselineY,
        backgroundColor,
      ];
}

class LineChartBarData with EquatableMixin {
  LineChartBarData({
    List<VTSSpot>? spots,
    bool? show,
    Color? color,
    BarAreaData? createAreaChart,
    this.gradient,
    double? barWidth,
    VTSDotData? dotData,
    List<int>? showingIndicators,
  })  : spots = spots ?? const [],
        show = show ?? true,
        createAreaChart = createAreaChart ?? BarAreaData(),
        color =
            color ?? ((color == null && gradient == null) ? Colors.cyan : null),
        barWidth = barWidth ?? 2.0,
        dotData = dotData ?? VTSDotData(),
        showingIndicators = showingIndicators ?? const []
  {
    VTSSpot? mostLeft;
    VTSSpot? mostTop;
    VTSSpot? mostRight;
    VTSSpot? mostBottom;

    VTSSpot? firstValidSpot;
    try {
      firstValidSpot =
          this.spots.firstWhere((element) => element != VTSSpot.nullSpot);
    } catch (e) {

    }
    if (firstValidSpot != null) {
      for (final spot in this.spots) {
        if (spot.isNull()) {
          continue;
        }
        if (mostLeft == null || spot.x < mostLeft.x) {
          mostLeft = spot;
        }

        if (mostRight == null || spot.x > mostRight.x) {
          mostRight = spot;
        }

        if (mostTop == null || spot.y > mostTop.y) {
          mostTop = spot;
        }

        if (mostBottom == null || spot.y < mostBottom.y) {
          mostBottom = spot;
        }
      }
      mostLeftSpot = mostLeft!;
      mostTopSpot = mostTop!;
      mostRightSpot = mostRight!;
      mostBottomSpot = mostBottom!;
    }
  }


  /// put a [VTSSpot.nullSpot] between each section.
  final List<VTSSpot> spots;

  /// We keep the most left spot to prevent redundant calculations
  late final VTSSpot mostLeftSpot;

  /// We keep the most top spot to prevent redundant calculations
  late final VTSSpot mostTopSpot;

  /// We keep the most right spot to prevent redundant calculations
  late final VTSSpot mostRightSpot;

  /// We keep the most bottom spot to prevent redundant calculations
  late final VTSSpot mostBottomSpot;

  /// Determines to show or hide the line.
  final bool show;

  /// If provided, this [LineChartBarData] draws with this [color]
  final Color? color;

  /// Fills the space blow the line, using a color or gradient.
  final BarAreaData createAreaChart;

  /// If provided, this [LineChartBarData] draws with this [gradient].
  final Gradient? gradient;

  /// Determines thickness of drawing line.
  final double barWidth;

  /// Responsible to showing [spots] on the line as a circular point.
  final VTSDotData dotData;

  /// Show indicators based on provided indexes
  final List<int> showingIndicators;

  /// Drops a shadow behind the bar line.
  final Shadow shadow = const Shadow(color: Colors.transparent);


  /// Lerps a [LineChartBarData] based on [t] value, check [Tween.lerp].
  static LineChartBarData lerp(
    LineChartBarData a,
    LineChartBarData b,
    double t,
  ) => LineChartBarData(
      show: b.show,
      barWidth: lerpDouble(a.barWidth, b.barWidth, t),
      createAreaChart: BarAreaData.lerp(a.createAreaChart, b.createAreaChart, t),
      dotData: VTSDotData.lerp(a.dotData, b.dotData, t),
      color: Color.lerp(a.color, b.color, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      spots: lerpVTSSpotList(a.spots, b.spots, t),
      showingIndicators: b.showingIndicators,
    );


  LineChartBarData copyWith({
    List<VTSSpot>? spots,
    bool? show,
    BarAreaData? createAreaChart,
    Color? color,
    Gradient? gradient,
    double? barWidth,

    VTSDotData? dotData,
    List<int>? showingIndicators,
  }) => LineChartBarData(
      spots: spots ?? this.spots,
      show: show ?? this.show,
      color: color ?? this.color,
      createAreaChart: createAreaChart ?? this.createAreaChart,
      gradient: gradient ?? this.gradient,
      barWidth: barWidth ?? this.barWidth,
      dotData: dotData ?? this.dotData,
      showingIndicators: showingIndicators ?? this.showingIndicators,
    );

  @override
  List<Object?> get props => [
        spots,
        show,
        color,
        gradient,
        barWidth,
        createAreaChart,
        dotData,
        showingIndicators,
        shadow,
      ];
}




typedef GetDotColorCallback = Color Function(VTSSpot, double, LineChartBarData);


Color _defaultGetDotColor(VTSSpot _, double xPercentage, LineChartBarData bar) {
  if (bar.gradient != null && bar.gradient is LinearGradient) {
    return lerpGradient(
      bar.gradient!.colors,
      bar.gradient!.getSafeColorStops(),
      xPercentage / 100,
    );
  }
  return bar.gradient?.colors.first ?? bar.color ?? Colors.blueGrey;
}

Color _defaultGetDotStrokeColor(
    VTSSpot spot,
  double xPercentage,
  LineChartBarData bar,
) {
  Color color;
  if (bar.gradient != null && bar.gradient is LinearGradient) {
    color = lerpGradient(
      bar.gradient!.colors,
      bar.gradient!.getSafeColorStops(),
      xPercentage / 100,
    );
  } else {
    color = bar.gradient?.colors.first ?? bar.color ?? Colors.blueGrey;
  }
  return color.darken();
}


typedef GetDotPainterCallback = VTSDotPainter Function(
    VTSSpot,
  double,
  LineChartBarData,
  int,
);

VTSDotPainter _defaultGetDotPainter(
    VTSSpot spot,
  double xPercentage,
  LineChartBarData bar,
  int index, {
  double? size,
}) => VTSDotCirclePainter(
    radius: size,
    color: _defaultGetDotColor(spot, xPercentage, bar),
    strokeColor: _defaultGetDotStrokeColor(spot, xPercentage, bar),
  );

class VTSDotData with EquatableMixin {
  VTSDotData({
    bool? show,
    CheckToShowDot? checkToShowDot,
    GetDotPainterCallback? getDotPainter,
  })  : show = show ?? true,
        checkToShowDot = checkToShowDot ?? showAllDots,
        getDotPainter = getDotPainter ?? _defaultGetDotPainter;

  /// Determines show or hide all dots.
  final bool show;

  /// Checks to show or hide an individual dot.
  final CheckToShowDot checkToShowDot;

  /// Callback which is called to set the painter of the given [VTSSpot].
  /// The [VTSSpot] is provided as parameter to this callback
  final GetDotPainterCallback getDotPainter;

  static VTSDotData lerp(VTSDotData a, VTSDotData b, double t) => VTSDotData(
      show: b.show,
      checkToShowDot: b.checkToShowDot,
      getDotPainter: b.getDotPainter,
    );

  @override
  List<Object?> get props => [
        show,
        checkToShowDot,
        getDotPainter,
      ];
}

abstract class VTSDotPainter with EquatableMixin {
  void draw(Canvas canvas, VTSSpot spot, Offset offsetInCanvas);

  Size getSize(VTSSpot spot);
}

class VTSDotCirclePainter extends VTSDotPainter {
  VTSDotCirclePainter({
    Color? color,
    double? radius,
    Color? strokeColor,
    double? strokeWidth,
  })  : color = color ?? Colors.green,
        radius = radius ?? 4.0,
        strokeColor = strokeColor ?? Colors.green.darken(),
        strokeWidth = strokeWidth ?? 1.0;

  /// The fill color to use for the circle
  Color color;

  /// Customizes the radius of the circle
  double radius;

  /// The stroke color to use for the circle
  Color strokeColor;

  /// The stroke width to use for the circle
  double strokeWidth;

  /// Implementation of the parent class to draw the circle
  @override
  void draw(Canvas canvas, VTSSpot spot, Offset offsetInCanvas) {
    if (strokeWidth != 0.0 && strokeColor.opacity != 0.0) {
      canvas.drawCircle(
        offsetInCanvas,
        radius + (strokeWidth / 2),
        Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke,
      );
    }
    canvas.drawCircle(
      offsetInCanvas,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  /// Implementation of the parent class to get the size of the circle
  @override
  Size getSize(VTSSpot spot) => Size(radius * 2, radius * 2);

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        color,
        radius,
        strokeColor,
        strokeWidth,
      ];
}



/// It determines showing or hiding [VTSDotData] on the spots.
///
/// It gives you the checking [VTSSpot] and you should decide to
/// show or hide the dot on this spot by returning true or false.
typedef CheckToShowDot = bool Function(VTSSpot spot, LineChartBarData barData);

/// Shows all dots on spots.
bool showAllDots(VTSSpot spot, LineChartBarData barData) => true;

/// Shows a text label
abstract class VTSLineLabel with EquatableMixin {
  /// Draws a title on the line, align it with [alignment] over the line,
  /// applies [padding] for spaces, and applies [style] for changing color,
  /// size, ... of the text.
  /// [show] determines showing label or not.
  VTSLineLabel({
    required this.show,
    required this.padding,
    required this.style,
    required this.alignment,
  });

  /// Determines showing label or not.
  final bool show;

  /// Inner spaces around the drawing text.
  final EdgeInsetsGeometry padding;

  /// Sets style of the drawing text.
  final TextStyle? style;

  /// Aligns the text on the line.
  final Alignment alignment;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        show,
        padding,
        style,
        alignment,
      ];
}

class LineTouchData extends FlTouchData<LineTouchResponse> with EquatableMixin {
  LineTouchData({
    bool? enabled,
    BaseTouchCallback<LineTouchResponse>? touchCallback,
    LineTouchTooltipData? touchTooltipData,
    GetTouchedSpotIndicator? getTouchedSpotIndicator,
    GetTouchLineY? getTouchLineStart,
    GetTouchLineY? getTouchLineEnd,
  })  : touchTooltipData = touchTooltipData ?? LineTouchTooltipData(),
        getTouchedSpotIndicator =
            getTouchedSpotIndicator ?? defaultTouchedIndicators,
        distanceCalculator =  _xDistance,
        getTouchLineStart = getTouchLineStart ?? defaultGetTouchLineStart,
        getTouchLineEnd = getTouchLineEnd ?? defaultGetTouchLineEnd,
        super(
          enabled ?? true,
          touchCallback
        );

  /// Configs of how touch tooltip popup.
  final LineTouchTooltipData touchTooltipData;

  /// Configs of how touch indicator looks like.
  final GetTouchedSpotIndicator getTouchedSpotIndicator;

  /// Distance threshold to handle the touch event.
  final double touchSpotThreshold = 10;

  /// Distance function used when finding closest points to touch point
  final CalculateTouchDistance distanceCalculator;


  /// The starting point on y axis of the touch line. By default, line starts on the bottom of
  /// the chart.
  final GetTouchLineY getTouchLineStart;

  /// The end point on y axis of the touch line. By default, line ends at the touched point.
  /// If line end is overlap with the dot, it will be automatically adjusted to the edge of the dot.
  final GetTouchLineY getTouchLineEnd;

  /// Copies current [LineTouchData] to a new [LineTouchData],
  /// and replaces provided values.
  LineTouchData copyWith({
    bool? enabled,
    BaseTouchCallback<LineTouchResponse>? touchCallback,
    MouseCursorResolver<LineTouchResponse>? mouseCursorResolver,
    LineTouchTooltipData? touchTooltipData,
    GetTouchedSpotIndicator? getTouchedSpotIndicator,
    CalculateTouchDistance? distanceCalculator,
    GetTouchLineY? getTouchLineStart,
    GetTouchLineY? getTouchLineEnd,
    bool? handleBuiltInTouches,
  }) => LineTouchData(
      enabled: enabled ?? this.enabled,
      touchCallback: touchCallback ?? this.touchCallback,
      touchTooltipData: touchTooltipData ?? this.touchTooltipData,
      getTouchedSpotIndicator:
          getTouchedSpotIndicator ?? this.getTouchedSpotIndicator,
      getTouchLineStart: getTouchLineStart ?? this.getTouchLineStart,
      getTouchLineEnd: getTouchLineEnd ?? this.getTouchLineEnd,
    );

  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        touchTooltipData,
        getTouchedSpotIndicator,
        getTouchLineStart,
        getTouchLineEnd,
      ];
}


typedef GetTouchedSpotIndicator = List<TouchedSpotIndicatorData?> Function(
  LineChartBarData barData,
  List<int> spotIndexes,
);

typedef GetTouchLineY = double Function(
  LineChartBarData barData,
  int spotIndex,
);

typedef CalculateTouchDistance = double Function(
  Offset touchPoint,
  Offset spotPixelCoordinates,
);

double _xDistance(Offset touchPoint, Offset spotPixelCoordinates) => (touchPoint.dx - spotPixelCoordinates.dx).abs();

List<TouchedSpotIndicatorData> defaultTouchedIndicators(
  LineChartBarData barData,
  List<int> indicators,
) => indicators.map((int index) {
    var lineColor = barData.gradient?.colors.first ?? barData.color;
    if (barData.dotData.show) {
      lineColor = _defaultGetDotColor(barData.spots[index], 0, barData);
    }
    const lineStrokeWidth = 4.0;
    final vtsLine = VTSLine(color: lineColor, strokeWidth: lineStrokeWidth);

    var dotSize = 10.0;
    if (barData.dotData.show) {
      dotSize = 4.0 * 1.8;
    }

    final dotData = VTSDotData(
      getDotPainter: (spot, percent, bar, index) =>
          _defaultGetDotPainter(spot, percent, bar, index, size: dotSize),
    );
    return TouchedSpotIndicatorData(vtsLine, dotData);
  }).toList();

/// By default line starts from the bottom of the chart.
double defaultGetTouchLineStart(LineChartBarData barData, int spotIndex) => -double.infinity;

/// By default line ends at the touched point.
double defaultGetTouchLineEnd(LineChartBarData barData, int spotIndex) => barData.spots[spotIndex].y;

/// Holds representation data for showing tooltip popup on top of spots.
class LineTouchTooltipData with EquatableMixin {
  LineTouchTooltipData({
    Color? tooltipBgColor,
    double? tooltipRoundedRadius,
    EdgeInsets? tooltipPadding,
    double? tooltipMargin,
    VTSHorizontalAlignment? tooltipHorizontalAlignment,
    GetLineTooltipItems? getTooltipItems,
    bool? fitInsideHorizontally,
    bool? fitInsideVertically,
    double? rotateAngle,
    BorderSide? tooltipBorder,
  })  : tooltipBgColor = tooltipBgColor ?? Colors.blueGrey.darken(15),
        tooltipRoundedRadius = tooltipRoundedRadius ?? 4,
        tooltipPadding = tooltipPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tooltipMargin = tooltipMargin ?? 16,
        tooltipHorizontalAlignment =
            tooltipHorizontalAlignment ?? VTSHorizontalAlignment.center,
        getTooltipItems = getTooltipItems ?? defaultLineTooltipItem,
        fitInsideHorizontally = fitInsideHorizontally ?? false,
        fitInsideVertically = fitInsideVertically ?? false,
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

  /// Controls showing tooltip on left side, right side or center aligned with spot, default is center
  final VTSHorizontalAlignment tooltipHorizontalAlignment;

  /// Retrieves data for showing content inside the tooltip.
  final GetLineTooltipItems getTooltipItems;

  /// Forces the tooltip to shift horizontally inside the chart, if overflow happens.
  final bool fitInsideHorizontally;

  /// Forces the tooltip to shift vertically inside the chart, if overflow happens.
  final bool fitInsideVertically;

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
        getTooltipItems,
        fitInsideHorizontally,
        fitInsideVertically,
        rotateAngle,
        tooltipBorder,
      ];
}


typedef GetLineTooltipItems = List<LineTooltipItem?> Function(
  List<LineBarSpot> touchedSpots,
);

/// Default implementation for [LineTouchTooltipData.getTooltipItems].
List<LineTooltipItem> defaultLineTooltipItem(List<LineBarSpot> touchedSpots) => touchedSpots.map((LineBarSpot touchedSpot) {
    final textStyle = TextStyle(
      color: touchedSpot.bar.gradient?.colors.first ??
          touchedSpot.bar.color ??
          Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return LineTooltipItem(touchedSpot.y.toString(), textStyle);
  }).toList();

/// Represent a targeted spot inside a line bar.
class LineBarSpot extends VTSSpot with EquatableMixin {
  /// [bar] is the [LineChartBarData] that this spot is inside of,
  /// [barIndex] is the index of our [bar], in the [LineChartData.lineBarsData] list,
  /// [spot] is the targeted spot.
  /// [spotIndex] is the index this [FlSpot], in the [LineChartBarData.spots] list.
  LineBarSpot(
    this.bar,
    this.barIndex,
      VTSSpot spot,
  )   : spotIndex = bar.spots.indexOf(spot),
        super(spot.x, spot.y);

  /// Is the [LineChartBarData] that this spot is inside of.
  final LineChartBarData bar;

  /// Is the index of our [bar], in the [LineChartData.lineBarsData] list,
  final int barIndex;

  /// Is the index of our [super.spot], in the [LineChartBarData.spots] list.
  final int spotIndex;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        bar,
        barIndex,
        spotIndex,
        x,
        y,
      ];
}

class TouchLineBarSpot extends LineBarSpot {
  TouchLineBarSpot(
    super.bar,
    super.barIndex,
    super.spot,
    this.distance,
  );

  /// Distance in pixels from where the user taped
  final double distance;
}

class LineTooltipItem with EquatableMixin {
  /// Shows a [text] with [textStyle], [textDirection],
  /// and optional [children] as a row in the tooltip popup.
  LineTooltipItem(
    this.text,
    this.textStyle, {
    this.textAlign = TextAlign.center,
    this.textDirection = TextDirection.ltr,
    this.children,
  });

  /// Showing text.
  final String text;

  /// Style of showing text.
  final TextStyle textStyle;

  /// Align of showing text.
  final TextAlign textAlign;

  /// Direction of showing text.
  final TextDirection textDirection;

  /// List<TextSpan> add further style and format to the text of the tooltip
  final List<TextSpan>? children;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        text,
        textStyle,
        textAlign,
        textDirection,
        children,
      ];
}


class TouchedSpotIndicatorData with EquatableMixin {
  TouchedSpotIndicatorData(this.indicatorBelowLine, this.touchedSpotDotData);

  /// Determines line's style.
  final VTSLine indicatorBelowLine;

  /// Determines dot's style.
  final VTSDotData touchedSpotDotData;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        indicatorBelowLine,
        touchedSpotDotData,
      ];
}

class ShowingTooltipIndicators with EquatableMixin {
  /// [LineChart] shows some tooltips over each [LineChartBarData],
  /// and [showingSpots] determines in which spots this tooltip should be shown.
  ShowingTooltipIndicators(this.showingSpots);

  /// Determines the spots that each tooltip should be shown.
  final List<LineBarSpot> showingSpots;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [showingSpots];
}


class LineTouchResponse extends BaseTouchResponse {
  LineTouchResponse(this.lineBarSpots) : super();

  /// touch happened on these spots
  /// (if a single line provided on the chart, [lineBarSpots]'s length will be 1 always)
  final List<TouchLineBarSpot>? lineBarSpots;

  /// Copies current [LineTouchResponse] to a new [LineTouchResponse],
  /// and replaces provided values.
  LineTouchResponse copyWith({
    List<TouchLineBarSpot>? lineBarSpots,
  }) => LineTouchResponse(
      lineBarSpots ?? this.lineBarSpots,
    );
}

class LineChartDataTween extends Tween<VTSLineChartData> {
  LineChartDataTween({required VTSLineChartData begin, required VTSLineChartData end})
      : super(begin: begin, end: end);

  /// Lerps a [VTSLineChartData] based on [t] value, check [Tween.lerp].
  @override
  VTSLineChartData lerp(double t) => begin!.lerp(begin!, end!, t);
}



