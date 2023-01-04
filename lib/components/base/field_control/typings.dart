import 'package:flutter/cupertino.dart';

enum VTSFieldControlSize {SM, MD}

enum VTSFieldControlState {DEFAULT, DISABLE, HOVER, FOCUS, ERROR}

class VTSFieldControlActionIconItem {
  VTSFieldControlActionIconItem({
    required this.icon,
    required this.onTap
  });

  final Icon icon;
  final Function() onTap;
}

class VTSFieldControlStateStyle<T> {
  VTSFieldControlStateStyle({
    T? defaultStyle,
    T? hoverStyle,
    T? focusStyle,
    T? errorStyle,
    T? disableStyle,
  }){
    styles = {
      VTSFieldControlState.DEFAULT: defaultStyle,
      VTSFieldControlState.HOVER: hoverStyle,
      VTSFieldControlState.FOCUS: focusStyle,
      VTSFieldControlState.ERROR: errorStyle,
      VTSFieldControlState.DISABLE: disableStyle,
    };
  }

  late Map<VTSFieldControlState, T?> styles;

  T? getStyle(VTSFieldControlState state) => styles[state];
}