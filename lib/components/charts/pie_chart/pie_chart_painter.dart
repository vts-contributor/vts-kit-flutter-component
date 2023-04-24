import 'dart:math';

import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';
import 'package:vts_component/common/style/vts_color.dart';

import 'data_item.dart';

class PieChartPainter extends CustomPainter {
  PieChartPainter(
    this.context,
    this.fullAngle, {
    required this.dataset,
    this.chartBackgroundColor,
    required this.chartScale,
    required this.startAngle,
    required this.labelStyle,
    required this.showSeparator,
    required this.separatorWidth,
    required this.showBorder,
    required this.borderWidth,
    required this.isDonut,
    this.donutTitle,
    this.donutSubTitle,
    this.donutTitleStyle,
    this.donutSubTitleStyle,
    this.onSectionClicked,
  });

  final BuildContext context;

  final double fullAngle;
  final List<DataItem> dataset;
  final Color? chartBackgroundColor;
  final double chartScale;
  final double startAngle;
  final TextStyle labelStyle;

  final bool showSeparator;
  final double separatorWidth;
  final bool showBorder;
  final double borderWidth;

  final bool isDonut;
  final String? donutTitle;
  final String? donutSubTitle;
  final TextStyle? donutTitleStyle;
  final TextStyle? donutSubTitleStyle;

  final Function(DataItem)? onSectionClicked;

  void drawBackground(
    Canvas canvas,
    Rect rect,
  ) {
    canvas.drawRect(
      rect,
      Paint()
        ..color = chartBackgroundColor!
        ..style = PaintingStyle.fill,
    );
  }

  void drawBorder(
    Canvas canvas,
    Rect rect,
    double startAngle,
  ) {
    canvas.drawArc(
      rect,
      startAngle,
      fullAngle * pi / 180,
      false,
      Paint()
        ..color = VTSColors.WHITE_1
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }

  void drawSections(
    TouchyCanvas touchableCanvas,
    Rect rect,
    double startAngle,
    double sweepAngle,
    DataItem item,
  ) {
    touchableCanvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      true,
      Paint()
        ..color = item.color
        ..style = PaintingStyle.fill,
      onTapDown: (details) {
        // todo zoom out here
        onSectionClicked!(item);
      },
    );
  }

  void drawSeparators(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
  ) {
    canvas.drawLine(
      center,
      center +
          Offset(
            radius / 2 * cos(startAngle),
            radius / 2 * sin(startAngle),
          ),
      Paint()
        ..color = VTSColors.WHITE_1
        ..style = PaintingStyle.stroke
        ..strokeWidth = separatorWidth,
    );
  }

  void drawLabels(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    DataItem item,
  ) {
    final r = radius * (isDonut ? 0.4 : 0.3);
    drawText(
      canvas,
      center +
          Offset(
            r * cos(startAngle + sweepAngle / 2),
            r * sin(startAngle + sweepAngle / 2),
          ),
      100,
      text: '${(item.percentage! * 100).toStringAsFixed(2)}%',
      style: labelStyle,
    );
  }

  void drawText(
    Canvas canvas,
    Offset position,
    double maxWidth, {
    String? text,
    TextStyle? style,
    String? subText,
    TextStyle? subStyle,
  }) {
    final tp = TextPainter(
      text: subText == null
          ? TextSpan(text: text, style: style)
          : TextSpan(
              children: [
                TextSpan(text: text, style: style),
                TextSpan(text: '\n$subText', style: subStyle),
              ],
            ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      ellipsis: '...',
    );
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    tp.paint(canvas, position + Offset(-tp.width / 2, -tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * chartScale;
    final rect = Rect.fromCenter(center: center, width: radius, height: radius);
    var startAngle = this.startAngle;
    final touchableCanvas = TouchyCanvas(context, canvas);

    if (chartBackgroundColor != null) {
      drawBackground(canvas, rect);
    }

    if (showBorder) {
      drawBorder(canvas, rect, startAngle);
    }

    for (final el in dataset) {
      final sweepAngle = el.percentage! * fullAngle * pi / 180.0;
      // drawSections(canvas, rect, startAngle, sweepAngle, el.color);
      drawSections(touchableCanvas, rect, startAngle, sweepAngle, el);

      if (showSeparator) {
        drawSeparators(canvas, center, radius, startAngle);
      }

      drawLabels(canvas, center, radius, startAngle, sweepAngle, el);
      startAngle += sweepAngle;
    }

    if (isDonut) {
      canvas.drawCircle(
        center,
        radius * 0.3,
        Paint()
          ..color = VTSColors.WHITE_1
          ..style = PaintingStyle.fill,
      );

      drawText(
        canvas,
        center,
        radius * 0.6,
        text: donutTitle,
        style: donutTitleStyle,
        subText: donutSubTitle,
        subStyle: donutSubTitleStyle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
