import 'package:flutter/cupertino.dart';
import 'package:vts_component/common/extension/side_titles_ext.dart';
import '../../components/line_chart_and_area_chart/axis/axit_chart_data.dart';

extension VTSTitlesDataExtension on VTSTitlesData {
  EdgeInsets get allSidesPadding => EdgeInsets.only(
    left: show ? leftTitles.totalReservedSize : 0.0,
    top: show ? topTitles.totalReservedSize : 0.0,
    right: show ? rightTitles.totalReservedSize : 0.0,
    bottom: show ? bottomTitles.totalReservedSize : 0.0,
  );
}