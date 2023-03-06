// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/cupertino.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/vts_component.dart';

class VTSSearchBarStyle {
  static const VTS_SEARCH_BAR_PREFIX = "SEARCH_BAR";

  Map<dynamic, dynamic> metaContent = {
    VTS_SEARCH_BAR_PREFIX: {
      "default": {"borderRadius": VTSCommon.BORDER_RADIUS_STANDARD},
      "background": {
        VTSFieldControlState.DEFAULT: const Color(0xFFF2F2F2),
        VTSFieldControlState.HOVER: VTSColors.WHITE_1,
        VTSFieldControlState.FOCUS: VTSColors.WHITE_1,
      },
      "borderColor": {
        VTSFieldControlState.DEFAULT: VTSColors.TRANSPARENT,
        VTSFieldControlState.HOVER: VTSColors.GRAY_4,
        VTSFieldControlState.FOCUS: VTSColors.GRAY_4
      },
      "boxShadow": {
        VTSFieldControlState.DEFAULT: VTSCommon.CONTROL_BOX_SHADOW_DEFAULT,
        VTSFieldControlState.HOVER: VTSCommon.CONTROL_BOX_SHADOW_HOVER,
        VTSFieldControlState.FOCUS: VTSCommon.CONTROL_BOX_SHADOW_FOCUS,
      },
      "textStyle": {
        VTSFieldControlState.DEFAULT: null,
        VTSFieldControlState.HOVER: null,
        VTSFieldControlState.FOCUS: null,
      }
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
      selector != null
          ? retriveItem([
                VTSSearchBarStyle.VTS_SEARCH_BAR_PREFIX,
                key,
                selector,
                ...extra
              ]) ??
              retriveItem(
                  [VTSSearchBarStyle.VTS_SEARCH_BAR_PREFIX, key, selector])
          : retriveItem([
                VTSSearchBarStyle.VTS_SEARCH_BAR_PREFIX,
                'default',
                key,
                ...extra
              ]) ??
              retriveItem(
                  [VTSSearchBarStyle.VTS_SEARCH_BAR_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSSearchBarStyle.Content.containsKey(key)) {
      return VTSSearchBarStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSSearchBarStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSSearchBarStyle.internal() {
    final instance = VTSSearchBarStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSSearchBarStyle();
}
