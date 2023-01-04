// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/vts_component.dart';

class VTSCarouselStyle {
  static const VTS_CAROUSEL_PREFIX = "CAROUSEL";

  Map<dynamic, dynamic> metaContent = {
    VTSCarouselStyle.VTS_CAROUSEL_PREFIX: {
      'default': {
        'indicatorSize': 8.0,
        'activeIndicator': VTSColors.PRIMARY_0,
        'inactiveIndicator': VTSColors.GRAY_4,
        'indicatorMargin': const EdgeInsets.symmetric(horizontal: 8.0),
        'indicatorBottom': 8.0
      },
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
    selector != null
      ? retriveItem([VTSCarouselStyle.VTS_CAROUSEL_PREFIX, key, selector, ...extra]) 
      ?? retriveItem([VTSCarouselStyle.VTS_CAROUSEL_PREFIX, key, selector])
      ?? retriveItem([VTSCarouselStyle.VTS_CAROUSEL_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSCarouselStyle.VTS_CAROUSEL_PREFIX, 'default', key])
      : retriveItem([VTSCarouselStyle.VTS_CAROUSEL_PREFIX, 'default', key, ...extra]) 
      ?? retriveItem([VTSCarouselStyle.VTS_CAROUSEL_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSCarouselStyle.Content.containsKey(key)) {
      return VTSCarouselStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSCarouselStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSCarouselStyle.internal() {
    final instance = VTSCarouselStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSCarouselStyle();
}
