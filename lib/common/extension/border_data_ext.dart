import 'package:flutter/cupertino.dart';

import '../../components/line_chart_and_area_chart/base_chart/base_chart_data.dart';

extension VTSBorderDataExtension on VTSBorderData {
  EdgeInsets get allSidesPadding => EdgeInsets.only(
    left: show ? border.left.width : 0.0,
    top: show ? border.top.width : 0.0,
    right: show ? border.right.width : 0.0,
    bottom: show ? border.bottom.width : 0.0,
  );
}