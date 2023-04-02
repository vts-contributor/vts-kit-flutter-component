import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/components/checkbox/index.dart';
import 'package:vts_component/components/checkbox/typings.dart';

import '../../common/style/vts_color.dart';

class VTSCheckbox extends StatefulWidget{
   VTSCheckbox({
    Key? key,
    this.vtsType = VTSCheckboxType.BASIC,
    this.size = VTSCheckboxSize.MD,
    this.activeBgColor = VTSColors.PRIMARY_1,
    this.inactiveBgColor = VTSColors.WHITE_1,
    this.activeBorderColor = VTSColors.WHITE_1,
     this.inActiveBorderColor = VTSColors.BLACK_1,
    required this.onChanged,
    required this.value,
    this.icon = Icons.check,
    this.activeIcon ,
    this.inactiveIcon,
    this.autofocus = false,
    this.focusNode,
     this.validate = false,
    this.errorMessage = 'Error message',
    this.errorMargin = 5,
    this.titleMargin = 5,
    this.titleFontColor = VTSColors.BLACK_1,
     this.alertColor = VTSColors.PRIMARY_1,
    this.title = 'Checkbox',

   }) : super(key: key);

   /// type of [VTSCheckboxType] which is of four type is basic, square, circular
  final VTSCheckboxType vtsType;

   /// Button type of [VTSCheckboxSize] i.e, sm, md,lg
   final VTSCheckboxSize size;

   /// type of [Color] used to change the backgroundColor of the active checkbox
  final Color activeBgColor;

   /// type of [Color] used to change the backgroundColor of the inactive checkbox
   final Color inactiveBgColor;

   /// type of [Color] used to change the border color of the active checkbox
   final Color activeBorderColor;

   /// type of [Color] used to change the border color of the active checkbox
   final Color inActiveBorderColor;

   /// Called when the user checks or unchecks the checkbox.
   final ValueChanged<bool>? onChanged;

   ///type of [bool] used to set the current state of the checkbox
   final bool value;

   /// type of [Widget] used to change the  checkbox's active icon
   late Widget? activeIcon;

   /// type of [Widget] used to change the  checkbox's inactive icon
   final Widget? inactiveIcon;

   /// on true state this widget will be selected as the initial focus
   /// when no other node in its scope is currently focused
  final bool autofocus;

   /// an optional focus node to use as the focus node for this widget.
   final FocusNode? focusNode;

   ///type of [bool] used to check the checkbox must be ticked
   final bool validate;

   ///type of [String] used to set the error message of the checkbox
   final String errorMessage;

   /// type of [double] used set space between error message and checkbox
  final double errorMargin;

   ///type of [double] used to set space between title and checkbox
   final double titleMargin;

   /// type of [Color] used to set space between title and checkbox
   final Color titleFontColor;

   /// type of [Color] used to set color of error message
   final Color alertColor;

   /// type of [String] used to set title
   final String title;

   ///type of [IconData] used to set icon
   final IconData icon;


  @override
  State<StatefulWidget> createState() => VTSCheckboxState();
}

class VTSCheckboxState extends State<VTSCheckbox>{
  bool get enabled => widget.onChanged != null;
  late double checkboxSize;

  dynamic getStyle(
      String key,
      List<Object> extra
      ) => VTSCheckboxStyle.get(key, extra: extra);

  @override
  void initState() {
    super.initState();
    checkboxSize = getStyle('size', [widget.size]);
    widget.activeIcon ??= Icon(
        widget.icon,
        size: checkboxSize * 0.7,
        color: VTSColors.WHITE_1,
      );
  }

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
      enabled: enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
          InkResponse(
            highlightShape: getStyle('checkboxHighlightShape', [widget.vtsType]),
            containedInkWell: getStyle('checkboxContainedInkWell', [widget.vtsType]),
            canRequestFocus: enabled,
            onTap: widget.onChanged != null
                ? () {
              widget.onChanged!(!widget.value);
            } : null,
            child: Container(
              height: checkboxSize,
              width: checkboxSize,
              margin: getStyle('checkboxMargin', [widget.vtsType]),
              decoration: BoxDecoration(
                  color: enabled
                    ? widget.validate ? widget.alertColor.withOpacity(0.3)
                      : widget.value
                      ? widget.activeBgColor
                      : widget.inactiveBgColor
                      : VTSColors.GRAY_3,
                  borderRadius: getStyle('checkboxBorderRadius', [widget.vtsType]),
                  border: Border.all(
                      color: widget.validate
                          ? widget.alertColor
                          : widget.value
                          ? widget.activeBorderColor
                          : widget.inActiveBorderColor
                  )
              ),
              child: widget.value ?
                    widget.activeIcon
                  : widget.inactiveIcon,
            ),
          ),
          SizedBox(width: widget.titleMargin),
          Container(child: Text(widget.title,style: TextStyle(
            color: widget.validate ? widget.alertColor : widget.titleFontColor,
            fontSize: checkboxSize * 0.65
          )),)
            ],
          ),
          if (widget.validate)...[
            SizedBox(height: widget.errorMargin),
            Container(
            alignment: Alignment.centerLeft,
            child: Text(widget.errorMessage,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: checkboxSize * 0.5,
                    color: widget.alertColor
                )),
          )]
        ],
      )
    );


  
}