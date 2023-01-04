// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/vts_component.dart';

class VTSTabStyle {
  static const VTS_TAB_PREFIX = 'TAB';

  Map<String, dynamic> metaContent = {
    VTS_TAB_PREFIX: {
      'default': {
        'indicatorPadding': EdgeInsets.zero,
        'background': VTSColors.WHITE_1,
        'fontColor': VTSColors.GRAY_2,
        'selectedFontColor': VTSColors.PRIMARY_0,
        'iconFontSize': VTSCommon.ICON_FONT_SIZE_SM,
        'indicatorWeight': 2.0,
        'itemPadding': 10.0,
        'indicatorColor': VTSColors.TRANSPARENT
      },
      VTSTabType.SEGMENT: {
        'height': 32.0,
        'border': Border.all(color: VTSColors.ILUS_GRAY_4, width: 1),
        'borderRadius': BorderRadius.circular(8),
        'background': VTSColors.ILUS_GRAY_4,
        'fontColor': VTSColors.BLACK_1,
        'selectedFontColor': VTSColors.BLACK_1,
        'indicator': BoxDecoration(
          color: VTSColors.WHITE_1,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [VTSCommon.BLUR3_X0_Y1]
        ),
        'indicatorPadding': const EdgeInsets.all(2),
        'labelStyle': VTSCommon.TEXT_STYLE_BODY_1_16,
        'labelPadding': EdgeInsets.zero,
        'itemPadding': 20.0
      },
      VTSTabType.TOPBAR: {
        'height': {
          'single': 48.0,
          'multi': 72.0
        },
        'indicatorColor': {
          'single-icon': VTSColors.TRANSPARENT,
          'single-label': VTSColors.PRIMARY_0,
          'hybrid': VTSColors.PRIMARY_0
        },
        'labelPadding': EdgeInsets.zero,
        'iconMargin': 8.0,
        'labelStyle': const TextStyle(
          fontSize: VTSCommon.FONT_SIZE_SM,
          fontWeight: FontWeight.w600,
          fontFamily: VTSCommon.DEFAULT_FONT_FAMILY
        ),
        'unselectedLabelStyle': const TextStyle(
          fontSize: VTSCommon.FONT_SIZE_SM,
          fontWeight: FontWeight.w500,
          fontFamily: VTSCommon.DEFAULT_FONT_FAMILY
        ),
        'border': const Border(bottom: BorderSide(color: VTSColors.ILUS_GRAY_4, width: 1)),
      },
      VTSTabType.BOTTOMBAR: {
        'height': {
          'single': 50.0,
          'multi': 50.0
        },
        'indicatorColor': {
          'single-icon': VTSColors.TRANSPARENT,
          'single-label': VTSColors.TRANSPARENT,
          'hybrid': VTSColors.TRANSPARENT
        },
        'labelPadding': EdgeInsets.zero,
        'iconFontSize': 18.0,
        'iconMargin': 6.0,
        'labelStyle': const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: VTSCommon.DEFAULT_FONT_FAMILY
        ),
        'unselectedLabelStyle': const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: VTSCommon.DEFAULT_FONT_FAMILY
        ),
        'border': const Border(top: BorderSide(color: VTSColors.TRANSPARENT, width: 1)),
      }
    }
  };

  static dynamic get(String key, VTSTabType type, { List<Object> extra = const [] }) 
    => retriveItem([VTSTabStyle.VTS_TAB_PREFIX, type, key, ...extra])
    ?? retriveItem([VTSTabStyle.VTS_TAB_PREFIX, type, key])
    ?? retriveItem([VTSTabStyle.VTS_TAB_PREFIX, 'default', key, ...extra])
    ?? retriveItem([VTSTabStyle.VTS_TAB_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSTabStyle.Content.containsKey(key)) {
      return VTSTabStyle.Content[key];
    }
    else {
      return null;
    }
  }

  static Map<String, dynamic> Content = VTSTabStyle.internal()._content;
  Map<String, dynamic> _content = {};

  factory VTSTabStyle.internal() {
    final instance = VTSTabStyle();
    final Map<String, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSTabStyle();
}