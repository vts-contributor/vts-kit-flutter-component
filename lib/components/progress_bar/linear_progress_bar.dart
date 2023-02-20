import 'package:flutter/material.dart';

import 'progress_bar_model.dart';

class VTSLinearProgressBar extends StatelessWidget {
  const VTSLinearProgressBar({
    Key? key,
    required this.data,
    this.radius = 8,
  }) : super(key: key);

  final VTSProgressBarModel data;
  final double radius;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel(),
          data.label == null
              ? const SizedBox.shrink()
              : const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: LinearProgressIndicator(
              value: data.currentValue / data.maxValue,
              backgroundColor: data.backgroundColor,
              color: data.loadingColor,
              minHeight: data.progressBarSize,
            ),
          ),
          const SizedBox(height: 4),
          _buildMoreInformation(),
        ],
      );

  Widget _buildLabel() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          data.label == null
              ? const SizedBox.shrink()
              : Text(data.label!, style: data.labelStyle),
          Text(
            '${(data.currentValue / data.maxValue * 100).floor()}%',
            style: TextStyle(
                fontSize: data.fontSizePercentage,
                color: data.loadingColor,
                fontWeight: FontWeight.w700),
          ),
        ],
      );

  Widget _buildMoreInformation() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${data.currentValue.round()}${data.unit} of ${data.maxValue.round()}${data.unit}',
            style: data.unitTextStyle,
          ),
          data.speedRate == null
              ? const SizedBox.shrink()
              : Text('${data.speedRate}${data.unit}/sec',
                  style: data.unitTextStyle),
        ],
      );
}
