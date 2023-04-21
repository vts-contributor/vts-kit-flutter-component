import 'package:equatable/equatable.dart';

import '../axis/axit_chart_data.dart';
import '../list_wrapper.dart';
import 'vts_line_chart_data.dart';


class VTSLineChartHelper {
  static final Map<ListWrapper<LineChartBarData>, LineChartMinMaxAxisValues>
      _cachedResults = {};

  static LineChartMinMaxAxisValues calculateMaxAxisValues(
    List<LineChartBarData> lineBarsData,
  ) {
    if (lineBarsData.isEmpty) {
      return LineChartMinMaxAxisValues(0, 0, 0, 0);
    }

    final listWrapper = lineBarsData.toWrapperClass();

    if (_cachedResults.containsKey(listWrapper)) {
      return _cachedResults[listWrapper]!.copyWith(readFromCache: true);
    }

    final LineChartBarData lineBarData;
    try {
      lineBarData =
          lineBarsData.firstWhere((element) => element.spots.isNotEmpty);
    } catch (e) {
      return LineChartMinMaxAxisValues(0, 0, 0, 0);
    }

    final VTSSpot firstValidSpot;
    try {
      firstValidSpot =
          lineBarData.spots.firstWhere((element) => element != VTSSpot.nullSpot);
    } catch (e) {
      // There is no valid spot
      return LineChartMinMaxAxisValues(0, 0, 0, 0);
    }

    var minX = firstValidSpot.x;
    var maxX = firstValidSpot.x;
    var minY = firstValidSpot.y;
    var maxY = firstValidSpot.y;

    for (final barData in lineBarsData) {
      if (barData.spots.isEmpty) {
        continue;
      }

      if (barData.mostRightSpot.x > maxX) {
        maxX = barData.mostRightSpot.x;
      }

      if (barData.mostLeftSpot.x < minX) {
        minX = barData.mostLeftSpot.x;
      }

      if (barData.mostTopSpot.y > maxY) {
        maxY = barData.mostTopSpot.y;
      }

      if (barData.mostBottomSpot.y < minY) {
        minY = barData.mostBottomSpot.y;
      }
    }

    final result = LineChartMinMaxAxisValues(minX, maxX, minY, maxY);
    _cachedResults[listWrapper] = result;
    return result;
  }
}

class LineChartMinMaxAxisValues with EquatableMixin {
  LineChartMinMaxAxisValues(
    this.minX,
    this.maxX,
    this.minY,
    this.maxY, {
    this.readFromCache = false,
  });
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final bool readFromCache;

  @override
  List<Object?> get props => [minX, maxX, minY, maxY, readFromCache];

  LineChartMinMaxAxisValues copyWith({
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
    bool? readFromCache,
  }) => LineChartMinMaxAxisValues(
      minX ?? this.minX,
      maxX ?? this.maxX,
      minY ?? this.minY,
      maxY ?? this.maxY,
      readFromCache: readFromCache ?? this.readFromCache,
    );
}
