import 'package:equatable/equatable.dart';

import '../list_wrapper.dart';
import 'vts_bar_chart_data.dart';

class VTSBarChartHelper {

  static final Map<ListWrapper<BarChartGroupData>, BarChartMinMaxAxisValues>
      _cachedResults = {};

  static BarChartMinMaxAxisValues calculateMaxAxisValues(
    List<BarChartGroupData> barGroups,
  ) {
    if (barGroups.isEmpty) {
      return BarChartMinMaxAxisValues(0, 0);
    }

    final listWrapper = barGroups.toWrapperClass();

    if (_cachedResults.containsKey(listWrapper)) {
      return _cachedResults[listWrapper]!.copyWith(readFromCache: true);
    }

    final BarChartGroupData barGroup;
    try {
      barGroup = barGroups.firstWhere((element) => element.barRods.isNotEmpty);
    } catch (e) {
      // There is no barChartGroupData with at least one barRod
      return BarChartMinMaxAxisValues(0, 0);
    }

    var maxY = barGroup.barRods[0].toY;
    var minY = 0.0;

    for (var i = 0; i < barGroups.length; i++) {
      final barGroup = barGroups[i];
      for (var j = 0; j < barGroup.barRods.length; j++) {
        final rod = barGroup.barRods[j];

        if (rod.toY > maxY) {
          maxY = rod.toY;
        }


        if (rod.toY < minY) {
          minY = rod.toY;
        }

      }
    }

    final result = BarChartMinMaxAxisValues(minY, maxY);
    _cachedResults[listWrapper] = result;
    return result;
  }
}

/// Holds minY, and maxY for use in [VTSBarChartData]
class BarChartMinMaxAxisValues with EquatableMixin {
  BarChartMinMaxAxisValues(this.minY, this.maxY, {this.readFromCache = false});
  final double minY;
  final double maxY;
  final bool readFromCache;

  @override
  List<Object?> get props => [minY, maxY, readFromCache];

  BarChartMinMaxAxisValues copyWith({
    double? minY,
    double? maxY,
    bool? readFromCache,
  }) => BarChartMinMaxAxisValues(
      minY ?? this.minY,
      maxY ?? this.maxY,
      readFromCache: readFromCache ?? this.readFromCache,
    );
}
