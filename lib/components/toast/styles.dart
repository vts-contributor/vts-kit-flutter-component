// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/toast/index.dart';
import 'package:vts_component/vts_component.dart';

class VTSToastStyle {
  static const VTS_TOAST_PREFIX = "TOAST";

  Map<dynamic, dynamic> metaContent = {
    VTS_TOAST_PREFIX: {
      "default": {
        "toastWidthRatio": 0.9,
        "padding": const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        "background": VTSColors.BLACK_1,
        "boxShadow": null,
        "textStyle": VTSCommon.TEXT_STYLE_BODY_1_16,
        "fontColor": VTSColors.WHITE_1,
        "cancelFontColor": VTSColors.PRIMARY_0
      },
      "borderRadius": {
        VTSToastType.STANDARD: BorderRadius.circular(6.0),
        VTSToastType.ROUNDED: VTSCommon.BORDER_RADIUS_PILL,
        VTSToastType.FULL_WIDTH: VTSCommon.BORDER_RADIUS_SQUARE
      },
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, { selector, List<Object> extra = const [] }) 
    => selector != null 
      ? retriveItem([VTSToastStyle.VTS_TOAST_PREFIX, key, selector, ...extra])
      ?? retriveItem([VTSToastStyle.VTS_TOAST_PREFIX, key, selector])
      : retriveItem([VTSToastStyle.VTS_TOAST_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSToastStyle.VTS_TOAST_PREFIX, 'default', key]);


  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSToastStyle.Content.containsKey(key)) {
      return VTSToastStyle.Content[key];
    }
    else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSToastStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSToastStyle.internal() {
    final instance = VTSToastStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSToastStyle();
}