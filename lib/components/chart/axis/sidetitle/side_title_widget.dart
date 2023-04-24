
import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/bar_chart_data_ext.dart';
import 'package:vts_component/common/extension/border_data_ext.dart';
import 'package:vts_component/common/extension/edge_insets_ext.dart';
import 'package:vts_component/common/extension/title_data_ext.dart';
import 'package:vts_component/components/chart/axis/sidetitle/side_title_flex.dart';

import '../../bar_chart/vts_bar_chart_data.dart';
import '../../utils.dart';
import '../axis_chart_helper.dart';
import '../axit_chart_data.dart';


class SideTitlesWidget extends StatelessWidget  {
  const SideTitlesWidget({
    super.key,
    required this.side,
    required this.axisChartData,
    required this.parentSize,
  });
  final AxisSide side;
  final AxisChartData axisChartData;
  final Size parentSize;

  bool get isHorizontal => side == AxisSide.top || side == AxisSide.bottom;

  bool get isVertical => !isHorizontal;

  double get minX => axisChartData.minX;

  double get maxX => axisChartData.maxX;

  double get baselineX => axisChartData.baselineX;

  double get minY => axisChartData.minY;

  double get maxY => axisChartData.maxY;

  double get baselineY => axisChartData.baselineY;

  double get axisMin => isHorizontal ? minX : minY;

  double get axisMax => isHorizontal ? maxX : maxY;

  double get axisBaseLine => isHorizontal ? baselineX : baselineY;

  VTSTitlesData get titlesData => axisChartData.titlesData;

  bool get isLeftOrTop => side == AxisSide.left || side == AxisSide.top;

  bool get isRightOrBottom => side == AxisSide.right || side == AxisSide.bottom;

  AxisTitles get axisTitles {
    switch (side) {
      case AxisSide.left:
        return titlesData.leftTitles;
      case AxisSide.top:
        return titlesData.topTitles;
      case AxisSide.right:
        return titlesData.rightTitles;
      case AxisSide.bottom:
        return titlesData.bottomTitles;
    }
  }

  SideTitles get sideTitles => axisTitles.sideTitles;

  Axis get direction => isHorizontal ? Axis.horizontal : Axis.vertical;

  Axis get counterDirection => isHorizontal ? Axis.vertical : Axis.horizontal;

  Alignment get alignment {
    switch (side) {
      case AxisSide.left:
        return Alignment.centerLeft;
      case AxisSide.top:
        return Alignment.topCenter;
      case AxisSide.right:
        return Alignment.centerRight;
      case AxisSide.bottom:
        return Alignment.bottomCenter;
    }
  }


  EdgeInsets get thisSidePadding {
    final titlesPadding = titlesData.allSidesPadding;
    final borderPadding = axisChartData.borderData.allSidesPadding;
    switch (side) {
      case AxisSide.right:
      case AxisSide.left:
        return titlesPadding.onlyTopBottom + borderPadding.onlyTopBottom;
      case AxisSide.top:
      case AxisSide.bottom:
        return titlesPadding.onlyLeftRight + borderPadding.onlyLeftRight;
    }
  }

  double get thisSidePaddingTotal {
    final borderPadding = axisChartData.borderData.allSidesPadding;
    final titlesPadding = titlesData.allSidesPadding;
    switch (side) {
      case AxisSide.right:
      case AxisSide.left:
        return titlesPadding.vertical + borderPadding.vertical;
      case AxisSide.top:
      case AxisSide.bottom:
        return titlesPadding.horizontal + borderPadding.horizontal;
    }
  }

  List<AxisSideTitleWidgetHolder> makeWidgets(
      double axisViewSize,
      double axisMin,
      double axisMax,
      AxisSide side,
      ) {
    List<AxisSideTitleMetaData> axisPositions;
    final interval = sideTitles.interval ??
        Utils().getEfficientInterval(
          axisViewSize,
          axisMax - axisMin,
        );
    if (isHorizontal && axisChartData is VTSBarChartData) {
      final barChartData = axisChartData as VTSBarChartData;
      if (barChartData.barGroups.isEmpty) {
        return [];
      }
      final xLocations = barChartData.calculateGroupsX(axisViewSize);
      axisPositions = xLocations.asMap().entries.map((e) {
        final index = e.key;
        final xLocation = e.value;
        final xValue = barChartData.barGroups[index].x;
        return AxisSideTitleMetaData(xValue.toDouble(), xLocation);
      }).toList();
    } else {
      final axisValues = AxisChartHelper().iterateThroughAxis(
        min: axisMin,
        max: axisMax,
        baseLine: axisBaseLine,
        interval: interval,
      );
      axisPositions = axisValues.map((axisValue) {
        final axisDiff = axisMax - axisMin;
        var portion = 0.0;
        if (axisDiff > 0) {
          portion = (axisValue - axisMin) / axisDiff;
        }
        if (isVertical) {
          portion = 1 - portion;
        }
        final axisLocation = portion * axisViewSize;
        return AxisSideTitleMetaData(axisValue, axisLocation);
      }).toList();
    }
    return axisPositions.map(
          (metaData) => AxisSideTitleWidgetHolder(
          metaData,
          sideTitles.getTitlesWidget(
            metaData.axisValue,
            TitleMeta(
              min: axisMin,
              max: axisMax,
              appliedInterval: interval,
              sideTitles: sideTitles,
              formattedValue: Utils().formatNumber(metaData.axisValue),
              axisSide: side,
              parentAxisSize: axisViewSize,
              axisPosition: metaData.axisPixelLocation,
            ),
          ),
        ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!axisTitles.showAxisTitles && !axisTitles.showSideTitles) {
      return Container();
    }
    final axisViewSize = isHorizontal ? parentSize.width : parentSize.height;
    return Align(
      alignment: alignment,
      child: Flex(
        direction: counterDirection,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeftOrTop && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
          if (sideTitles.showTitles)
            Container(
              width: isHorizontal ? axisViewSize : sideTitles.reservedSize,
              height: isHorizontal ? sideTitles.reservedSize : axisViewSize,
              margin: thisSidePadding,
              child: SideTitlesFlex(
                direction: direction,
                axisSideMetaData: AxisSideMetaData(
                  axisMin,
                  axisMax,
                  axisViewSize - thisSidePaddingTotal,
                ),
                widgetHolders: makeWidgets(
                  axisViewSize - thisSidePaddingTotal,
                  axisMin,
                  axisMax,
                  side,
                ),
              ),
            ),
          if (isRightOrBottom && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
        ],
      ),
    );
  }
}






class _AxisTitleWidget extends StatelessWidget {
  const _AxisTitleWidget({
    required this.axisTitles,
    required this.side,
    required this.axisViewSize,
  });
  final AxisTitles axisTitles;
  final AxisSide side;
  final double axisViewSize;

  int get axisNameQuarterTurns {
    switch (side) {
      case AxisSide.right:
        return 3;
      case AxisSide.left:
        return 3;
      case AxisSide.top:
        return 0;
      case AxisSide.bottom:
        return 0;
    }
  }

  bool get isHorizontal => side == AxisSide.top || side == AxisSide.bottom;

  @override
  Widget build(BuildContext context) => SizedBox(
      width:  axisViewSize ,
      height:  axisViewSize,
      child: Center(
        child: RotatedBox(
          quarterTurns: axisNameQuarterTurns,
          child: axisTitles.axisNameWidget,
        ),
      ),
    );
}



