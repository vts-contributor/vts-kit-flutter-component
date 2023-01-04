// ignore_for_file: avoid_positional_boolean_parameters, prefer_int_literals, sort_constructors_first, prefer_final_locals, sort_unnamed_constructors_first

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/button/typings.dart';

class VTSButtonStyle {
  static const VTS_BUTTON_PREFIX = 'BUTTON';

  Map<String, dynamic> metaContent = {
    VTS_BUTTON_PREFIX: {
      'default': {
        'height': {
          VTSButtonSize.SM: 48.0,
          VTSButtonSize.MD: 52.0,
        },
        'padding': {
          VTSButtonShape.CIRCLE: const EdgeInsets.all(0),  
          withIconSelector: {
            VTSButtonSize.SM: const EdgeInsets.only(left: 16.0, right: 16.0),
            VTSButtonSize.MD: const EdgeInsets.only(left: 16.0, right: 16.0)
          },
          withoutIconSelector: {
            VTSButtonSize.SM: const EdgeInsets.only(left: 24.0, right: 24.0),
            VTSButtonSize.MD: const EdgeInsets.only(left: 32.0, right: 32.0)
          }
        },
        'iconFontSize': {
          VTSButtonSize.SM: VTSCommon.FONT_SIZE_MD,
          VTSButtonSize.MD: VTSCommon.FONT_SIZE_MD,
          VTSButtonSize.LG: VTSCommon.FONT_SIZE_MD,
        },
        'textDecoration': {
          VTSButtonType.LINK: {
            VTSButtonState.DEFAULT: VTSCommon.TEXT_STYLE_LINK_TEXT.decoration,
            VTSButtonState.HOVER: TextDecoration.underline,
            VTSButtonState.FOCUS: null,
            VTSButtonState.ACTIVE: TextDecoration.underline,
            VTSButtonState.DISABLE: null
          },
        },
        'color': {
          VTSButtonType.PRIMARY: {
            VTSButtonState.DEFAULT: {
              'background': VTSColors.PRIMARY_1,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_1
            },
            VTSButtonState.HOVER: {
              'background': VTSColors.PRIMARY_2,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_2,
            },
            VTSButtonState.FOCUS: {
              'background': VTSColors.PRIMARY_0,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_0,
            },
            VTSButtonState.ACTIVE: {
              'background': VTSColors.PRIMARY_6,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_6,
            },
            VTSButtonState.DISABLE: {
              'background': VTSColors.GRAY_5,
              'fontColor': VTSColors.GRAY_3,
              'borderColor': VTSColors.GRAY_5,
            },
          },
          VTSButtonType.SECONDARY: {
            VTSButtonState.DEFAULT: {
              'background': VTSColors.WHITE_1,
              'fontColor': VTSColors.PRIMARY_1,
              'borderColor': VTSColors.PRIMARY_1,
            },
            VTSButtonState.HOVER: {
              'background': VTSColors.FUNC_RED_6,
              'fontColor': VTSColors.PRIMARY_1,
              'borderColor': VTSColors.PRIMARY_1,
            },
            VTSButtonState.FOCUS: {
              'background': VTSColors.FUNC_RED_6,
              'fontColor': VTSColors.PRIMARY_0,
              'borderColor': VTSColors.PRIMARY_0,
            },
            VTSButtonState.ACTIVE: {
              'background': VTSColors.FUNC_RED_6,
              'fontColor': VTSColors.FUNC_RED_2,
              'borderColor': VTSColors.FUNC_RED_2,
            },
            VTSButtonState.DISABLE: {
              'background': VTSColors.WHITE_1,
              'fontColor': VTSColors.GRAY_3,
              'borderColor': VTSColors.GRAY_5,
            },
          },
          VTSButtonType.LINK: {
              VTSButtonState.DEFAULT: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSCommon.TEXT_STYLE_LINK_TEXT.color,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.HOVER: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.PRIMARY_6,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.FOCUS: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.PRIMARY_1,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.ACTIVE: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.BLACK_1,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.DISABLE: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.GRAY_2,
              'borderColor': VTSColors.TRANSPARENT,
            },
          },
          VTSButtonType.TEXT: {
            VTSButtonState.DEFAULT: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.GRAY_2,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.HOVER: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.PRIMARY_0,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.FOCUS: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.PRIMARY_6,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.ACTIVE: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.PRIMARY_1,
              'borderColor': VTSColors.TRANSPARENT,
            },
            VTSButtonState.DISABLE: {
              'background': VTSColors.TRANSPARENT,
              'fontColor': VTSColors.GRAY_4,
              'borderColor': VTSColors.TRANSPARENT,
            },
          }
        },
        'fontSize': {
           VTSButtonSize.SM: VTSCommon.FONT_SIZE_SM,
           VTSButtonSize.MD: VTSCommon.FONT_SIZE_MD,
        },
        'fontWeight': {
          VTSButtonType.PRIMARY: FontWeight.w700,
          VTSButtonType.SECONDARY: FontWeight.w700,
          VTSButtonType.TEXT: FontWeight.w700,
          VTSButtonType.LINK: VTSCommon.TEXT_STYLE_LINK_TEXT.fontWeight
        },
        'boxConstrains': {
          withIconSelector: const BoxConstraints(minWidth: 100.0),
          withoutIconSelector: const BoxConstraints(minWidth: 80.0)
        },
        'borderRadius': {
          VTSButtonShape.PILL: VTSCommon.BORDER_RADIUS_PILL,
          VTSButtonShape.CIRCLE: VTSCommon.BORDER_RADIUS_CIRCLE,
          VTSButtonShape.STANDARD: VTSCommon.BORDER_RADIUS_STANDARD,
        }
      },
      iconOnlySelector: {
        'height': {
          VTSButtonSize.SM: 24.0,
          VTSButtonSize.MD: 48.0,
          VTSButtonSize.LG: 64.0,
        },
        'padding': const EdgeInsets.all(0),
        'iconFontSize': {
          VTSButtonSize.SM: 12.0,
          VTSButtonSize.MD: 24.0,
          VTSButtonSize.LG: 32.0,
        },
        'color': {
          VTSButtonType.PRIMARY: {
            VTSButtonState.DEFAULT: {
              'background': VTSColors.GRAY_2,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.GRAY_2
            },
            VTSButtonState.HOVER: {
              'background': VTSColors.PRIMARY_2,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_2,
            },
            VTSButtonState.FOCUS: {
              'background': VTSColors.PRIMARY_0,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_0,
            },
            VTSButtonState.ACTIVE: {
              'background': VTSColors.PRIMARY_6,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_6,
            },
            VTSButtonState.DISABLE: {
              'background': VTSColors.GRAY_5,
              'fontColor': VTSColors.GRAY_3,
              'borderColor': VTSColors.GRAY_5,
            },
          },
          VTSButtonType.SECONDARY: {
            VTSButtonState.DEFAULT: {
              'background': VTSColors.WHITE_1,
              'fontColor': VTSColors.GRAY_2,
              'borderColor': VTSColors.GRAY_2,
            },
            VTSButtonState.HOVER: {
              'background': VTSColors.FUNC_RED_6,
              'fontColor': VTSColors.PRIMARY_1,
              'borderColor': VTSColors.PRIMARY_1,
            },
            VTSButtonState.FOCUS: {
              'background': VTSColors.PRIMARY_0,
              'fontColor': VTSColors.WHITE_1,
              'borderColor': VTSColors.PRIMARY_0,
            },
            VTSButtonState.ACTIVE: {
              'background': VTSColors.FUNC_RED_6,
              'fontColor': VTSColors.FUNC_RED_2,
              'borderColor': VTSColors.FUNC_RED_2,
            },
            VTSButtonState.DISABLE: {
              'background': VTSColors.WHITE_1,
              'fontColor': VTSColors.GRAY_3,
              'borderColor': VTSColors.GRAY_5,
            },
          },
        },
        'boxConstrains': const BoxConstraints(minWidth: 0.0)
      },
    }
  };

  static String iconOnlySelector = 'iconOnly';
  static String withIconSelector = 'withIcon';
  static String withoutIconSelector = 'withoutIcon';

  static dynamic get(
      String key,
      bool iconOnly,
      { bool? hasIcon, List<Object> extra = const [] }
    ) => retriveItem([VTSButtonStyle.VTS_BUTTON_PREFIX, iconOnly ? iconOnlySelector : 'default', key, ...extra])
    ?? retriveItem([VTSButtonStyle.VTS_BUTTON_PREFIX, iconOnly ? iconOnlySelector : 'default', key])
    ?? retriveItem([VTSButtonStyle.VTS_BUTTON_PREFIX, 'default', key, ...extra])
    ?? retriveItem([VTSButtonStyle.VTS_BUTTON_PREFIX, 'default', key]);

  static dynamic getAppendHasIcon(
      String key,
      bool iconOnly,
      bool? hasIcon, 
      { List<Object> extra = const [] }
    ) => get(
      key, 
      iconOnly, 
      extra: extra.isNotEmpty 
       ? [hasIcon == true ? withIconSelector : withoutIconSelector, ...extra] 
       : [hasIcon == true ? withIconSelector : withoutIconSelector]
    );

  static dynamic retriveItem(List<Object> buildKeys) {
      final key = buildKeys.map((e) => e.toString()).join('_');
      if (VTSButtonStyle.Content.containsKey(key)) {
        return VTSButtonStyle.Content[key];
      }
      else {
        return null;
      }
  }

  static Map<String, dynamic> Content = VTSButtonStyle.internal()._content;
  Map<String, dynamic> _content = {};

  factory VTSButtonStyle.internal() {
    var instance = VTSButtonStyle();
    Map<String, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }
  
  VTSButtonStyle();
}