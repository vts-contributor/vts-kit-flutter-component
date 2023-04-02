import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/components/radio_button/style.dart';
import 'package:vts_component/components/radio_button/typings.dart';

import '../../common/style/vts_color.dart';

class VTSRadioButton<T> extends StatefulWidget {
  const VTSRadioButton(
      {Key? key,
        required this.value,
        required this.groupValue,
        required this.onChanged,
        this.size = VTSRadioButtonSize.MD,
        this.vtsType = VTSRadioButtonType.BASIC,
        this.radioColor = VTSColors.PRIMARY_1,
        this.activeBgColor = VTSColors.WHITE_1,
        this.inactiveBgColor = VTSColors.WHITE_1,
        this.activeBorderColor = VTSColors.PRIMARY_1,
        this.inactiveBorderColor = VTSColors.GRAY_1,
        this.inactiveIcon,
        this.titleMargin = 5,
        this.errorMargin = 5,
        this.title = "Radio button",
        this.alertColor = VTSColors.PRIMARY_1,
        this.titleFontColor = VTSColors.BLACK_1,
        this.errorMessage = "Error message",
         this.validate = false,

      })
      : super(key: key);

  /// type of [VTSRadioButtonType] which is of four type is basic, square, rounded
  final VTSRadioButtonType vtsType;

  /// type type of [VTSRadioButtonSize] i.e, sm, md,lg
  final VTSRadioButtonSize size;

  /// type pf [Color] used to change the checkcolor when the radio button is active
  final Color radioColor;

  /// type of [Color] used to change the backgroundColor of the active radio button
  final Color activeBgColor;

  /// type of [Color] used to change the backgroundColor of the inactive radio button
  final Color inactiveBgColor;

  /// type of [Color] used to change the border color of the active radio button
  final Color activeBorderColor;

  /// type of [Color] used to change the border color of the inactive radio button
  final Color inactiveBorderColor;

  /// Called when the user checks or unchecks the radio button
  final ValueChanged<T>? onChanged;

  ///type of [Widget] used to change the  radio button's inactive icon
  final Widget? inactiveIcon;

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons. Radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  ///type of [double] used to set space between title and
  final double titleMargin;

  ///type of [double] used to set space between title and checkbox
  final String title ;

  ///type of [bool] used to check the checkbox must be ticked
  final bool validate;

  /// type of [Color] used to set color of error message
  final Color alertColor;

  /// type of [Color] used to set space between title and checkbox
  final Color titleFontColor;

  /// type of [double] used set space between error message and radi
  final double errorMargin;

  ///type of [String] used to set the error message of the radiobutton
  final String errorMessage;


  @override
  _VTSRadioState<T> createState() => _VTSRadioState<T>();
}

class _VTSRadioState<T> extends State<VTSRadioButton<T>> with TickerProviderStateMixin {
  bool get enabled => widget.onChanged != null;
  bool selected = false;
  T? groupValue;
  late double radioButtonSize;

  void onStatusChange() {
    groupValue = widget.value;
    _handleChanged(widget.value == groupValue);
  }

  void _handleChanged(bool selected) {
    if (selected) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void initState() {
    super.initState();
    radioButtonSize = getStyle('size',[widget.size]);
  }

  dynamic getStyle(
      String key,
      List<Object> extra
      ) => VTSRadioButtonStyle.get(key, extra: extra);

  @override
  Widget build(BuildContext context) {
    selected = widget.value == widget.groupValue;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
                borderRadius : getStyle('radioButtonBorderRadius',[widget.vtsType]),
                enableFeedback: enabled,
                onTap: onStatusChange,
                child: Container(
                    height: radioButtonSize,
                    width: radioButtonSize,
                    decoration: BoxDecoration(
                        color: widget.validate ? widget.alertColor.withOpacity(0.3) : selected ? widget.activeBgColor : widget.inactiveBgColor,
                        borderRadius: getStyle('radioButtonBorderRadius',[widget.vtsType]),
                        border: Border.all(
                            color: selected
                                ? widget.activeBorderColor
                                : widget.inactiveBorderColor)),
                    child: selected
                        ? Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: radioButtonSize * 0.7,
                          height: radioButtonSize * 0.7,
                          decoration: BoxDecoration(
                              shape:  BoxShape.circle,
                              color: widget.radioColor),
                        )
                      ],
                    ) : widget.inactiveIcon)
            ),
            SizedBox(width: widget.titleMargin),
            Container(child: Text(widget.title,style: TextStyle(
                color: widget.validate ? widget.alertColor : widget.titleFontColor,
                fontSize: radioButtonSize * 0.65
            )),)
          ],
        ),
        if (widget.validate)...[
          SizedBox(height: widget.errorMargin),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(widget.errorMessage,
                style: TextStyle(
                    fontSize: radioButtonSize * 0.5,
                    color: widget.alertColor
                )),
          )]

      ],
    ) ;

  }
}