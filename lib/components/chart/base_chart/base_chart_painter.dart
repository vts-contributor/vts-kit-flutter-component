import 'package:flutter/material.dart';

import '../canvas_wrapper.dart';
import 'base_chart_data.dart';

class BaseChartPainter<D extends BaseChartData> {
  BaseChartPainter();

  void paint(
    BuildContext context,
    CanvasWrapper canvasWrapper,
    PaintHolder<D> holder,
  ) {}
}

class PaintHolder<Data extends BaseChartData> {
  PaintHolder(this.data, this.targetData, this.textScale);

  final Data data;

  final Data targetData;

  final double textScale;
}
