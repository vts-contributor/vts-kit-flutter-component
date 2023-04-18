import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/pain_ext.dart';
import 'package:vts_component/common/extension/spot_list_ext.dart';
import 'package:vts_component/common/extension/text_align_ext.dart';
import 'package:vts_component/components/line_chart_style_1/utils.dart';

import '../axis/axis_chart_painter.dart';
import '../axis/axit_chart_data.dart';
import '../base_chart/base_chart_painter.dart';
import '../canvas_wrapper.dart';
import 'vts_line_chart_data.dart';



class VTSLineChartPainter extends AxisChartPainter<VTSLineChartData> {
  VTSLineChartPainter() : super() {
    _barPaint = Paint()..style = PaintingStyle.stroke;


    _touchLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    _borderTouchTooltipPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.transparent
      ..strokeWidth = 1.0;
  }
  late Paint _barPaint;
  late Paint _touchLinePaint;
  late Paint _bgTouchTooltipPaint;
  late Paint _borderTouchTooltipPaint;

  @override
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<VTSLineChartData> holder,
  ) {
    final data = holder.data;
    if (data.lineBarsData.isEmpty) {
      return;
    }

    if (data.clipData.any) {
      canvasWrapper.saveLayer(
        Rect.fromLTWH(
          0,
          -40,
          canvasWrapper.size.width + 40,
          canvasWrapper.size.height + 40,
        ),
        Paint(),
      );

      clipToBorder(canvasWrapper, holder);
    }

    super.paint(context, canvasWrapper, holder);


    if (!data.extraLinesData.extraLinesOnTop) {
      super.drawExtraLines(context, canvasWrapper, holder);
    }

    final lineIndexDrawingInfo = <LineIndexDrawingInfo>[];

    for (var i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      if (!barData.show) {
        continue;
      }
      drawBarLine(canvasWrapper, barData, holder);
      drawDots(canvasWrapper, barData, holder);

      if (data.extraLinesData.extraLinesOnTop) {
        super.drawExtraLines(context, canvasWrapper, holder);
      }

      final indicatorsData = data.lineTouchData
          .getTouchedSpotIndicator(barData, barData.showingIndicators);

      if (indicatorsData.length != barData.showingIndicators.length) {
        throw Exception(
        );
      }

      for (var j = 0; j < barData.showingIndicators.length; j++) {
        final indicatorData = indicatorsData[j];
        final index = barData.showingIndicators[j];
        if (index < 0 || index >= barData.spots.length) {
          continue;
        }
        final spot = barData.spots[index];

        if (indicatorData == null) {
          continue;
        }
        lineIndexDrawingInfo.add(
          LineIndexDrawingInfo(barData, i, spot, index, indicatorData),
        );
      }
    }

    drawTouchedSpotsIndicator(canvasWrapper, lineIndexDrawingInfo, holder);

    if (data.clipData.any) {
      canvasWrapper.restore();
    }

    for (var i = 0; i < data.showingTooltipIndicators.length; i++) {
      var tooltipSpots = data.showingTooltipIndicators[i];

      final showingBarSpots = tooltipSpots.showingSpots;
      if (showingBarSpots.isEmpty) {
        continue;
      }
      final barSpots = List<LineBarSpot>.of(showingBarSpots);
      VTSSpot topSpot = barSpots[0];
      for (final barSpot in barSpots) {
        if (barSpot.y > topSpot.y) {
          topSpot = barSpot;
        }
      }
      tooltipSpots = ShowingTooltipIndicators(barSpots);

      drawTouchTooltip(
        context,
        canvasWrapper,
        data.lineTouchData.touchTooltipData,
        topSpot,
        tooltipSpots,
        holder,
      );
    }
  }

  @visibleForTesting
  void clipToBorder(
    CanvasWrapper canvasWrapper,
    PaintHolder<VTSLineChartData> holder,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;
    final clip = data.clipData;
    final border = data.borderData.show ? data.borderData.border : null;

    var left = 0.0;
    var top = 0.0;
    var right = viewSize.width;
    var bottom = viewSize.height;

    if (clip.left) {
      final borderWidth = border?.left.width ?? 0;
      left = borderWidth / 2;
    }
    if (clip.top) {
      final borderWidth = border?.top.width ?? 0;
      top = borderWidth / 2;
    }
    if (clip.right) {
      final borderWidth = border?.right.width ?? 0;
      right = viewSize.width - (borderWidth / 2);
    }
    if (clip.bottom) {
      final borderWidth = border?.bottom.width ?? 0;
      bottom = viewSize.height - (borderWidth / 2);
    }

    canvasWrapper.clipRect(Rect.fromLTRB(left, top, right, bottom));
  }

  @visibleForTesting
  void drawBarLine(
    CanvasWrapper canvasWrapper,
    LineChartBarData barData,
    PaintHolder<VTSLineChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;
    final barList = barData.spots.splitByNullSpots();

    for (final bar in barList) {
      final barPath = generateBarPath(viewSize, barData, bar, holder);
      drawBarShadow(canvasWrapper, barPath, barData);
      drawBar(canvasWrapper, barPath, barData, holder);
    }
  }

  @visibleForTesting
  void drawDots(
    CanvasWrapper canvasWrapper,
    LineChartBarData barData,
    PaintHolder<VTSLineChartData> holder,
  ) {
    if (!barData.dotData.show || barData.spots.isEmpty) {
      return;
    }
    final viewSize = canvasWrapper.size;

    final barXDelta = getBarLineXLength(barData, viewSize, holder);

    for (var i = 0; i < barData.spots.length; i++) {
      final spot = barData.spots[i];
      if (spot.isNotNull() && barData.dotData.checkToShowDot(spot, barData)) {
        final x = getPixelX(spot.x, viewSize, holder);
        final y = getPixelY(spot.y, viewSize, holder);
        final xPercentInLine = (x / barXDelta) * 100;
        final painter =
            barData.dotData.getDotPainter(spot, xPercentInLine, barData, i);

        canvasWrapper.drawDot(painter, spot, Offset(x, y));
      }
    }
  }

  @visibleForTesting
  void drawTouchedSpotsIndicator(
    CanvasWrapper canvasWrapper,
    List<LineIndexDrawingInfo> lineIndexDrawingInfo,
    PaintHolder<VTSLineChartData> holder,
  ) {
    if (lineIndexDrawingInfo.isEmpty) {
      return;
    }
    final viewSize = canvasWrapper.size;

    lineIndexDrawingInfo.sort((a, b) => b.spot.y.compareTo(a.spot.y));

    for (final info in lineIndexDrawingInfo) {
      final barData = info.line;
      final barXDelta = getBarLineXLength(barData, viewSize, holder);

      final data = holder.data;

      final index = info.spotIndex;
      final spot = info.spot;
      final indicatorData = info.indicatorData;

      final touchedSpot = Offset(
        getPixelX(spot.x, viewSize, holder),
        getPixelY(spot.y, viewSize, holder),
      );

      final showingDots = indicatorData.touchedSpotDotData.show;
      var dotHeight = 0.0;
      late VTSDotPainter dotPainter;

      if (showingDots) {
        final xPercentInLine = (touchedSpot.dx / barXDelta) * 100;
        dotPainter = indicatorData.touchedSpotDotData
            .getDotPainter(spot, xPercentInLine, barData, index);
        dotHeight = dotPainter.getSize(spot).height;
      }

      final lineStartY = min(
        data.maxY,
        max(data.minY, data.lineTouchData.getTouchLineStart(barData, index)),
      );
      final lineEndY = min(
        data.maxY,
        max(data.minY, data.lineTouchData.getTouchLineEnd(barData, index)),
      );
      final lineStart =
          Offset(touchedSpot.dx, getPixelY(lineStartY, viewSize, holder));
      var lineEnd =
          Offset(touchedSpot.dx, getPixelY(lineEndY, viewSize, holder));

      final dotMinY = touchedSpot.dy - dotHeight / 2;
      final dotMaxY = touchedSpot.dy + dotHeight / 2;
      if (lineEnd.dy > dotMinY && lineEnd.dy < dotMaxY) {
        if (lineStart.dy < lineEnd.dy) {
          lineEnd -= Offset(0, lineEnd.dy - dotMinY);
        } else {
          lineEnd += Offset(0, dotMaxY - lineEnd.dy);
        }
      }

      _touchLinePaint
        ..color = indicatorData.indicatorBelowLine.color
        ..strokeWidth = indicatorData.indicatorBelowLine.strokeWidth
        ..transparentIfWidthIsZero();

      canvasWrapper.drawDashedLine(
        lineStart,
        lineEnd,
        _touchLinePaint,
        indicatorData.indicatorBelowLine.dashArray,
      );

      if (showingDots) {
        canvasWrapper.drawDot(dotPainter, spot, touchedSpot);
      }
    }
  }

  @visibleForTesting
  Path generateBarPath(
    Size viewSize,
    LineChartBarData barData,
    List<VTSSpot> barSpots,
    PaintHolder<VTSLineChartData> holder, {
    Path? appendToPath,
  }) => generateNormalBarPath(
      viewSize,
      barData,
      barSpots,
      holder,
      appendToPath: appendToPath,
    );

  @visibleForTesting
  Path generateNormalBarPath(
    Size viewSize,
    LineChartBarData barData,
    List<VTSSpot> barSpots,
    PaintHolder<VTSLineChartData> holder, {
    Path? appendToPath,
  }) {
    final path = appendToPath ?? Path();
    final size = barSpots.length;

    var temp = Offset.zero;

    final x = getPixelX(barSpots[0].x, viewSize, holder);
    final y = getPixelY(barSpots[0].y, viewSize, holder);
    if (appendToPath == null) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
    for (var i = 1; i < size; i++) {
      final current = Offset(
        getPixelX(barSpots[i].x, viewSize, holder),
        getPixelY(barSpots[i].y, viewSize, holder),
      );

      final previous = Offset(
        getPixelX(barSpots[i - 1].x, viewSize, holder),
        getPixelY(barSpots[i - 1].y, viewSize, holder),
      );

      final next = Offset(
        getPixelX(barSpots[i + 1 < size ? i + 1 : i].x, viewSize, holder),
        getPixelY(barSpots[i + 1 < size ? i + 1 : i].y, viewSize, holder),
      );

      final controlPoint1 = previous + temp;

      const smoothness =  0.0;
      temp = ((next - previous) / 2) * smoothness;

      final controlPoint2 = current - temp;

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        current.dx,
        current.dy,
      );
    }

    return path;
  }

  @visibleForTesting
  Path generateStepBarPath(
    Size viewSize,
    LineChartBarData barData,
    List<VTSSpot> barSpots,
    PaintHolder<VTSLineChartData> holder, {
    Path? appendToPath,
  }) {
    final path = appendToPath ?? Path();
    final size = barSpots.length;

    final x = getPixelX(barSpots[0].x, viewSize, holder);
    final y = getPixelY(barSpots[0].y, viewSize, holder);
    if (appendToPath == null) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
    for (var i = 0; i < size; i++) {
      /// CurrentSpot
      final current = Offset(
        getPixelX(barSpots[i].x, viewSize, holder),
        getPixelY(barSpots[i].y, viewSize, holder),
      );

      /// next point
      final next = Offset(
        getPixelX(barSpots[i + 1 < size ? i + 1 : i].x, viewSize, holder),
        getPixelY(barSpots[i + 1 < size ? i + 1 : i].y, viewSize, holder),
      );


      if (current.dy == next.dy) {
        path.lineTo(next.dx, next.dy);
      } else {
        final deltaX = next.dx - current.dx;

        path
          ..lineTo(current.dx + deltaX , current.dy)
          ..lineTo(current.dx + deltaX , next.dy)
          ..lineTo(next.dx, next.dy);
      }
    }

    return path;
  }


  @visibleForTesting
  void drawBarShadow(
    CanvasWrapper canvasWrapper,
    Path barPath,
    LineChartBarData barData,
  ) {
    if (!barData.show || barData.shadow.color.opacity == 0.0) {
      return;
    }

    _barPaint
      ..strokeCap =  StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter
      ..color = barData.shadow.color
      ..shader = null
      ..strokeWidth = barData.barWidth
      ..color = barData.shadow.color
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        Utils().convertRadiusToSigma(barData.shadow.blurRadius),
      );


    barPath = barPath.shift(barData.shadow.offset);

    canvasWrapper.drawPath(
      barPath,
      _barPaint,
    );
  }

  @visibleForTesting
  void drawBar(
    CanvasWrapper canvasWrapper,
    Path barPath,
    LineChartBarData barData,
    PaintHolder<VTSLineChartData> holder,
  ) {
    if (!barData.show) {
      return;
    }
    final viewSize = canvasWrapper.size;

    _barPaint
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    final rectAroundTheLine = Rect.fromLTRB(
      getPixelX(barData.mostLeftSpot.x, viewSize, holder),
      getPixelY(barData.mostTopSpot.y, viewSize, holder),
      getPixelX(barData.mostRightSpot.x, viewSize, holder),
      getPixelY(barData.mostBottomSpot.y, viewSize, holder),
    );
    _barPaint
      ..setColorOrGradient(
        barData.color,
        barData.gradient,
        rectAroundTheLine,
      )
      ..maskFilter = null
      ..strokeWidth = barData.barWidth
      ..transparentIfWidthIsZero();

    canvasWrapper.drawPath(barPath, _barPaint);
  }

  @visibleForTesting
  void drawTouchTooltip(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    LineTouchTooltipData tooltipData,
      VTSSpot showOnSpot,
    ShowingTooltipIndicators showingTooltipSpots,
    PaintHolder<VTSLineChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;

    const textsBelowMargin = 4;

    final drawingTextPainters = <TextPainter>[];

    final tooltipItems =
        tooltipData.getTooltipItems(showingTooltipSpots.showingSpots);
    if (tooltipItems.length != showingTooltipSpots.showingSpots.length) {
      throw Exception('');
    }

    for (var i = 0; i < showingTooltipSpots.showingSpots.length; i++) {
      final tooltipItem = tooltipItems[i];
      if (tooltipItem == null) {
        continue;
      }

      final span = TextSpan(
        style: Utils().getThemeAwareTextStyle(context, tooltipItem.textStyle),
        text: tooltipItem.text,
        children: tooltipItem.children,
      );

      final tp = TextPainter(
        text: span,
        textAlign: tooltipItem.textAlign,
        textDirection: tooltipItem.textDirection,
        textScaleFactor: holder.textScale,
      )..layout(maxWidth: 120);
      drawingTextPainters.add(tp);
    }
    if (drawingTextPainters.isEmpty) {
      return;
    }

    var biggerWidth = 0.0;
    var sumTextsHeight = 0.0;
    for (final tp in drawingTextPainters) {
      if (tp.width > biggerWidth) {
        biggerWidth = tp.width;
      }
      sumTextsHeight += tp.height;
    }
    sumTextsHeight += (drawingTextPainters.length - 1) * textsBelowMargin;

    final mostTopOffset = Offset(
      getPixelX(showOnSpot.x, viewSize, holder),
      getPixelY(showOnSpot.y, viewSize, holder),
    );

    final tooltipWidth = biggerWidth + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = sumTextsHeight + tooltipData.tooltipPadding.vertical;

    double tooltipTopPosition;

    tooltipTopPosition =
        mostTopOffset.dy - tooltipHeight - tooltipData.tooltipMargin;

    final tooltipLeftPosition = getTooltipLeft(
      mostTopOffset.dx,
      tooltipWidth,
      tooltipData.tooltipHorizontalAlignment,
      // tooltipData.tooltipHorizontalOffset,
    );

    var rect = Rect.fromLTWH(
      tooltipLeftPosition,
      tooltipTopPosition,
      tooltipWidth,
      tooltipHeight,
    );

    if (tooltipData.fitInsideHorizontally) {
      if (rect.left < 0) {
        final shiftAmount = 0 - rect.left;
        rect = Rect.fromLTRB(
          rect.left + shiftAmount,
          rect.top,
          rect.right + shiftAmount,
          rect.bottom,
        );
      }

      if (rect.right > viewSize.width) {
        final shiftAmount = rect.right - viewSize.width;
        rect = Rect.fromLTRB(
          rect.left - shiftAmount,
          rect.top,
          rect.right - shiftAmount,
          rect.bottom,
        );
      }
    }

    if (tooltipData.fitInsideVertically) {
      if (rect.top < 0) {
        final shiftAmount = 0 - rect.top;
        rect = Rect.fromLTRB(
          rect.left,
          rect.top + shiftAmount,
          rect.right,
          rect.bottom + shiftAmount,
        );
      }

      if (rect.bottom > viewSize.height) {
        final shiftAmount = rect.bottom - viewSize.height;
        rect = Rect.fromLTRB(
          rect.left,
          rect.top - shiftAmount,
          rect.right,
          rect.bottom - shiftAmount,
        );
      }
    }

    final radius = Radius.circular(tooltipData.tooltipRoundedRadius);
    final roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    );
    _bgTouchTooltipPaint.color = tooltipData.tooltipBgColor;

    final rotateAngle = tooltipData.rotateAngle;
    final rectRotationOffset =
        Offset(0, Utils().calculateRotationOffset(rect.size, rotateAngle).dy);
    final rectDrawOffset = Offset(roundedRect.left, roundedRect.top);

    final textRotationOffset =
        Utils().calculateRotationOffset(rect.size, rotateAngle);

    if (tooltipData.tooltipBorder != BorderSide.none) {
      _borderTouchTooltipPaint
        ..color = tooltipData.tooltipBorder.color
        ..strokeWidth = tooltipData.tooltipBorder.width;
    }

    canvasWrapper.drawRotated(
      size: rect.size,
      rotationOffset: rectRotationOffset,
      drawOffset: rectDrawOffset,
      angle: rotateAngle,
      drawCallback: () {
        canvasWrapper
          ..drawRRect(roundedRect, _bgTouchTooltipPaint)
          ..drawRRect(roundedRect, _borderTouchTooltipPaint);
      },
    );

    var topPosSeek = tooltipData.tooltipPadding.top;
    for (final tp in drawingTextPainters) {
      final yOffset = rect.topCenter.dy +
          topPosSeek -
          textRotationOffset.dy +
          rectRotationOffset.dy;

      double xOffset;
      switch (tp.textAlign.getFinalHorizontalAlignment(tp.textDirection)) {
        case HorizontalAlignment.left:
          xOffset = rect.left + tooltipData.tooltipPadding.left;
          break;
        case HorizontalAlignment.right:
          xOffset = rect.right - tooltipData.tooltipPadding.right - tp.width;
          break;
        default:
          xOffset = rect.center.dx - (tp.width / 2);
          break;
      }

      final drawOffset = Offset(
        xOffset,
        yOffset,
      );

      canvasWrapper.drawRotated(
        size: rect.size,
        rotationOffset: rectRotationOffset,
        drawOffset: rectDrawOffset,
        angle: rotateAngle,
        drawCallback: () {
          canvasWrapper.drawText(tp, drawOffset);
        },
      );
      topPosSeek += tp.height;
      topPosSeek += textsBelowMargin;
    }
  }

  @visibleForTesting
  double getBarLineXLength(
    LineChartBarData barData,
    Size chartUsableSize,
    PaintHolder<VTSLineChartData> holder,
  ) {
    if (barData.spots.isEmpty) {
      return 0;
    }

    final firstSpot = barData.spots[0];
    final firstSpotX = getPixelX(firstSpot.x, chartUsableSize, holder);

    final lastSpot = barData.spots[barData.spots.length - 1];
    final lastSpotX = getPixelX(lastSpot.x, chartUsableSize, holder);

    return lastSpotX - firstSpotX;
  }

  List<TouchLineBarSpot>? handleTouch(
    Offset localPosition,
    Size size,
    PaintHolder<VTSLineChartData> holder,
  ) {
    final data = holder.data;

    final touchedSpots = <TouchLineBarSpot>[];

    for (var i = 0; i < data.lineBarsData.length; i++) {
      final barData = data.lineBarsData[i];

      final foundTouchedSpot =
          getNearestTouchedSpot(size, localPosition, barData, i, holder);
      if (foundTouchedSpot != null) {
        touchedSpots.add(foundTouchedSpot);
      }
    }

    touchedSpots.sort((a, b) => a.distance.compareTo(b.distance));

    return touchedSpots.isEmpty ? null : touchedSpots;
  }

  @visibleForTesting
  TouchLineBarSpot? getNearestTouchedSpot(
    Size viewSize,
    Offset touchedPoint,
    LineChartBarData barData,
    int barDataPosition,
    PaintHolder<VTSLineChartData> holder,
  ) {
    final data = holder.data;
    if (!barData.show) {
      return null;
    }

    final sortedSpots = <VTSSpot>[];
    double? smallestDistance;
    for (final spot in barData.spots) {
      if (spot.isNull()) continue;
      final distance = data.lineTouchData.distanceCalculator(
        touchedPoint,
        Offset(
          getPixelX(spot.x, viewSize, holder),
          getPixelY(spot.y, viewSize, holder),
        ),
      );

      if (distance <= data.lineTouchData.touchSpotThreshold) {
        smallestDistance ??= distance;

        if (distance < smallestDistance) {
          sortedSpots.insert(0, spot);
          smallestDistance = distance;
        } else {
          sortedSpots.add(spot);
        }
      }
    }

    if (sortedSpots.isNotEmpty) {
      return TouchLineBarSpot(
        barData,
        barDataPosition,
        sortedSpots.first,
        smallestDistance!,
      );
    } else {
      return null;
    }
  }
}


@visibleForTesting
class LineIndexDrawingInfo {
  LineIndexDrawingInfo(
    this.line,
    this.lineIndex,
    this.spot,
    this.spotIndex,
    this.indicatorData,
  );
  final LineChartBarData line;
  final int lineIndex;
  final VTSSpot spot;
  final int spotIndex;
  final TouchedSpotIndicatorData indicatorData;
}
