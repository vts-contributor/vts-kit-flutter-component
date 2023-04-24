import '../../components/chart/axis/axit_chart_data.dart';

extension VTSSpotListExtension on List<VTSSpot> {
  /// Splits a line by [VTSSpot.nullSpot] values inside it.
  List<List<VTSSpot>> splitByNullSpots() {
    final barList = <List<VTSSpot>>[[]];

    for (final spot in this) {
      if (spot.isNotNull()) {
        barList.last.add(spot);
      } else if (barList.last.isNotEmpty) {
        barList.add([]);
      }
    }
    if (barList.last.isEmpty) {
      barList.removeLast();
    }
    return barList;
  }
}