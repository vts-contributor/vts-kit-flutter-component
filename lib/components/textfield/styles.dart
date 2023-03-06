// ignore_for_file: sort_constructors_first, sort_unnamed_constructors_first, prefer_int_literals, non_constant_identifier_names, prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:vts_component/common/style/generator.dart';
import 'package:vts_component/components/textfield/typing.dart';
import 'package:vts_component/vts_component.dart';

class VTSTextFieldStyle {
  static var key = '';
  static const VTS_TEXTFIELD_PREFIX = "TEXTFIELD";

  Map<dynamic, dynamic> metaContent = {
    VTSTextFieldStyle.VTS_TEXTFIELD_PREFIX: {
      'default': {
        'height': VTSCommon.CONTROL_HEIGHT_MD,
        'contentPadding': VTSCommon.CONTROL_PADDING_MD,
        'fontSize': VTSCommon.FONT_SIZE_SM,
        'fontWeight': FontWeight.normal,
        'fontFamily': VTSCommon.DEFAULT_FONT_FAMILY,
        'errorMessageColor': VTSColors.PRIMARY_1,
        'borderRadius': BorderRadius.circular(6),
        'background': {
          VTSTextFieldState.DEFAULT: VTSColors.WHITE_1,
          VTSTextFieldState.DISABLE: VTSColors.GRAY_5,
          VTSTextFieldState.ERROR: VTSColors.WHITE_1,
        },
        'labelTextColor': {
          VTSTextFieldState.DEFAULT: VTSColors.BLACK_1,
          VTSTextFieldState.DISABLE: VTSColors.GRAY_3,
          VTSTextFieldState.ERROR: VTSColors.BLACK_1
        },
      }
    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
      selector != null
          ? retriveItem([
                VTSTextFieldStyle.VTS_TEXTFIELD_PREFIX,
                'default',
                key,
                selector,
                ...extra
              ]) ??
              retriveItem([
                VTSTextFieldStyle.VTS_TEXTFIELD_PREFIX,
                'default',
                key,
                selector
              ])
          : retriveItem([
                VTSTextFieldStyle.VTS_TEXTFIELD_PREFIX,
                'default',
                key,
                ...extra
              ]) ??
              retriveItem(
                  [VTSTextFieldStyle.VTS_TEXTFIELD_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSTextFieldStyle.Content.containsKey(key)) {
      return VTSTextFieldStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSTextFieldStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

  factory VTSTextFieldStyle.internal() {
    final instance = VTSTextFieldStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  VTSTextFieldStyle();
}
