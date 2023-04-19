import '../../components/line_chart/axis/axit_chart_data.dart';

extension VTSSpotListExtension on List<VTSSpot> {
  /// Splits a line by [VTSSpot.nullSpot] values inside it.
  List<List<VTSSpot>> splitByNullSpots() {
    final barList = <List<VTSSpot>>[[]];

    // handle nullability by splitting off the list into multiple
    // separate lists when separated by nulls
    for (final spot in this) {
      if (spot.isNotNull()) {
        barList.last.add(spot);
      } else if (barList.last.isNotEmpty) {
        barList.add([]);
      }
    }
    // remove last item if one or more last spots were null
    if (barList.last.isEmpty) {
      barList.removeLast();
    }
    return barList;
  }
}