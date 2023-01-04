// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/vts_component.dart';

class VTSTileStyle {
  static const VTS_TILE_PREFIX = "TILE";

  Map<dynamic, dynamic> metaContent = {
    VTSTileStyle.VTS_TILE_PREFIX: {
      'default': {
        'titleTextStyle': const TextStyle(
            fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: VTSColors.BLACK_1),
        'subtitleTextStyle': const TextStyle(
            fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
            color: VTSColors.GRAY_2),
        'descriptionTextStyle': const TextStyle(
            fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
            color: VTSColors.GRAY_2),

        'titlePadding': const EdgeInsets.only(right: 8.0),
        'titleIconSize': VTSCommon.ICON_FONT_SIZE_SM,
        'imageMargin': const EdgeInsets.only(right: 8.0),
        'imageSize': 56.0,
        'descriptionIconSize': VTSCommon.ICON_FONT_SIZE_SM,

        'containerPadding': const EdgeInsets.all(16.0),
        'containerMargin': const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        'containerBorder': Border.all(width: 1.0, color: VTSCommon.BORDER_COLOR_LIGHT),
        'containerBorderRadius': BorderRadius.circular(8.0),
        'containerBackground': VTSColors.WHITE_1,
      },
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
    selector != null
      ? retriveItem([VTSTileStyle.VTS_TILE_PREFIX, key, selector, ...extra]) 
      ?? retriveItem([VTSTileStyle.VTS_TILE_PREFIX, key, selector])
      ?? retriveItem([VTSTileStyle.VTS_TILE_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSTileStyle.VTS_TILE_PREFIX, 'default', key])
      : retriveItem([VTSTileStyle.VTS_TILE_PREFIX, 'default', key, ...extra]) 
      ?? retriveItem([VTSTileStyle.VTS_TILE_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSTileStyle.Content.containsKey(key)) {
      return VTSTileStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSTileStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSTileStyle.internal() {
    final instance = VTSTileStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSTileStyle();
}
