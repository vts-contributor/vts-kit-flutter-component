// ignore_for_file: avoid_classes_with_only_static_members, non_constant_identifier_names, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:vts_component/vts_component.dart';

class VTSCommon {
  // Global
  static const String DEFAULT_FONT_FAMILY = 'Sarabun';
  static const double FONT_SIZE_XS = 14;
  static const double FONT_SIZE_SM = 16;
  static const double FONT_SIZE_MD = 20;
  static const double ICON_FONT_SIZE_SM = 24;
  static const double ICON_FONT_SIZE_MD = 24;
  static const double BASE_BORDER_RADIUS = 3;
  static const Color PLACEHOLDER_FONT_COLOR = VTSColors.GRAY_3;
  static const Duration ANIMATION_NORMAL_DURATION = Duration(milliseconds: 200);

  /// [VTSCommon.SMALL] is used for small size widget
  static const double SMALL = 20;
  /// Default size if [VTSCommon.MEDIUM] is used for medium size widget
  static const double MEDIUM = 25;
  /// [VTSCommon.LARGE] is used for large size widget
  static const double LARGE = 30;

  static const double billion = 1000000000;

  static const double million = 1000000;

  static const double kilo = 1000;

  // Base color
  static const Color BOX_SHADOW_COLOR = Color.fromRGBO(0, 0, 0, 0.15);
  static const Color SPLASH_COLOR = Color.fromRGBO(0, 0, 0, 0.15);

  // Box shadow
  static const BoxShadow BLUR3_X0_Y1 = BoxShadow(color: BOX_SHADOW_COLOR, offset: Offset(0, 1), blurRadius: 3);
  static const BoxShadow BLUR8_X0_Y0 = BoxShadow(color: BOX_SHADOW_COLOR, offset: Offset(0, 0), blurRadius: 8);

  // Border
  static Color BORDER_COLOR_LIGHT = VTSColors.ILUS_GRAY_6;
  static Color BORDER_COLOR = VTSColors.GRAY_4;

  // Shape
  static BorderRadius BORDER_RADIUS_SQUARE = BorderRadius.zero;
  static BorderRadius BORDER_RADIUS_PILL = BorderRadius.circular(50);
  static BorderRadius BORDER_RADIUS_CIRCLE = BorderRadius.circular(100);
  static BorderRadius BORDER_RADIUS_STANDARD = BorderRadius.circular(BASE_BORDER_RADIUS);

  // Position
  static List<double?> LTRB_TOP_RIGHT = [null, 0, 0, null];
  static List<double?> LTRB_TOP_LEFT = [0, 0, null, null];
  static List<double?> LTRB_BOTTOM_LEFT = [0, null, null, 0];
  static List<double?> LTRB_BOTTOM_RIGHT = [null, null, 0, 0];
  static Offset TRANSLATION_TOP_RIGHT = const Offset(0.5, -0.5);
  static Offset TRANSLATION_TOP_LEFT = const Offset(-0.5, -0.5);
  static Offset TRANSLATION_BOTTOM_LEFT = const Offset(-0.5, 0.5);
  static Offset TRANSLATION_BOTTOM_RIGHT = const Offset(0.5, 0.5);

  // Text styly
  static TextStyle TEXT_STYLE_BODY_1_16 = const TextStyle(
    color: VTSColors.BLACK_1,
    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    height: 1.5
  );
  static TextStyle TEXT_STYLE_SUBTITLE_1_20 = const TextStyle(
    color: VTSColors.BLACK_1,
    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    height: 1.5,
    overflow: TextOverflow.ellipsis
  );
  static TextStyle TEXT_STYLE_SUBTITLE_2_16 = const TextStyle(
    color: VTSColors.BLACK_1,
    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.5,
    overflow: TextOverflow.ellipsis
  );
  static TextStyle TEXT_STYLE_LINK_TEXT = const TextStyle(
    color: VTSColors.PRIMARY_6,
    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    height: 1.5,
    decoration: TextDecoration.underline,
    overflow: TextOverflow.ellipsis
  );
  static TextStyle TEXT_STYLE_BODY_2_14 = const TextStyle(
    color: VTSColors.GRAY_2,
    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    height: 1.57,
    overflow: TextOverflow.ellipsis
  );

  // Control (All about form field)
  static double CONTROL_HEIGHT_SM = 40.0; 
  static double CONTROL_HEIGHT_MD = 48.0;
  
  static EdgeInsets CONTROL_PADDING_SM = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0); 
  static EdgeInsets CONTROL_PADDING_MD = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0); 

  static EdgeInsets CONTROL_MARGIN_SM = const EdgeInsets.all(0);
  static EdgeInsets CONTROL_MARGIN_MD = const EdgeInsets.all(0);

  static Color CONTROL_BG_DEFAULT = VTSColors.WHITE_1; 
  static Color CONTROL_BG_HOVER = VTSColors.WHITE_1; 
  static Color CONTROL_BG_FOCUS = VTSColors.WHITE_1; 
  static Color CONTROL_BG_DISABLE = VTSColors.GRAY_5;
  static Color CONTROL_BG_ERROR = VTSColors.WHITE_1;

  static TextStyle CONTROL_TEXT_STYLE_DEFAULT = VTSCommon.TEXT_STYLE_BODY_1_16.merge(const TextStyle(color: VTSColors.BLACK_1)); 
  static TextStyle CONTROL_TEXT_STYLE_HOVER = VTSCommon.TEXT_STYLE_BODY_1_16.merge(const TextStyle(color: VTSColors.BLACK_1)); 
  static TextStyle CONTROL_TEXT_STYLE_FOCUS = VTSCommon.TEXT_STYLE_BODY_1_16.merge(const TextStyle(color: VTSColors.BLACK_1)); 
  static TextStyle CONTROL_TEXT_STYLE_DISABLE = VTSCommon.TEXT_STYLE_BODY_1_16.merge(const TextStyle(color: VTSColors.GRAY_3)); 
  static TextStyle CONTROL_TEXT_STYLE_ERROR = VTSCommon.TEXT_STYLE_BODY_1_16.merge(const TextStyle(color: VTSColors.BLACK_1)); 

  static Color CONTROL_BORDER_COLOR_DEFAULT = VTSColors.GRAY_3; 
  static Color CONTROL_BORDER_COLOR_HOVER = VTSColors.GRAY_1; 
  static Color CONTROL_BORDER_COLOR_FOCUS = VTSColors.GRAY_1; 
  static Color CONTROL_BORDER_COLOR_DISABLE = VTSColors.GRAY_5;
  static Color CONTROL_BORDER_COLOR_ERROR = VTSColors.PRIMARY_1;
  
  static List<BoxShadow>? CONTROL_BOX_SHADOW_DEFAULT = null;
  static List<BoxShadow>? CONTROL_BOX_SHADOW_HOVER = null;
  static List<BoxShadow>? CONTROL_BOX_SHADOW_FOCUS = [VTSCommon.BLUR8_X0_Y0]; 
  static List<BoxShadow>? CONTROL_BOX_SHADOW_DISABLE = null;
  static List<BoxShadow>? CONTROL_BOX_SHADOW_ERROR = null;

  static const double ACTION_ICON_FONT_SIZE = VTSCommon.ICON_FONT_SIZE_SM;
  static const Color ACTION_FONT_COLOR_DEFAULT = VTSColors.GRAY_1;
  static const Color ACTION_FONT_COLOR_ACTIVE = VTSColors.PRIMARY_1;
}
