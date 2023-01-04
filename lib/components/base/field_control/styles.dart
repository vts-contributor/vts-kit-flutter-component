// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/base/field_control/typings.dart';

class VTSFieldControlStyle {
  static const VTS_FIELD_CONTROL_PREFIX = "FIELD_CONTROL";

  Map<dynamic, dynamic> metaContent = {
    VTS_FIELD_CONTROL_PREFIX: {
      "default": {
        "borderRadius": VTSCommon.BORDER_RADIUS_STANDARD,
      },
      "background": {
        VTSFieldControlState.DEFAULT: VTSCommon.CONTROL_BG_DEFAULT,
        VTSFieldControlState.HOVER: VTSCommon.CONTROL_BG_HOVER,
        VTSFieldControlState.FOCUS: VTSCommon.CONTROL_BG_FOCUS,
        VTSFieldControlState.DISABLE: VTSCommon.CONTROL_BG_DISABLE,
        VTSFieldControlState.ERROR: VTSCommon.CONTROL_BG_ERROR,
      },
      "textStyle": {
        VTSFieldControlState.DEFAULT: VTSCommon.CONTROL_TEXT_STYLE_DEFAULT,
        VTSFieldControlState.HOVER: VTSCommon.CONTROL_TEXT_STYLE_HOVER,
        VTSFieldControlState.FOCUS: VTSCommon.CONTROL_TEXT_STYLE_FOCUS,
        VTSFieldControlState.DISABLE: VTSCommon.CONTROL_TEXT_STYLE_DISABLE,
        VTSFieldControlState.ERROR: VTSCommon.CONTROL_TEXT_STYLE_ERROR,
      },
      "height": {
        VTSFieldControlSize.SM: VTSCommon.CONTROL_HEIGHT_SM,
        VTSFieldControlSize.MD: VTSCommon.CONTROL_HEIGHT_MD,
      },
      "padding": {
        VTSFieldControlSize.SM: VTSCommon.CONTROL_PADDING_SM,
        VTSFieldControlSize.MD: VTSCommon.CONTROL_PADDING_MD,
      },
      "margin": {
        VTSFieldControlSize.SM: VTSCommon.CONTROL_MARGIN_SM,
        VTSFieldControlSize.MD: VTSCommon.CONTROL_MARGIN_MD,
      },
      "borderColor": {
        VTSFieldControlState.DEFAULT: VTSCommon.CONTROL_BORDER_COLOR_DEFAULT,
        VTSFieldControlState.HOVER: VTSCommon.CONTROL_BORDER_COLOR_HOVER,
        VTSFieldControlState.FOCUS: VTSCommon.CONTROL_BORDER_COLOR_FOCUS,
        VTSFieldControlState.DISABLE: VTSCommon.CONTROL_BORDER_COLOR_DISABLE,
        VTSFieldControlState.ERROR: VTSCommon.CONTROL_BORDER_COLOR_ERROR,
      },
      "boxShadow": {
        VTSFieldControlState.DEFAULT: VTSCommon.CONTROL_BOX_SHADOW_DEFAULT,
        VTSFieldControlState.HOVER: VTSCommon.CONTROL_BOX_SHADOW_HOVER,
        VTSFieldControlState.FOCUS: VTSCommon.CONTROL_BOX_SHADOW_FOCUS,
        VTSFieldControlState.DISABLE: VTSCommon.CONTROL_BOX_SHADOW_DISABLE,
        VTSFieldControlState.ERROR: VTSCommon.CONTROL_BOX_SHADOW_ERROR,
      },
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, { selector, List<Object> extra = const [] }) 
    => selector != null 
      ? retriveItem([VTSFieldControlStyle.VTS_FIELD_CONTROL_PREFIX, key, selector, ...extra])
      ?? retriveItem([VTSFieldControlStyle.VTS_FIELD_CONTROL_PREFIX, key, selector])
      : retriveItem([VTSFieldControlStyle.VTS_FIELD_CONTROL_PREFIX, 'default', key, ...extra])
      ?? retriveItem([VTSFieldControlStyle.VTS_FIELD_CONTROL_PREFIX, 'default', key]);


  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSFieldControlStyle.Content.containsKey(key)) {
      return VTSFieldControlStyle.Content[key];
    }
    else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSFieldControlStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSFieldControlStyle.internal() {
    final instance = VTSFieldControlStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSFieldControlStyle();
}