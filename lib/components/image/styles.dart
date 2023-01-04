// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/vts_component.dart';

class VTSImageStyle {
  static const VTS_IMAGE_PREFIX = "IMAGE";

  Map<dynamic, dynamic> metaContent = {
    VTSImageStyle.VTS_IMAGE_PREFIX: {
      "default": {},
      "borderRadius": {
        VTSImageShape.CIRCLE: VTSCommon.BORDER_RADIUS_CIRCLE,
        VTSImageShape.SQUARE: BorderRadius.zero,
        VTSImageShape.STANDARD: BorderRadius.circular(8),
      }
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
      selector != null
          ? retriveItem([VTSImageStyle.VTS_IMAGE_PREFIX, key, selector, ...extra]) 
          ?? retriveItem([VTSImageStyle.VTS_IMAGE_PREFIX, key, selector])
          : retriveItem([VTSImageStyle.VTS_IMAGE_PREFIX, 'default', key, ...extra]) 
          ?? retriveItem([VTSImageStyle.VTS_IMAGE_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSImageStyle.Content.containsKey(key)) {
      return VTSImageStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSImageStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSImageStyle.internal() {
    final instance = VTSImageStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSImageStyle();
}
