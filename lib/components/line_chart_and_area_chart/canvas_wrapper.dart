import 'dart:ui';
import 'package:flutter/cupertino.dart' hide Image;
import 'package:vts_component/common/extension/dash_path_ext.dart';
import 'package:vts_component/components/line_chart_and_area_chart/utils.dart';

import 'axis/axit_chart_data.dart';
import 'line_chart/vts_line_chart_data.dart';

typedef DrawCallback = void Function();

class CanvasWrapper {
  CanvasWrapper(
    this.canvas,
    this.size,
  );
  final Canvas canvas;
  final Size size;

  void drawRRect(RRect rrect, Paint paint) => canvas.drawRRect(rrect, paint);

  void save() => canvas.save();

  void restore() => canvas.restore();

  void clipRect(
    Rect rect, {
    ClipOp clipOp = ClipOp.intersect,
    bool doAntiAlias = true,
  }) =>
      canvas.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);

  void translate(double dx, double dy) => canvas.translate(dx, dy);

  void rotate(double radius) => canvas.rotate(radius);

  void drawPath(Path path, Paint paint) => canvas.drawPath(path, paint);

  void saveLayer(Rect bounds, Paint paint) => canvas.saveLayer(bounds, paint);

  void drawPicture(Picture picture) => canvas.drawPicture(picture);

  void drawImage(Image image, Offset offset, Paint paint) =>
      canvas.drawImage(image, offset, paint);

  void drawRect(Rect rect, Paint paint) => canvas.drawRect(rect, paint);


  void drawText(TextPainter tp, Offset offset, [double? rotateAngle]) {
    if (rotateAngle == null) {
      tp.paint(canvas, offset);
    } else {
      drawRotated(
        size: tp.size,
        drawOffset: offset,
        angle: rotateAngle,
        drawCallback: () {
          tp.paint(canvas, offset);
        },
      );
    }
  }


  void drawDot(VTSDotPainter painter, VTSSpot spot, Offset offset) {
    painter.draw(canvas, spot, offset);
  }

  void drawRotated({
    required Size size,
    Offset rotationOffset = Offset.zero,
    Offset drawOffset = Offset.zero,
    required double angle,
    required DrawCallback drawCallback,
  }) {
    save();
    translate(
      rotationOffset.dx + drawOffset.dx + size.width / 2,
      rotationOffset.dy + drawOffset.dy + size.height / 2,
    );
    rotate(Utils().radians(angle));
    translate(
      -drawOffset.dx - size.width / 2,
      -drawOffset.dy - size.height / 2,
    );
    drawCallback();
    restore();
  }

  void drawDashedLine(
    Offset from,
    Offset to,
    Paint painter,
    List<int>? dashArray,
  ) {
    var path = Path()
      ..moveTo(from.dx, from.dy)
      ..lineTo(to.dx, to.dy);
    path = path.toDashedPath(dashArray);
    drawPath(path, painter);
  }
}


