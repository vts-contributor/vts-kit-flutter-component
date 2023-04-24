import 'package:flutter/cupertino.dart';

import '../base_chart/base_chart_painter.dart';
import '../base_chart/render_base_chart.dart';
import '../canvas_wrapper.dart';
import 'vts_bar_chart_data.dart';
import 'vts_bar_chart_painter.dart';


class VTSBarChartLeaf extends LeafRenderObjectWidget {
  const VTSBarChartLeaf({super.key, required this.data, required this.targetData});

  final VTSBarChartData data;
  final VTSBarChartData targetData;

  @override
  RenderBarChart createRenderObject(BuildContext context) => RenderBarChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaleFactor,
      );

  @override
  void updateRenderObject(BuildContext context, RenderBarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScale = MediaQuery.of(context).textScaleFactor
      ..buildContext = context;
  }
}

class RenderBarChart extends RenderBaseChart<BarTouchResponse> {
  RenderBarChart(
    BuildContext context,
    VTSBarChartData data,
    VTSBarChartData targetData,
    double textScale,
  )   : _data = data,
        _targetData = targetData,
        _textScale = textScale,
        super(targetData.barTouchData, context);

  VTSBarChartData get data => _data;
  VTSBarChartData _data;

  set data(VTSBarChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  VTSBarChartData get targetData => _targetData;
  VTSBarChartData _targetData;

  set targetData(VTSBarChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.barTouchData);
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
  VTSBarChartPainter painter = VTSBarChartPainter();

  PaintHolder<VTSBarChartData> get paintHolder => PaintHolder(data, targetData, textScale);

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    painter.paint(
      buildContext,
      CanvasWrapper(canvas, mockTestSize ?? size),
      paintHolder,
    );
    canvas.restore();
  }

  @override
  BarTouchResponse getResponseAtLocation(Offset localPosition) {
    final touchedSpot = painter.handleTouch(
      localPosition,
      mockTestSize ?? size,
      paintHolder,
    );
    return BarTouchResponse(touchedSpot);
  }
}
