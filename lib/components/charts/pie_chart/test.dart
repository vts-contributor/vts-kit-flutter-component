//Copy this CustomPainter code to the Bottom of the File
import 'package:flutter/material.dart';

class TestCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    // paint0Fill.color = const Color(0xffffffff).withOpacity(1.0);
    // canvas.drawRRect(
    //     RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, size.width, size.height),
    //         bottomRight: const Radius.circular(0),
    //         bottomLeft: const Radius.circular(0),
    //         topLeft: const Radius.circular(0),
    //         topRight: const Radius.circular(0)),
    //     paint0Fill);

    final p1 = Path()
      ..moveTo(size.width * 0.4845795, size.height * 0.09025001)
      ..arcToPoint(
        Offset(size.width * 0.3171886, size.height * 0.2880757),
        radius: Radius.elliptical(
          size.width * 0.1760000,
          size.height * 0.2860000,
        ),
        rotation: 0,
        largeArc: true,
        clockwise: true,
      )
      ..lineTo(size.width * 0.3757880, size.height * 0.3189367)
      ..arcToPoint(
        Offset(size.width * 0.4845921, size.height * 0.1903500),
        radius: Radius.elliptical(
          size.width * 0.1144000,
          size.height * 0.1859000,
        ),
        rotation: 0,
        largeArc: true,
        clockwise: false,
      )
      ..close();

    final p2 = Path()
      ..moveTo(size.width * 0.3172429, size.height * 0.2878037)
      ..arcToPoint(
        Offset(size.width * 0.4843709, size.height * 0.09025028),
        radius: Radius.elliptical(
          size.width * 0.1760000,
          size.height * 0.2860000,
        ),
        rotation: 0,
        largeArc: false,
        clockwise: true,
      )
      ..lineTo(size.width * 0.4844565, size.height * 0.1903502)
      ..arcToPoint(
        Offset(size.width * 0.3758233, size.height * 0.3187599),
        radius: Radius.elliptical(
          size.width * 0.1144000,
          size.height * 0.1859000,
        ),
        rotation: 0,
        largeArc: false,
        clockwise: false,
      )
      ..close();

    // todo: Draw
    canvas.drawPath(
      p1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 /* size.width * 0.001538462 */
        ..color = Colors.white
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawPath(
      p1,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.green,
    );

    canvas.drawPath(
      p2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 /* size.width * 0.001538462 */
        ..color = Colors.white
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawPath(
      p2,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
