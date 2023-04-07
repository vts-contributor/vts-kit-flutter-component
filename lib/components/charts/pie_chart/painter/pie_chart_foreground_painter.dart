import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';
import 'package:vts_component/vts_component.dart';

class PieChartForegroundPainter extends CustomPainter {
  PieChartForegroundPainter(
    this.context, {
    this.rect,
    this.startAngle,
    this.sweepAngle,
    this.item,
    required this.isDonut,
    this.donutTitle,
    this.donutSubTitle,
    this.donutTitleStyle,
    this.donutSubTitleStyle,
    this.onSectionClicked,
  });

  final BuildContext context;

  final Rect? rect;
  final double? startAngle;
  final double? sweepAngle;
  final VTSPieChartDataItem? item;

  final bool isDonut;
  final String? donutTitle;
  final String? donutSubTitle;
  final TextStyle? donutTitleStyle;
  final TextStyle? donutSubTitleStyle;

  final Function(Rect, double, double, VTSPieChartDataItem)? onSectionClicked;

  void drawSection(
    TouchyCanvas touchableCanvas,
    Rect? rect,
    double? startAngle,
    double? sweepAngle,
    VTSPieChartDataItem? item,
  ) {
    final newRect = Rect.fromCenter(
      center: rect!.center,
      width: rect.width + 50,
      height: rect.height + 50,
    );

    touchableCanvas.drawArc(
      newRect,
      startAngle!,
      sweepAngle!,
      true,
      Paint()
        ..color = item!.color.withOpacity(0.2)
        ..style = PaintingStyle.fill,
      hitTestBehavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        // todo zoom out here
        onSectionClicked!(rect, startAngle, sweepAngle, item);
      },
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
    if (rect == null ||
        startAngle == null ||
        sweepAngle == null ||
        item == null) {
      return;
    }

    final touchableCanvas = TouchyCanvas(context, canvas);

    drawSection(touchableCanvas, rect, startAngle, sweepAngle, item);

    if (isDonut) {
      touchableCanvas.drawCircle(
        rect!.center,
        rect!.width * 0.3,
        Paint()
          ..color = VTSColors.WHITE_1
          ..style = PaintingStyle.fill,
        hitTestBehavior: HitTestBehavior.opaque,
      );

      drawText(
        canvas,
        rect!.center,
        rect!.width * 0.6,
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
