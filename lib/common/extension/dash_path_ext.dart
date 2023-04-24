import 'dart:ui';

import '../../components/chart/dash_path.dart';

/// Defines extensions on the [Path]
extension DashedPath on Path {
  Path toDashedPath(List<int>? dashArray) {
    if (dashArray != null) {
      final castedArray = dashArray.map((value) => value.toDouble()).toList();
      final dashedPath =
      dashPath(this, dashArray: CircularIntervalList<double>(castedArray));

      return dashedPath;
    } else {
      return this;
    }
  }
}