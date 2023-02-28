// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/vts_component.dart';

class VTSCardStyle {
  static const VTS_CARD_PREFIX = "CARD";

  Map<dynamic, dynamic> metaContent = {
    VTSCardStyle.VTS_CARD_PREFIX: {
      'default': {
        'titleTextStyle': VTSCommon.TEXT_STYLE_SUBTITLE_1_20,
        'subtitleTextStyle': VTSCommon.TEXT_STYLE_BODY_1_16.merge(const TextStyle(color: VTSColors.GRAY_2)),
        'bodyTextStyle': VTSCommon.TEXT_STYLE_BODY_1_16,

        'containerPadding': const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        'containerMargin': const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        'containerBorder': Border.all(width: 1.0, color: VTSCommon.BORDER_COLOR_LIGHT),
        'containerBorderRadius': BorderRadius.circular(8.0),
        'containerBackground': VTSColors.WHITE_1,

        'headerPadding': const EdgeInsets.all(0.0),

        'bodyPadding': const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
        'avatarMargin': const EdgeInsets.only(right: 8.0),
        
        // Avatar Type
        'avatarSize': 56.0,

        // Full_Image Type
        'imageFlexPercent': 33.33333,
        'imageMargin': const EdgeInsets.only(right: 16.0),

        'footerActionPadding': const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        'footerButtonPadding': const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
        'footerMinHeight': 16.0,

        'anchorTop': 16.0,
        'anchorRight': 16.0,
      },
      
      'containerPadding': {
        VTSCardType.FULL_IMAGE: const EdgeInsets.only(right: 8.0)
      },
      'headerPadding': {
        VTSCardType.FULL_IMAGE: const EdgeInsets.only(top: 16.0)
      },
      'bodyPadding': {
        VTSCardType.FULL_IMAGE: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 20.0)
      },
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
    selector != null
      ? retriveItem([VTSCardStyle.VTS_CARD_PREFIX, key, selector, ...extra]) 
      ?? retriveItem([VTSCardStyle.VTS_CARD_PREFIX, key, selector])
      ?? retriveItem([VTSCardStyle.VTS_CARD_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSCardStyle.VTS_CARD_PREFIX, 'default', key])
      : retriveItem([VTSCardStyle.VTS_CARD_PREFIX, 'default', key, ...extra]) 
      ?? retriveItem([VTSCardStyle.VTS_CARD_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSCardStyle.Content.containsKey(key)) {
      return VTSCardStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSCardStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSCardStyle.internal() {
    final instance = VTSCardStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSCardStyle();
}
