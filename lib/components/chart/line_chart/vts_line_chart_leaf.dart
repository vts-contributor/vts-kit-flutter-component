import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/components/chart/base_chart/render_base_chart.dart';

import '../base_chart/base_chart_painter.dart';
import '../canvas_wrapper.dart';
import 'vts_line_chart_data.dart';
import 'vts_line_chart_painter.dart';

class VTSLineChartLeaf extends LeafRenderObjectWidget {
  const VTSLineChartLeaf({Key? key, required this.data, required this.targetData})
      : super(key: key);

  final VTSLineChartData data, targetData;

  @override
  RenderLineChart createRenderObject(BuildContext context) => RenderLineChart(
      context, data, targetData, MediaQuery.of(context).textScaleFactor);

  @override
  void updateRenderObject(BuildContext context, RenderLineChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..buildContext = context;
  }
}

class RenderLineChart extends RenderBaseChart<LineTouchResponse> {
  RenderLineChart(BuildContext context, VTSLineChartData data,
      VTSLineChartData targetData, double textScale)
      : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        super(targetData.lineTouchData, context);

  VTSLineChartData get data => _data;
  VTSLineChartData _data;
  set data(VTSLineChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  VTSLineChartData get targetData => _targetData;
  VTSLineChartData _targetData;
  set targetData(VTSLineChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.lineTouchData);
    markNeedsPaint();
  }

  double get textScale => _textScale;
  double _textScale;
  set textScale(double value) {
    if (_textScale == value) return;
    _textScale = value;
    markNeedsPaint();
  }

  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  VTSLineChartPainter painter = VTSLineChartPainter();

  PaintHolder<VTSLineChartData> get paintHolder => PaintHolder(data, targetData, textScale);

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    painter.paint(
      buildContext,
      CanvasWrapper(canvas, mockTestSize ?? size),
      paintHolder,
    );
    canvas.restore();
  }

  @override
  LineTouchResponse getResponseAtLocation(Offset localPosition) {
    final touchedSpots = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return LineTouchResponse(touchedSpots);
  }
}
