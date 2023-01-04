// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/components/toggle/index.dart';
import 'package:vts_component/vts_component.dart';

class VTSToggleStyle {
  static const VTS_TOGGLE_PREFIX = "TOGGLE";

  Map<dynamic, dynamic> metaContent = {
    VTS_TOGGLE_PREFIX: {
      "default": {
        "activeThumbColor": VTSColors.WHITE_1,
        "inactiveThumbColor": VTSColors.WHITE_1,
        "activeTrackColor": VTSColors.ILUS_GRAY_2,
        "inactiveTrackColor": VTSColors.ILUS_GRAY_2,
      },
      VTSToggleType.IOS: {
        "borderRadius": BorderRadius.circular(15.5),
        "thumbBorderRadius": BorderRadius.circular(100),
        "trackHeight": 28.0,
        "trackWidth": 53.0,
        "boxShadow": null,
        "thumbPadding": 2.0,
        "disabledTrackColor": VTSColors.GRAY_5,
        "disabledThumbColor": VTSColors.WHITE_1,
      },
      VTSToggleType.MATERIAL: {
        "borderRadius": BorderRadius.circular(34.0),
        "thumbBorderRadius": BorderRadius.circular(100),
        "trackHeight": 14.0,
        "trackWidth": 34.0,
        "boxShadow": const [BoxShadow(blurRadius: 2.0, offset: Offset(0.0, 1.0), color: Color.fromRGBO(48, 79, 254, 0.54))],
        "thumbPadding": -3.0,
        "disabledTrackColor": VTSColors.GRAY_4.withOpacity(0.24),
        "disabledThumbColor": VTSColors.WHITE_1,
      },
      // VTSToggleType.SQUARE: {
      //   "borderRadius": BorderRadius.circular(34.0),
      //   "thumbBorderRadius": BorderRadius.circular(0),
      //   "trackHeight": 14.0,
      //   "trackWidth": 34.0,
      //   "boxShadow": const [BoxShadow(spreadRadius: 2.0, offset: Offset(0.0, 1.0), color: Color.fromRGBO(48, 79, 254, 0.54))],
      //   "thumbPadding": -3.0,
      // },
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, { selector, List<Object> extra = const [] }) 
    => selector != null 
      ? retriveItem([VTSToggleStyle.VTS_TOGGLE_PREFIX, selector, key, ...extra])
      ?? retriveItem([VTSToggleStyle.VTS_TOGGLE_PREFIX, selector, key])
      : retriveItem([VTSToggleStyle.VTS_TOGGLE_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSToggleStyle.VTS_TOGGLE_PREFIX, 'default', key]);


  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSToggleStyle.Content.containsKey(key)) {
      return VTSToggleStyle.Content[key];
    }
    else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSToggleStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSToggleStyle.internal() {
    final instance = VTSToggleStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSToggleStyle();
}