import '../../components/line_chart/axis/axit_chart_data.dart';

extension SideTitlesExtension on AxisTitles {
  double get totalReservedSize {
    var size = 0.0;
    if (showSideTitles) {
      size += sideTitles.reservedSize;
    }
    return size;
  }
}