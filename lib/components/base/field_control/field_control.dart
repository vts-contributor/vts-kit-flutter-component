import 'package:flutter/material.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/base/field_control/field_control_action.dart';
import 'package:vts_component/components/base/field_control/styles.dart';
import 'package:vts_component/components/base/field_control/typings.dart';
import 'dart:math';

class VTSFieldControl extends StatefulWidget {
  const VTSFieldControl({
    Key? key,
    this.textController,
    this.vtsSize = VTSFieldControlSize.MD,
    this.padding,
    this.margin,
    this.height,

    this.borderRadius,
    this.placeholder,
    this.enabled = true,
    this.onInput,
    this.readonly = false,
    
    this.text,
    this.prefix,
    this.prefixStyle,
    this.suffix,
    this.suffixStyle,

    this.onTap,
    this.onFocus,
    this.onHover,
    this.onSubmit,

    this.backgrounds,
    this.textStyles,
    this.borderColors,
    this.boxShadows
  }) : super(key: key);


  final TextEditingController? textController;
  final VTSFieldControlSize vtsSize;

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;

  final BorderRadius? borderRadius;
  final String? placeholder;

  final bool enabled;

  final bool readonly;

  final String? text;

  final VTSFieldControlAction? prefix;
  final TextStyle? prefixStyle;

  final VTSFieldControlAction? suffix;
  final TextStyle? suffixStyle;

  final Function(String value)? onInput;

  final Function()? onTap;
  final Function(bool hover)? onHover;
  final Function(bool focus)? onFocus;
  final Function()? onSubmit;

  final VTSFieldControlStateStyle<Color>? backgrounds;
  final VTSFieldControlStateStyle<TextStyle>? textStyles;
  final VTSFieldControlStateStyle<Color>? borderColors;
  final VTSFieldControlStateStyle<List<BoxShadow>>? boxShadows;

  @override
  _VTSFieldControlState createState() => _VTSFieldControlState();
}

class _VTSFieldControlState extends State<VTSFieldControl> {
  // Variables
  late TextEditingController _textController = TextEditingController();
  final Set<VTSFieldControlState> _states = <VTSFieldControlState>{};
  late FocusNode _focusNode = FocusNode();

  // State
  bool get _hovered => _states.contains(VTSFieldControlState.HOVER);
  bool get _focused => _states.contains(VTSFieldControlState.FOCUS);
  bool get _disabled => _states.contains(VTSFieldControlState.DISABLE);
  bool get _error => _states.contains(VTSFieldControlState.ERROR);

  VTSFieldControlState get _highPriorityState {
    if (_disabled)
      return VTSFieldControlState.DISABLE;
    if (_error)
      return VTSFieldControlState.ERROR;
    if (_focused)
      return VTSFieldControlState.FOCUS;
    if (_hovered)
      return VTSFieldControlState.HOVER;
    return VTSFieldControlState.DEFAULT;
  }

  // Initital
  @override
  void initState() {
    super.initState();

    _textController = widget.textController ?? _textController;
    _textController.text = widget.text ?? '';

    _focusNode = FocusNode();
    _focusNode.addListener(() => _onFocus(_focusNode.hasFocus));

    if (!widget.enabled)
      _updateState(VTSFieldControlState.DISABLE, true);
  }

  @override
  void didUpdateWidget(VTSFieldControl oldWidget) {
    if (widget.text != oldWidget.text) {
      TextSelection previousSelection = _textController.selection;
      String newText = widget.text ?? '';
      if (min<int>(newText.length, previousSelection.start) == 0)
        previousSelection = TextSelection(baseOffset: 0, extentOffset: 0);

      _textController.value = TextEditingValue(
        text: newText,
        selection: previousSelection
      );
      // _textController.text = widget.text!;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  void _updateState(VTSFieldControlState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  void _onFocus(bool value) {
    if (!widget.enabled)
      return;

    if (!widget.readonly)
      setState(() {
        _updateState(VTSFieldControlState.FOCUS, value);
      });
    if (widget.onFocus != null)
      widget.onFocus!(value);
  }

  void _onHover(bool value) {
    if (!widget.enabled)
      return;

    setState(() {
      _updateState(VTSFieldControlState.HOVER, value);
    });
    if (widget.onHover != null)
      widget.onHover!(value);
  }

  void _onInput(String value) {
    if (!widget.enabled)
      return;

    if (widget.onInput != null)
      widget.onInput!(value);
  }

  void _onSubmit(String value) {
    if (!widget.enabled)
      return;

    if (widget.onSubmit != null)
      widget.onSubmit!();
  }
  
  void _onTap() {
    if (!widget.enabled)
      return;

    _focusNode.requestFocus();
    if (widget.onTap != null)
      widget.onTap!();
  }

  Color get background => widget.backgrounds?.getStyle(_highPriorityState) ?? VTSFieldControlStyle.get('background', selector: _highPriorityState);
  TextStyle get textStyle => widget.textStyles?.getStyle(_highPriorityState) ?? VTSFieldControlStyle.get('textStyle', selector: _highPriorityState);
  Color get borderColor => widget.borderColors?.getStyle(_highPriorityState) ?? VTSFieldControlStyle.get('borderColor', selector: _highPriorityState);
  List<BoxShadow>? get boxShadow => widget.boxShadows?.getStyle(_highPriorityState) ?? VTSFieldControlStyle.get('boxShadow', selector: _highPriorityState);

  TextStyle get hintTextStyle => (
    widget.textStyles?.getStyle(VTSFieldControlState.DEFAULT) ?? VTSFieldControlStyle.get('textStyle', selector: VTSFieldControlState.DEFAULT)
  ).merge(const TextStyle(color: VTSCommon.PLACEHOLDER_FONT_COLOR));

  MouseCursor? get mouseCursor => 
    _disabled 
    ? SystemMouseCursors.forbidden 
    : (widget.readonly && widget.onTap != null 
      ? SystemMouseCursors.click 
      : SystemMouseCursors.text);

  BorderRadius get borderRadius => widget.borderRadius ?? VTSFieldControlStyle.get('borderRadius');
  double get height => widget.height ?? VTSFieldControlStyle.get('height', selector: widget.vtsSize);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          width: 1,
          color: borderColor
        ),
        boxShadow: boxShadow,
      ),
      child: InkWell(
        hoverColor: VTSColors.TRANSPARENT,
        highlightColor: VTSColors.TRANSPARENT,
        splashColor: VTSColors.TRANSPARENT,
        focusColor: VTSColors.TRANSPARENT,
        onHover: _onHover,
        onTap: _onTap,
        mouseCursor: mouseCursor,
        borderRadius: borderRadius,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: background,
          ),
          child: TextField(
            readOnly: widget.readonly,
            controller: _textController,
            focusNode: _focusNode,
            onChanged: _onInput,
            mouseCursor: mouseCursor,
            onTap: _onTap, // onTap of Inkwell only trigger outside of textfield (like border..)
            onSubmitted: _onSubmit,
            style: textStyle,
            cursorColor: VTSColors.BLACK_1,
            cursorWidth: 1.0,
            textAlignVertical: TextAlignVertical.center,
            decoration: 
              InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.placeholder,
                // suffixIcon: widget.suffix,
                suffixIcon: 
                  widget.suffix != null
                  ? Container(
                    margin: const EdgeInsets.only(right: 12.0, left: 4.0),
                    child: widget.suffix
                  )
                  : null,
                suffixStyle: widget.suffixStyle,
                suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                prefixIcon:
                  widget.prefix != null
                  ? Container(
                    margin: const EdgeInsets.only(right: 4.0, left: 12.0),
                    child: widget.prefix
                  )
                  : null,
                prefixStyle: widget.prefixStyle,
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                hintStyle: hintTextStyle,
                contentPadding: VTSFieldControlStyle.get('padding', selector: widget.vtsSize),
              ),
          ),
        )
      )
    );

    return container;
  }
}
