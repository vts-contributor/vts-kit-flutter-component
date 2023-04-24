import 'package:flutter/cupertino.dart';
import 'package:vts_component/components/radio_button/typings.dart';

import '../../common/style/generator.dart';
import '../../common/style/vts_common.dart';

class VTSRadioButtonStyle{

  VTSRadioButtonStyle();

  factory VTSRadioButtonStyle.internal() {
    final instance = VTSRadioButtonStyle();
    final Map<dynamic, dynamic> result = {};
    instance._content = Generator.fromMap(instance.metaContent, result);
    return instance;
  }

  static const VTS_RADIO_BUTTON_PREFIX = "RADIOBUTTON";

  Map<dynamic, dynamic> metaContent = {
    VTSRadioButtonStyle.VTS_RADIO_BUTTON_PREFIX: {
      'default': {
        'radioButtonBorderRadius': {
          VTSRadioButtonType.SQUARE : BorderRadius.zero,
          VTSRadioButtonType.ROUNDED : BorderRadius.circular(5),
          VTSRadioButtonType.BASIC : BorderRadius.circular(50),
        },
        'size':{
          VTSRadioButtonSize.MD : VTSCommon.MEDIUM,
          VTSRadioButtonSize.LG : VTSCommon.LARGE,
          VTSRadioButtonSize.SM : VTSCommon.SMALL,
        },
      },

    }
  };

  // ignore: type_annotate_public_apis
  static dynamic get(String key, {selector, List<Object> extra = const []}) =>
      selector != null
          ? retriveItem([VTSRadioButtonStyle.VTS_RADIO_BUTTON_PREFIX, key, selector, ...extra])
          ?? retriveItem([VTSRadioButtonStyle.VTS_RADIO_BUTTON_PREFIX, key, selector])
          ?? retriveItem([VTSRadioButtonStyle.VTS_RADIO_BUTTON_PREFIX, 'default', key, ...extra])
          ?? retriveItem([VTSRadioButtonStyle.VTS_RADIO_BUTTON_PREFIX, 'default', key])
          : retriveItem([VTSRadioButtonStyle.VTS_RADIO_BUTTON_PREFIX, 'default', key, ...extra])
          ?? retriveItem([VTSRadioButtonStyle.VTS_RADIO_BUTTON_PREFIX, 'default', key]);

  static dynamic retriveItem(List<Object> buildKeys) {
    final key = buildKeys.map((e) => e.toString()).join('_');
    if (VTSRadioButtonStyle.Content.containsKey(key)) {
      return VTSRadioButtonStyle.Content[key];
    } else {
      return null;
    }
  }

  static Map<dynamic, dynamic> Content = VTSRadioButtonStyle.internal()._content;
  Map<dynamic, dynamic> _content = {};

}