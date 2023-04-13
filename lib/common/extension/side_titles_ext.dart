import '../../components/line_chart_style_1/axis/axit_chart_data.dart';

extension SideTitlesExtension on AxisTitles {
  double get totalReservedSize {
    var size = 0.0;
    if (showSideTitles) {
      size += sideTitles.reservedSize;
    }
    return size;
  }
}