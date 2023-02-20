import 'package:flutter/material.dart';

import 'progress_bar_model.dart';

class VTSCircularProgressBar extends StatelessWidget {
  const VTSCircularProgressBar({
    Key? key,
    required this.data,
  }) : super(key: key);

  final VTSProgressBarModel data;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // label
          data.label == null
              ? const SizedBox.shrink()
              : Text(data.label!, style: data.labelStyle),
          data.label == null
              ? const SizedBox.shrink()
              : const SizedBox(height: 12),
          // circular progress bar with percentage
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                width: data.size,
                height: data.size,
                child: CircularProgressIndicator(
                  value: data.currentValue / data.maxValue,
                  backgroundColor: data.backgroundColor,
                  color: data.loadingColor,
                  strokeWidth: data.progressBarSize,
                ),
              ),
              Text(
                '${(data.currentValue / data.maxValue * 100).floor()}%',
                style: TextStyle(
                    fontSize: data.fontSizePercentage,
                    color: data.loadingColor,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // more information
          Text(
            '${data.currentValue.round()}${data.unit} of ${data.maxValue.round()}${data.unit}',
            style: data.unitTextStyle,
          ),
          data.speedRate == null
              ? const SizedBox.shrink()
              : Text(
                  '${data.speedRate}${data.unit}/sec',
                  style: data.unitTextStyle,
                ),
        ],
      );
}
