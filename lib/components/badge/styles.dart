// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/vts_component.dart';

class VTSBadgeStyle {
  static const VTS_BADGE_PREFIX = "BADGE";

  Map<dynamic, dynamic> metaContent = {
    VTS_BADGE_PREFIX: {
      "default": {
        "primaryColor": VTSColors.PRIMARY_1,
        "secondaryColor": VTSColors.WHITE_1,
      },
      "padding": {
        VTSBadgeShape.PILL: const EdgeInsets.symmetric(horizontal: 10),
        VTSBadgeShape.CIRCLE: const EdgeInsets.symmetric(horizontal: 1),
        VTSBadgeShape.STANDARD: const EdgeInsets.symmetric(horizontal: 10),
        VTSBadgeShape.SQUARE: const EdgeInsets.symmetric(horizontal: 1)
      },
      "height": {
        VTSBadgeSize.SM: 24.0,
        VTSBadgeSize.MD: 32.0,
      },
      "borderRadius": {
        VTSBadgeShape.CIRCLE: VTSCommon.BORDER_RADIUS_CIRCLE,
        VTSBadgeShape.SQUARE: VTSCommon.BORDER_RADIUS_STANDARD,
        VTSBadgeShape.STANDARD: VTSCommon.BORDER_RADIUS_STANDARD,
        VTSBadgeShape.PILL: VTSCommon.BORDER_RADIUS_PILL,
      },
      "fontSize": {
        VTSBadgeSize.SM: VTSCommon.FONT_SIZE_XS,
        VTSBadgeSize.MD: VTSCommon.FONT_SIZE_SM,
      },
      "LTRB": {
        VTSBadgePosition.TOP_RIGHT: VTSCommon.LTRB_TOP_RIGHT,
        VTSBadgePosition.TOP_LEFT: VTSCommon.LTRB_TOP_LEFT,
        VTSBadgePosition.BOTTOM_LEFT: VTSCommon.LTRB_BOTTOM_LEFT,
        VTSBadgePosition.BOTTOM_RIGHT: VTSCommon.LTRB_BOTTOM_RIGHT,
      },
      "translation": {
        VTSBadgePosition.TOP_RIGHT: VTSCommon.TRANSLATION_TOP_RIGHT,
        VTSBadgePosition.TOP_LEFT: VTSCommon.TRANSLATION_TOP_LEFT,
        VTSBadgePosition.BOTTOM_LEFT: VTSCommon.TRANSLATION_BOTTOM_LEFT,
        VTSBadgePosition.BOTTOM_RIGHT: VTSCommon.TRANSLATION_BOTTOM_RIGHT
      }
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, { selector, List<Object> extra = const [] }) 
    => selector != null 
      ? retriveItem([VTSBadgeStyle.VTS_BADGE_PREFIX, key, selector, ...extra])
      ?? retriveItem([VTSBadgeStyle.VTS_BADGE_PREFIX, key, selector])
      : retriveItem([VTSBadgeStyle.VTS_BADGE_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSBadgeStyle.VTS_BADGE_PREFIX, 'default', key]);


  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSBadgeStyle.Content.containsKey(key)) {
      return VTSBadgeStyle.Content[key];
    }
    else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSBadgeStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSBadgeStyle.internal() {
    final instance = VTSBadgeStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSBadgeStyle();
}