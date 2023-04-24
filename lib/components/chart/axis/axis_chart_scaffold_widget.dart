import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/title_data_ext.dart';
import 'package:vts_component/components/chart/axis/sidetitle/side_title_widget.dart';

import 'axit_chart_data.dart';


class AxisChartScaffoldWidget extends StatelessWidget {
  const AxisChartScaffoldWidget({
    super.key,
    required this.chart,
    required this.data,
  });
  final Widget chart;
  final AxisChartData data;

  bool get showLeftTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.leftTitles.showAxisTitles;
    final showSideTitles = data.titlesData.leftTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showRightTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.rightTitles.showAxisTitles;
    final showSideTitles = data.titlesData.rightTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showTopTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.topTitles.showAxisTitles;
    final showSideTitles = data.titlesData.topTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  bool get showBottomTitles {
    if (!data.titlesData.show) {
      return false;
    }
    final showAxisTitles = data.titlesData.bottomTitles.showAxisTitles;
    final showSideTitles = data.titlesData.bottomTitles.showSideTitles;
    return showAxisTitles || showSideTitles;
  }

  List<Widget> stackWidgets(BoxConstraints constraints) {
    final widgets = <Widget>[
      Container(
        margin: data.titlesData.allSidesPadding,
        decoration: BoxDecoration(
          border: data.borderData.isVisible() ? data.borderData.border : null,
        ),
        child: chart,
      )
    ];


    if (showLeftTitles) {
      widgets.insert(
        0,
        SideTitlesWidget(
          side: AxisSide.left,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showTopTitles) {
      widgets.insert(
        0,
        SideTitlesWidget(
          side: AxisSide.top,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showRightTitles) {
      widgets.insert(
        0,
        SideTitlesWidget(
          side: AxisSide.right,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }

    if (showBottomTitles) {
      widgets.insert(
        0,
        SideTitlesWidget(
          side: AxisSide.bottom,
          axisChartData: data,
          parentSize: constraints.biggest,
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Stack(children: stackWidgets(constraints)),
    );
}




