// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/base/field_control/typings.dart';
import 'package:vts_component/vts_component.dart';

class VTSSelectStyle {
  static const VTS_SELECT_PREFIX = "SELECT";

  Map<dynamic, dynamic> metaContent = {
    VTS_SELECT_PREFIX: {
      "default": {
      },
      VTSSelectType.DROPDOWN: {
        "dropdownDecoration": const BoxDecoration(
          color: VTSColors.FUNC_RED_2,
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(4.0, 4.0), blurRadius: 10.0)
          ]
        ),
        
        "itemHeight": 48.0,
        "itemBackground": VTSColors.WHITE_1,
        "itemActiveBackground": VTSColors.GRAY_5,
        "itemPadding": const EdgeInsets.symmetric(horizontal: 20.0),
        "itemTextStyle": VTSCommon.TEXT_STYLE_BODY_1_16,
        "itemActiveTextStyle": VTSCommon.TEXT_STYLE_BODY_1_16,

        "emptyLabelTextStyle": VTSCommon.TEXT_STYLE_BODY_1_16
      },
      VTSSelectType.BOTTOMSHEET: {
        "itemHeight": 56.0,
        "itemBackground": VTSColors.WHITE_1,
        "itemActiveBackground": VTSColors.GRAY_5,
        "itemPadding": const EdgeInsets.symmetric(horizontal: 20.0),
        "itemTextStyle": VTSCommon.TEXT_STYLE_BODY_1_16,
        "itemActiveTextStyle": VTSCommon.TEXT_STYLE_BODY_1_16,
        "itemSeperatorColor": VTSColors.ILUS_GRAY_6,

        "emptyLabelTextStyle": VTSCommon.TEXT_STYLE_BODY_1_16,

        "topLabelTextStyle": VTSCommon.TEXT_STYLE_SUBTITLE_1_20,
        "topLabelHeight": 48.0,

        "searchHeight": 60.0,
        "searchPadding": const EdgeInsets.symmetric(horizontal: 16.0),
        "searchBackground": VTSColors.GRAY_5,
        "searchInputBackgrounds": VTSFieldControlStateStyle(
          defaultStyle: VTSColors.WHITE_1,
          hoverStyle: VTSColors.WHITE_1,
          focusStyle: VTSColors.WHITE_1,
        ),
        "searchInputBorderColors": VTSFieldControlStateStyle(
          defaultStyle: VTSColors.TRANSPARENT,
          hoverStyle: VTSColors.TRANSPARENT,
          focusStyle: VTSColors.TRANSPARENT,
        ),
      }
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, { selector, List<Object> extra = const [] }) 
    => selector != null 
      ? retriveItem([VTSSelectStyle.VTS_SELECT_PREFIX, selector, key, ...extra])
      ?? retriveItem([VTSSelectStyle.VTS_SELECT_PREFIX, selector, key])
      : retriveItem([VTSSelectStyle.VTS_SELECT_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSSelectStyle.VTS_SELECT_PREFIX, 'default', key]);


  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSSelectStyle.Content.containsKey(key)) {
      return VTSSelectStyle.Content[key];
    }
    else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSSelectStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSSelectStyle.internal() {
    final instance = VTSSelectStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSSelectStyle();
}