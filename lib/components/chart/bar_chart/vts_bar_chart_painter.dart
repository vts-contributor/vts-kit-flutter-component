import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/bar_chart_data_ext.dart';
import 'package:vts_component/common/extension/pain_ext.dart';
import 'package:vts_component/common/extension/rect_ext.dart';

import '../axis/axis_chart_painter.dart';
import '../axis/axit_chart_data.dart';
import '../base_chart/base_chart_painter.dart';
import '../canvas_wrapper.dart';
import '../utils.dart';
import 'vts_bar_chart_data.dart';

class VTSBarChartPainter extends AxisChartPainter<VTSBarChartData> {
  VTSBarChartPainter() : super() {
    _barPaint = Paint()..style = PaintingStyle.fill;
    _barStrokePaint = Paint()..style = PaintingStyle.stroke;

    _bgTouchTooltipPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    _borderTouchTooltipPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.transparent
      ..strokeWidth = 1.0;
  }
  late Paint _barPaint;
  late Paint _barStrokePaint;
  late Paint _bgTouchTooltipPaint;
  late Paint _borderTouchTooltipPaint;

  List<GroupBarsPosition>? _groupBarsPosition;

  @override
  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<VTSBarChartData> holder,
  ) {
    super.paint(context, canvasWrapper, holder);
    final data = holder.data;
    final targetData = holder.targetData;

    if (data.barGroups.isEmpty) {
      return;
    }

    final groupsX = data.calculateGroupsX(canvasWrapper.size.width);
    _groupBarsPosition = calculateGroupAndBarsPosition(
      canvasWrapper.size,
      groupsX,
      data.barGroups,
    );

    if (!data.extraLinesData.extraLinesOnTop) {
      super.drawHorizontalLines(
        context,
        canvasWrapper,
        holder,
        canvasWrapper.size,
      );
    }

    drawBars(canvasWrapper, _groupBarsPosition!, holder);

    if (data.extraLinesData.extraLinesOnTop) {
      super.drawHorizontalLines(
        context,
        canvasWrapper,
        holder,
        canvasWrapper.size,
      );
    }

    for (var i = 0; i < targetData.barGroups.length; i++) {
      final barGroup = targetData.barGroups[i];
      for (var j = 0; j < barGroup.barRods.length; j++) {
        if (!barGroup.showingTooltipIndicators.contains(j)) {
          continue;
        }
        final barRod = barGroup.barRods[j];

        drawTouchTooltip(
          context,
          canvasWrapper,
          _groupBarsPosition!,
          targetData.barTouchData.touchTooltipData,
          barGroup,
          i,
          barRod,
          j,
          holder,
        );
      }
    }
  }

  @visibleForTesting
  List<GroupBarsPosition> calculateGroupAndBarsPosition(
    Size viewSize,
    List<double> groupsX,
    List<BarChartGroupData> barGroups,
  ) {
    if (groupsX.length != barGroups.length) {
      throw Exception('');
    }

    final groupBarsPosition = <GroupBarsPosition>[];
    for (var i = 0; i < barGroups.length; i++) {
      final barGroup = barGroups[i];
      final groupX = groupsX[i];

      var tempX = 0.0;
      final barsX = <double>[];
      barGroup.barRods.asMap().forEach((barIndex, barRod) {
        final widthHalf = barRod.width / 2;
        barsX.add(groupX - (barGroup.width / 2) + tempX + widthHalf);
        tempX += barRod.width + barGroup.barsSpace;
      });
      groupBarsPosition.add(GroupBarsPosition(groupX, barsX));
    }
    return groupBarsPosition;
  }

  @visibleForTesting
  void drawBars(
    CanvasWrapper canvasWrapper,
    List<GroupBarsPosition> groupBarsPosition,
    PaintHolder<VTSBarChartData> holder,
  ) {
    final data = holder.data;
    final viewSize = canvasWrapper.size;

    for (var i = 0; i < data.barGroups.length; i++) {
      final barGroup = data.barGroups[i];
      for (var j = 0; j < barGroup.barRods.length; j++) {
        final barRod = barGroup.barRods[j];
        final widthHalf = barRod.width / 2;
        final borderRadius =
            barRod.borderRadius ?? BorderRadius.circular(barRod.width / 2);
        final borderSide = barRod.borderSide;

        final x = groupBarsPosition[i].barsX[j];

        final left = x - widthHalf;
        final right = x + widthHalf;
        final cornerHeight =
            max(borderRadius.topLeft.y, borderRadius.topRight.y) +
                max(borderRadius.bottomLeft.y, borderRadius.bottomRight.y);

        RRect barRRect;
        // draw Main Rod
        if (barRod.toY != barRod.fromY) {
          if (barRod.toY > barRod.fromY) {
            // positive
            final bottom =
                getPixelY(max(data.minY, barRod.fromY), viewSize, holder);
            final top = min(
              getPixelY(barRod.toY, viewSize, holder),
              bottom - cornerHeight,
            );

            barRRect = RRect.fromLTRBAndCorners(
              left,
              top,
              right,
              bottom,
              topLeft: borderRadius.topLeft,
              topRight: borderRadius.topRight,
              bottomLeft: borderRadius.bottomLeft,
              bottomRight: borderRadius.bottomRight,
            );
          } else {
            // negative
            final top =
                getPixelY(min(data.maxY, barRod.fromY), viewSize, holder);
            final bottom = max(
              getPixelY(barRod.toY, viewSize, holder),
              top + cornerHeight,
            );

            barRRect = RRect.fromLTRBAndCorners(
              left,
              top,
              right,
              bottom,
              topLeft: borderRadius.topLeft,
              topRight: borderRadius.topRight,
              bottomLeft: borderRadius.bottomLeft,
              bottomRight: borderRadius.bottomRight,
            );
          }
          _barPaint.setColorOrGradient(
            barRod.color,
            barRRect.getRect(),
          );
          canvasWrapper.drawRRect(barRRect, _barPaint);

          // draw border stroke
          if (borderSide.width > 0 && borderSide.color.opacity > 0) {
            _barStrokePaint
              ..color = borderSide.color
              ..strokeWidth = borderSide.width;
            canvasWrapper.drawRRect(barRRect, _barStrokePaint);
          }
        }
      }
    }
  }

  @visibleForTesting
  void drawTouchTooltip(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    List<GroupBarsPosition> groupPositions,
    BarTouchTooltipData tooltipData,
    BarChartGroupData showOnBarGroup,
    int barGroupIndex,
    BarChartRodData showOnRodData,
    int barRodIndex,
    PaintHolder<VTSBarChartData> holder,
  ) {
    final viewSize = canvasWrapper.size;

    const textsBelowMargin = 4;

    final tooltipItem = tooltipData.getTooltipItem(
      showOnBarGroup,
      barGroupIndex,
      showOnRodData,
      barRodIndex,
    );

    if (tooltipItem == null) {
      return;
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
    )..layout();

    final drawingTextPainter = tp;

    final textWidth = drawingTextPainter.width;
    final textHeight = drawingTextPainter.height + textsBelowMargin;

    final barOffset = Offset(
      groupPositions[barGroupIndex].barsX[barRodIndex],
      getPixelY(showOnRodData.toY, viewSize, holder),
    );

    final tooltipWidth = textWidth + tooltipData.tooltipPadding.horizontal;
    final tooltipHeight = textHeight + tooltipData.tooltipPadding.vertical;

    final zeroY = getPixelY(0, viewSize, holder);
    final barTopY = min(zeroY, barOffset.dy);
    final barBottomY = max(zeroY, barOffset.dy);
    final drawTooltipOnTop = tooltipData.direction == TooltipDirection.top ||
        (tooltipData.direction == TooltipDirection.auto &&
            showOnRodData.isUpward());
    final tooltipTop = drawTooltipOnTop
        ? barTopY - tooltipHeight - tooltipData.tooltipMargin
        : barBottomY + tooltipData.tooltipMargin;

    final tooltipLeft = getTooltipLeft(
      barOffset.dx,
      tooltipWidth,
      tooltipData.tooltipHorizontalAlignment,
    );

    Rect rect = Rect.fromLTWH(
      tooltipLeft,
      tooltipTop,
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
        Utils().calculateRotationOffset(tp.size, rotateAngle);

    final top = tooltipData.tooltipPadding.top;
    final drawOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.topCenter.dy + top - textRotationOffset.dy + rectRotationOffset.dy,
    );

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
          ..drawRRect(roundedRect, _borderTouchTooltipPaint)
          ..drawText(tp, drawOffset);
      },
    );
  }


  BarTouchedSpot? handleTouch(
    Offset localPosition,
    Size viewSize,
    PaintHolder<VTSBarChartData> holder,
  ) {
    final data = holder.data;
    final targetData = holder.targetData;
    final touchedPoint = localPosition;
    if (targetData.barGroups.isEmpty) {
      return null;
    }

    if (_groupBarsPosition == null) {
      final groupsX = data.calculateGroupsX(viewSize.width);
      _groupBarsPosition =
          calculateGroupAndBarsPosition(viewSize, groupsX, data.barGroups);
    }

    /// Find the nearest barRod
    for (var i = 0; i < _groupBarsPosition!.length; i++) {
      final groupBarPos = _groupBarsPosition![i];
      for (var j = 0; j < groupBarPos.barsX.length; j++) {
        final barX = groupBarPos.barsX[j];
        final barWidth = targetData.barGroups[i].barRods[j].width;
        final halfBarWidth = barWidth / 2;

        // final touchExtraThreshold = targetData.barTouchData.touchExtraThreshold;
        final isXInTouchBounds = (touchedPoint.dx <=
                barX + halfBarWidth ) &&
            (touchedPoint.dx >= barX - halfBarWidth );

        if (isXInTouchBounds) {
          final nearestGroup = targetData.barGroups[i];
          final nearestBarRod = nearestGroup.barRods[j];
          final nearestSpot =
              VTSSpot(nearestGroup.x.toDouble(), nearestBarRod.toY);
          final nearestSpotPos =
              Offset(barX, getPixelY(nearestSpot.y, viewSize, holder));

          const touchedStackIndex = -1;

          return BarTouchedSpot(
            nearestGroup,
            i,
            nearestBarRod,
            j,
            touchedStackIndex,
            nearestSpot,
            nearestSpotPos,
          );
        }
      }
    }

    return null;
  }
}

@visibleForTesting
class GroupBarsPosition {
  GroupBarsPosition(this.groupX, this.barsX);
  final double groupX;
  final List<double> barsX;
}
