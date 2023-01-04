import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vts_component/components/toggle/index.dart';
import 'package:vts_component/components/toggle/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSToggle extends StatefulWidget {
  const VTSToggle(
      {Key? key,
      required this.onChanged,
      required this.value,
      this.activeThumbColor,
      this.activeTrackColor,
      this.inactiveTrackColor,
      this.inactiveThumbColor,
      this.disabledTrackColor,
      this.disabledThumbColor,
      this.vtsType = VTSToggleType.IOS,
      this.animationDuration = const Duration(milliseconds: 100),
      this.enabled = true
    }) : super(key: key);

  /// Thumb's color on active
  final Color? activeThumbColor;

  /// Thumb's color on inactive
  final Color? inactiveThumbColor;

  /// Thumb's color on disabled
  final Color? disabledThumbColor;

  /// Track's color on active
  final Color? activeTrackColor;

  /// Track's color on inactive
  final Color? inactiveTrackColor;

  /// Track's color on disabled
  final Color? disabledTrackColor;

  /// Toggle animation duration
  final Duration animationDuration;

  /// Toggle type of [VTSToggleType] i.e, ios, material
  final VTSToggleType? vtsType;

  /// Toggle's current value
  final bool value;

  /// Trigger on active change
  final ValueChanged<bool?> onChanged;

  /// Toggle's disable status
  final bool enabled;

  @override
  _VTSToggleState createState() => _VTSToggleState();
}

class _VTSToggleState extends State<VTSToggle> with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  late AnimationController controller;
  late Animation<Offset> offset;
  late bool isOn;

  late double containerWidth;
  late double containerHeight;
  late double trackHeight;
  late double trackWidth;
  late double offsetRatio;
  late double thumbSize;
  late double thumbPadding;

  @override
  void initState() {
    calculateSize();
    isOn = widget.value;
    controller = AnimationController(duration: widget.animationDuration, vsync: this);
    offset = (isOn
            ? Tween<Offset>(
                begin: Offset(offsetRatio, 0),
                end: Offset.zero,
              )
            : Tween<Offset>(
                begin: Offset.zero,
                end: Offset(offsetRatio, 0),
              ))
        .animate(controller);
    super.initState();
  }

  @override
  void didUpdateWidget(VTSToggle oldWidget) {
    calculateSize();
    controller = AnimationController(duration: widget.animationDuration, vsync: this);
    offset = (isOn
        ? Tween<Offset>(
            begin: Offset(offsetRatio, 0),
            end: Offset.zero,
          )
        : Tween<Offset>(
            begin: Offset.zero,
            end: Offset(offsetRatio, 0),
          ))
    .animate(controller);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController?.dispose();

    controller.dispose();
    super.dispose();
  }

  void onStatusChange() {
    setState(() {
      isOn = !isOn;
    });
    switch (controller.status) {
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      case AnimationStatus.completed:
        controller.reverse();
        break;
      default:
    }
    widget.onChanged(isOn);
  }

  void calculateSize() {
    trackWidth = VTSToggleStyle.get('trackWidth', selector: widget.vtsType);
    trackHeight = VTSToggleStyle.get('trackHeight', selector: widget.vtsType);
    thumbPadding = VTSToggleStyle.get('thumbPadding', selector: widget.vtsType);
    thumbSize = trackHeight - thumbPadding * 2;
    containerHeight = max(trackHeight, thumbSize);
    

    if (widget.vtsType == VTSToggleType.IOS) {
      containerWidth = max(trackWidth, trackWidth - thumbPadding * 2);
      offsetRatio = (containerWidth - thumbSize - thumbPadding * 2) / thumbSize;
    }

    if (widget.vtsType == VTSToggleType.MATERIAL) {
      containerWidth = max(trackWidth, trackWidth - thumbPadding * 2);
      offsetRatio = (containerWidth - thumbSize) / thumbSize;
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: containerHeight,
            width: containerWidth,
          ),
          Positioned(
            child: InkWell(
              focusColor: VTSColors.TRANSPARENT,
              highlightColor: VTSColors.TRANSPARENT,
              splashColor: VTSColors.TRANSPARENT,
              hoverColor: VTSColors.TRANSPARENT,
              onTap: widget.enabled ? onStatusChange : null,
              child: Container(
                height: trackHeight,
                width: trackWidth,
                decoration: BoxDecoration(
                  color: 
                    !widget.enabled 
                    ? widget.disabledTrackColor ?? VTSToggleStyle.get('disabledTrackColor', selector: widget.vtsType)
                    : isOn
                      ? widget.activeTrackColor ?? VTSToggleStyle.get('activeTrackColor')
                      : widget.inactiveTrackColor ?? VTSToggleStyle.get('inactiveTrackColor'),
                  borderRadius: VTSToggleStyle.get('borderRadius', selector: widget.vtsType),
                ),
              )
            ),
          ),
          Positioned(
            left: (containerWidth - trackWidth) / 2 + thumbPadding,            
            child: InkWell(
              focusColor: VTSColors.TRANSPARENT,
              highlightColor: VTSColors.TRANSPARENT,
              splashColor: VTSColors.TRANSPARENT,
              hoverColor: VTSColors.TRANSPARENT,
              onTap: widget.enabled ? onStatusChange : null,
              child: SlideTransition(
                position: offset,
                child: Container(
                  height: thumbSize,
                  width: thumbSize,
                  decoration: BoxDecoration(
                    borderRadius: VTSToggleStyle.get('thumbBorderRadius', selector: widget.vtsType),
                    color: 
                      !widget.enabled 
                      ? widget.disabledThumbColor ?? VTSToggleStyle.get('disabledThumbColor', selector: widget.vtsType)
                      : isOn
                        ? widget.activeThumbColor ?? VTSToggleStyle.get('activeThumbColor')
                        : widget.inactiveThumbColor ?? VTSToggleStyle.get('inactiveThumbColor'),
                    boxShadow: VTSToggleStyle.get('boxShadow', selector: widget.vtsType),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
