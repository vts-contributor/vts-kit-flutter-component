import 'package:flutter/cupertino.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/checkbox/typings.dart';

import '../../common/style/generator.dart';

class VTSCheckboxStyle{

  VTSCheckboxStyle();

  factory VTSCheckboxStyle.internal() {
    final instance = VTSCheckboxStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  static const VTS_CHECKBOX_PREFIX = "CHECKBOX";

  Map<dynamic, dynamic> metaContent = {
    VTSCheckboxStyle.VTS_CHECKBOX_PREFIX: {
      'default': {
        'checkboxBorderRadius': {
          VTSCheckboxType.BASIC: BorderRadius.circular(3),
          VTSCheckboxType.CIRCLE: BorderRadius.circular(50),
          VTSCheckboxType.SQUARE: BorderRadius.zero,
        },
        'checkboxMargin' : {
          VTSCheckboxType.CIRCLE : const EdgeInsets.all(40),
          VTSCheckboxType.BASIC : EdgeInsets.zero,
          VTSCheckboxType.SQUARE : EdgeInsets.zero
        },
        'checkboxHighlightShape' : {
          VTSCheckboxType.CIRCLE : BoxShape.circle,
          VTSCheckboxType.BASIC : BoxShape.rectangle,
          VTSCheckboxType.SQUARE : BoxShape.rectangle
        },
        'checkboxContainedInkWell':{
          VTSCheckboxType.CIRCLE : false,
          VTSCheckboxType.BASIC : true,
          VTSCheckboxType.SQUARE : true
        },
        'size':{
          VTSCheckboxSize.MD : VTSCommon.MEDIUM,
          VTSCheckboxSize.LG : VTSCommon.LARGE,
          VTSCheckboxSize.SM : VTSCommon.SMALL,
        },
      },

    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
      selector != null
          ? retriveItem([VTSCheckboxStyle.VTS_CHECKBOX_PREFIX, key, selector, ...extra])
          ?? retriveItem([VTSCheckboxStyle.VTS_CHECKBOX_PREFIX, key, selector])
          ?? retriveItem([VTSCheckboxStyle.VTS_CHECKBOX_PREFIX, 'default', key, ...extra])
          ?? retriveItem([VTSCheckboxStyle.VTS_CHECKBOX_PREFIX, 'default', key])
          : retriveItem([VTSCheckboxStyle.VTS_CHECKBOX_PREFIX, 'default', key, ...extra])
          ?? retriveItem([VTSCheckboxStyle.VTS_CHECKBOX_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSCheckboxStyle.Content.containsKey(key)) {
      return VTSCheckboxStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSCheckboxStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

}