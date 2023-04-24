import 'package:flutter/cupertino.dart';
import '../axis/axis_chart_scaffold_widget.dart';
import '../base_chart/base_chart_data.dart';
import '../base_chart/vts_touch_event.dart';
import 'vts_bar_chart_data.dart';
import 'vts_bar_chart_leaf.dart';

class VTSBarChart extends ImplicitlyAnimatedWidget {
  const VTSBarChart(
    this.data, {
    super.key,
    Duration swapAnimationDuration = const Duration(milliseconds: 150),
    Curve swapAnimationCurve = Curves.linear,
  }) : super(
          duration: swapAnimationDuration,
          curve: swapAnimationCurve,
        );

  /// Determines how the [VTSBarChart] should be look like.
  final VTSBarChartData data;

  @override
  _VTSBarChartState createState() => _VTSBarChartState();
}

class _VTSBarChartState extends AnimatedWidgetBaseState<VTSBarChart> {
  BarChartDataTween? _barChartDataTween;

  BaseTouchCallback<BarTouchResponse>? _providedTouchCallback;

  final Map<int, List<int>> _showingTouchedTooltips = {};

  @override
  Widget build(BuildContext context) {
    final showingData = _getData();

    return AxisChartScaffoldWidget(
      data: showingData,
      chart: VTSBarChartLeaf(
        data: _withTouchedIndicators(_barChartDataTween!.evaluate(animation)),
        targetData: _withTouchedIndicators(showingData),
      ),
    );
  }

  VTSBarChartData _withTouchedIndicators(VTSBarChartData barChartData) {
    if (!barChartData.barTouchData.enabled ) {
      return barChartData;
    }

    final newGroups = <BarChartGroupData>[];
    for (var i = 0; i < barChartData.barGroups.length; i++) {
      final group = barChartData.barGroups[i];
      newGroups.add(
        group.copyWith(
          showingTooltipIndicators: _showingTouchedTooltips[i],
        ),
      );
    }

    return barChartData.copyWith(
      barGroups: newGroups,
    );
  }

  VTSBarChartData _getData() {
    final barTouchData = widget.data.barTouchData;
    if (barTouchData.enabled ) {
      _providedTouchCallback = barTouchData.touchCallback;
      return widget.data.copyWith(
        barTouchData: widget.data.barTouchData
            .copyWith(touchCallback: _handleBuiltInTouch),
      );
    }
    return widget.data;
  }

  void _handleBuiltInTouch(
    VTSTouchEvent event,
    BarTouchResponse? touchResponse,
  ) {
    if (!mounted) {
      return;
    }
    _providedTouchCallback?.call(event, touchResponse);

    if (!event.isInterestedForInteractions ||
        touchResponse == null ||
        touchResponse.spot == null) {
      setState(_showingTouchedTooltips.clear);
      return;
    }
    setState(() {
      final spot = touchResponse.spot!;
      final groupIndex = spot.touchedBarGroupIndex;
      final rodIndex = spot.touchedRodDataIndex;
      _showingTouchedTooltips.clear();
      _showingTouchedTooltips[groupIndex] = [rodIndex];
    });
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _barChartDataTween = visitor(
      _barChartDataTween,
      widget.data,
      (value) =>
          BarChartDataTween(begin: value as VTSBarChartData, end: widget.data),
    ) as BarChartDataTween?;
  }
}
