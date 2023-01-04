// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/components/avatar/index.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/vts_component.dart';

class VTSAvatarStyle {
  static const VTS_AVATAR_PREFIX = "AVATAR";

  Map<dynamic, dynamic> metaContent = {
    VTSAvatarStyle.VTS_AVATAR_PREFIX: {
      "default": {},
      "borderRadius": {
        VTSAvatarShape.CIRCLE: VTSCommon.BORDER_RADIUS_CIRCLE,
        VTSAvatarShape.SQUARE: BorderRadius.zero,
        VTSAvatarShape.STANDARD: BorderRadius.circular(6),
      },
      "size": {
        VTSAvatarSize.SM: 56.0,
        VTSAvatarSize.MD: 72.0,
        VTSAvatarSize.LG: 96.0,
        VTSAvatarSize.XL: 128.0,
        VTSAvatarSize.XXL: 164.0,
      }
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
      selector != null
          ? retriveItem([VTSAvatarStyle.VTS_AVATAR_PREFIX, key, selector, ...extra]) 
          ?? retriveItem([VTSAvatarStyle.VTS_AVATAR_PREFIX, key, selector])
          : retriveItem([VTSAvatarStyle.VTS_AVATAR_PREFIX, 'default', key, ...extra]) 
          ?? retriveItem([VTSAvatarStyle.VTS_AVATAR_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSAvatarStyle.Content.containsKey(key)) {
      return VTSAvatarStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSAvatarStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSAvatarStyle.internal() {
    final instance = VTSAvatarStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSAvatarStyle();
}
