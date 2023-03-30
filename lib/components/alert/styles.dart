import 'package:flutter/material.dart';
import 'package:vts_component/components/alert/typing.dart';
import 'package:vts_component/vts_component.dart';

class VTSAlertStyle {
  final double _iconFillSize = 40;
  final double _iconOutLineSize = 30;
  final double _defaultPadding = 8;
  final double _titleFontSize = 20;
  final double _subTitleFontSize = 17;
  final FontWeight _titielFW = FontWeight.w700;
  final FontWeight _subTitleFW = FontWeight.w400;
  final String _fontFamily = VTSCommon.DEFAULT_FONT_FAMILY;
  final List<BoxShadow> _boxShadow = [VTSCommon.BLUR3_X0_Y1];

  Widget getIcon(VTSAlertType? alertType, Icon? icon) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return Padding(
          padding: EdgeInsets.only(top: _defaultPadding),
          child: Icon(
            Icons.highlight_off,
            size: _iconFillSize,
            color: VTSColors.WHITE_1,
          ),
        );
      case VTSAlertType.ERROR_OUTLINE:
        return Icon(
          Icons.highlight_off,
          size: _iconOutLineSize,
          color: VTSColors.FUNC_RED_2,
        );
      case VTSAlertType.INFO_FILL:
        return Padding(
          padding: EdgeInsets.only(top: _defaultPadding),
          child: Icon(
            Icons.info_outline,
            size: _iconFillSize,
            color: VTSColors.WHITE_1,
          ),
        );
      case VTSAlertType.INFO_OUTLINE:
        return Icon(
          Icons.info_outline,
          size: _iconOutLineSize,
          color: VTSColors.FUNC_BLUE_2,
        );
      case VTSAlertType.SUCCESS_FILL:
        return Padding(
          padding: EdgeInsets.only(top: _defaultPadding),
          child: Icon(
            Icons.check_circle_outline_outlined,
            size: _iconFillSize,
            color: VTSColors.WHITE_1,
          ),
        );
      case VTSAlertType.SUCCESS_OUTLINE:
        return Icon(
          Icons.check_circle_outline_outlined,
          size: _iconOutLineSize,
          color: VTSColors.FUNC_GREEN_2,
        );
      case VTSAlertType.WARNING_FILL:
        return Padding(
          padding: EdgeInsets.only(top: _defaultPadding),
          child: Icon(
            Icons.warning_amber_outlined,
            size: _iconFillSize,
            color: VTSColors.WHITE_1,
          ),
        );
      case VTSAlertType.WARNING_OUTLINE:
        return Icon(
          Icons.warning_amber_outlined,
          size: _iconOutLineSize,
          color: VTSColors.FUNC_ORANGE_1,
        );
      default:
        return icon ??
            const SizedBox(
              width: 20,
            );
    }
  }

  Color getBackgroundColor(VTSAlertType? alertType, Color? backgroundColor) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return VTSColors.FUNC_RED_2;
      case VTSAlertType.ERROR_OUTLINE:
        return VTSColors.ILUS_RED_8;
      case VTSAlertType.INFO_FILL:
        return VTSColors.FUNC_BLUE_2;
      case VTSAlertType.INFO_OUTLINE:
        return VTSColors.FUNC_BLUE_6;
      case VTSAlertType.SUCCESS_FILL:
        return VTSColors.FUNC_GREEN_2;
      case VTSAlertType.SUCCESS_OUTLINE:
        return VTSColors.FUNC_GREEN_6;
      case VTSAlertType.WARNING_FILL:
        return VTSColors.FUNC_ORANGE_2;
      case VTSAlertType.WARNING_OUTLINE:
        return VTSColors.FUNC_YELLOW_6;
      default:
        return backgroundColor ?? VTSColors.WHITE_1;
    }
  }

  TextStyle getTitleTextStyle(
      VTSAlertType? alertType, TextStyle? titleTextStyle) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.ERROR_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_RED_2,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.INFO_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.INFO_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_BLUE_2,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.SUCCESS_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.SUCCESS_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_GREEN_2,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.WARNING_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.WARNING_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_ORANGE_1,
          fontSize: _titleFontSize,
          fontWeight: _titielFW,
          fontFamily: _fontFamily,
        );
      default:
        return titleTextStyle ??
            TextStyle(
              color: VTSColors.BLACK_1,
              fontSize: _titleFontSize,
              fontWeight: _titielFW,
              fontFamily: _fontFamily,
            );
    }
  }

  TextStyle getSubtitleTextStyle(
      VTSAlertType? alertType, TextStyle? subtitleTextStyle) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _subTitleFontSize,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.ERROR_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_RED_2,
          fontSize: _subTitleFontSize,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.INFO_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _subTitleFontSize,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.INFO_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_BLUE_2,
          fontSize: _subTitleFontSize,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.SUCCESS_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _subTitleFontSize,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.SUCCESS_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_GREEN_2,
          fontSize: _subTitleFontSize,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.WARNING_FILL:
        return TextStyle(
          color: VTSColors.WHITE_1,
          fontSize: _subTitleFontSize,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      case VTSAlertType.WARNING_OUTLINE:
        return TextStyle(
          color: VTSColors.FUNC_ORANGE_1,
          fontSize: 17,
          fontWeight: _subTitleFW,
          fontFamily: _fontFamily,
        );
      default:
        return subtitleTextStyle ??
            TextStyle(
              color: VTSColors.BLACK_1,
              fontSize: _subTitleFontSize,
              fontWeight: _subTitleFW,
              fontFamily: _fontFamily,
            );
    }
  }

  BoxBorder getBorder(VTSAlertType? alertType, BoxBorder? border) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return Border.all(color: VTSColors.FUNC_RED_4);
      case VTSAlertType.ERROR_OUTLINE:
        return Border.all(color: VTSColors.FUNC_RED_4);
      case VTSAlertType.INFO_FILL:
        return Border.all(color: VTSColors.FUNC_BLUE_2);
      case VTSAlertType.INFO_OUTLINE:
        return Border.all(color: VTSColors.FUNC_BLUE_2);
      case VTSAlertType.SUCCESS_FILL:
        return Border.all(color: VTSColors.FUNC_GREEN_2);
      case VTSAlertType.SUCCESS_OUTLINE:
        return Border.all(color: VTSColors.FUNC_GREEN_2);
      case VTSAlertType.WARNING_FILL:
        return Border.all(color: VTSColors.FUNC_ORANGE_2);
      case VTSAlertType.WARNING_OUTLINE:
        return Border.all(color: VTSColors.FUNC_YELLOW_3);
      default:
        return border ?? Border.all(color: VTSColors.BLACK_1);
    }
  }

  List<BoxShadow> getListBoxShadow(
      VTSAlertType? alertType, List<BoxShadow>? boxshadow) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return _boxShadow;

      case VTSAlertType.INFO_FILL:
        return _boxShadow;

      case VTSAlertType.SUCCESS_FILL:
        return _boxShadow;

      case VTSAlertType.WARNING_FILL:
        return _boxShadow;

      default:
        return boxshadow ?? [];
    }
  }
}
