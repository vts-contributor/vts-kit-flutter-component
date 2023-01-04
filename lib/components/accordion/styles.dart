// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/vts_component.dart';

class VTSAccordionStyle {
  static const VTS_ACCORDION_PREFIX = "ACCORDION";

  Map<dynamic, dynamic> metaContent = {
    VTS_ACCORDION_PREFIX: {
      "default": {
        "margin": EdgeInsets.zero,

        "expandedTitleBackground": VTSColors.WHITE_1,
        "collapsedTitleBackground": VTSColors.WHITE_1,
        "titleBorder": Border.all(color: VTSCommon.BORDER_COLOR, width: 1),
        "titleBorderRadius": BorderRadius.zero,
        "titlePadding": const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        "expandedTitleTextStyle": VTSCommon.TEXT_STYLE_SUBTITLE_2_16,
        "collapsedTitleTextStyle": VTSCommon.TEXT_STYLE_SUBTITLE_2_16,

        "contentBackground": VTSColors.WHITE_1,
        "contentPadding": const EdgeInsets.all(16.0),
        "contentBorder": Border.all(color: VTSColors.GRAY_5, width: 1),
        "contentBorderRadius": BorderRadius.zero,
        "contentTextStyle": VTSCommon.TEXT_STYLE_BODY_1_16,

        "toggleIconSize": VTSCommon.ICON_FONT_SIZE_SM,
        "toggleColor": VTSColors.GRAY_2,
        "toggleTextStyle": VTSCommon.TEXT_STYLE_BODY_2_14,

        "collaspedToggle": const Icon(Icons.keyboard_arrow_down),
        "expandedToggle": const Icon(Icons.keyboard_arrow_up),
      }
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, { selector, List<Object> extra = const [] }) 
    => selector != null 
      ? retriveItem([VTSAccordionStyle.VTS_ACCORDION_PREFIX, key, selector, ...extra])
      ?? retriveItem([VTSAccordionStyle.VTS_ACCORDION_PREFIX, key, selector])
      : retriveItem([VTSAccordionStyle.VTS_ACCORDION_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSAccordionStyle.VTS_ACCORDION_PREFIX, 'default', key]);


  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSAccordionStyle.Content.containsKey(key)) {
      return VTSAccordionStyle.Content[key];
    }
    else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSAccordionStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSAccordionStyle.internal() {
    final instance = VTSAccordionStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSAccordionStyle();
}