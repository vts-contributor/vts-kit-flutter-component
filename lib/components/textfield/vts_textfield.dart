import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:vts_component/components/textfield/index.dart';
import 'package:vts_component/components/textfield/styles.dart';

class VTSTextField extends StatefulWidget {
  const VTSTextField(
      {Key? key,
      required this.keyVTS,
      this.controller,
      this.initialValue,
      this.focusNode,
      this.decoration,
      this.keyboardType = TextInputType.text,
      this.textCapitalization = TextCapitalization.none,
      this.textInputAction,
      this.style,
      this.strutStyle,
      this.textDirection,
      this.textAlign = TextAlign.start,
      this.textAlignVertical,
      this.autofocus = false,
      this.readOnly = false,
      this.toolbarOptions,
      this.showCursor,
      this.obscuringCharacter = '•',
      this.obscureText = false,
      this.autocorrect = true,
      this.smartDashesType,
      this.smartQuotesType,
      this.enableSuggestions = true,
      this.maxLengthEnforcement,
      this.maxLines = 1,
      this.minLines,
      this.expands = false,
      this.maxLength,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onSaved,
      this.validator,
      this.inputFormatters,
      this.enabled,
      this.cursorWidth = 2.0,
      this.cursorHeight,
      this.cursorRadius,
      this.cursorColor,
      this.keyboardAppearance,
      this.scrollPadding = const EdgeInsets.all(20.0),
      this.enableInteractiveSelection,
      this.selectionControls,
      this.buildCounter,
      this.scrollPhysics,
      this.autofillHints,
      this.autovalidateMode,
      this.scrollController,
      this.restorationId,
      this.enableIMEPersonalizedLearning = true,
      this.mouseCursor,
      this.hintText,
      this.borderColor = const Color(0xFF8F9294),
      this.errorColor = const Color(0xFFEE0033),
      this.contentPadding,
      this.inputLabel = 'Input Label',
      this.labelStyle,
      this.hasLabelText = true,
      this.enable = true})
      : super(key: key);

  final GlobalKey<FormState>? keyVTS;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;

  final String? hintText;
  final Color? borderColor;
  final Color? errorColor;
  final EdgeInsetsGeometry? contentPadding;
  final String inputLabel;
  final TextStyle? labelStyle;
  final bool hasLabelText;
  final bool enable;

  _VTSTextFieldState createState() => _VTSTextFieldState();
}

class _VTSTextFieldState extends State<VTSTextField> {
  Color? currentColor;
  TextEditingController controller = TextEditingController();
  String? errorMessage = '';
  bool onError = false;

  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hasLabelText
              ? Text(
                  widget.inputLabel,
                  style: widget.labelStyle ??
                      TextStyle(
                        fontSize: VTSTextFieldStyle.get('fontSize'),
                        fontWeight: VTSTextFieldStyle.get('fontWeight'),
                        fontFamily: VTSTextFieldStyle.get('fontFamily'),
                        color: widget.enable
                            ? VTSTextFieldStyle.get('labelTextColor',
                                selector: VTSTextFieldState.DEFAULT)
                            : VTSTextFieldStyle.get('labelTextColor',
                                selector: VTSTextFieldState.DISABLE),
                      ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 4.0,
          ),
          Form(
            key: widget.keyVTS,
            child: TextFormField(
              controller: widget.controller ?? controller,
              initialValue: widget.initialValue,
              focusNode: widget.focusNode,
              decoration: widget.decoration ??
                  InputDecoration(
                    filled: true,
                    fillColor: widget.enable
                        ? VTSTextFieldStyle.get('background',
                            selector: VTSTextFieldState.DEFAULT)
                        : VTSTextFieldStyle.get('background',
                            selector: VTSTextFieldState.DISABLE),
                    contentPadding: widget.contentPadding ??
                        VTSTextFieldStyle.get('contentPadding'),
                    // errorText: "Error Message",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: VTSTextFieldStyle.get('borderRadius'),
                      borderSide: BorderSide(
                        color: onError
                            ? VTSTextFieldStyle.get('borderColor',
                                selector: VTSTextFieldState.ERROR)
                            : VTSTextFieldStyle.get('borderColor',
                                selector: VTSTextFieldState.DEFAULT),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: VTSTextFieldStyle.get('borderRadius'),
                      borderSide: BorderSide(
                          color: VTSTextFieldStyle.get('borderColor',
                              selector: VTSTextFieldState.DISABLE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: VTSTextFieldStyle.get('borderRadius'),
                      borderSide: BorderSide(
                        color: VTSTextFieldStyle.get('borderColor',
                            selector: VTSTextFieldState.DEFAULT),
                      ),
                    ),
                    errorStyle:
                        TextStyle(fontSize: VTSTextFieldStyle.get('fontSize')),
                    hintText: widget.hintText,
                  ),
              keyboardType: widget.keyboardType ?? TextInputType.text,
              textCapitalization: widget.textCapitalization,
              textInputAction: widget.textInputAction,
              style: widget.style ??
                  TextStyle(fontSize: VTSTextFieldStyle.get('fontSize')),
              strutStyle: widget.strutStyle,
              textDirection: widget.textDirection,
              textAlign: widget.textAlign,
              textAlignVertical: widget.textAlignVertical,
              autofocus: widget.autofocus,
              readOnly: widget.readOnly,
              toolbarOptions: widget.toolbarOptions,
              showCursor: widget.showCursor,
              obscuringCharacter: widget.obscuringCharacter,
              obscureText: widget.obscureText,
              autocorrect: widget.autocorrect,
              smartDashesType: widget.smartDashesType,
              smartQuotesType: widget.smartQuotesType,
              enableSuggestions: widget.enableSuggestions,
              maxLengthEnforcement: widget.maxLengthEnforcement,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              expands: widget.expands,
              maxLength: widget.maxLength,
              onChanged: widget.onChanged ??
                  (text) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(text);
                    }
                  },
              onTap: widget.onTap,
              onEditingComplete: widget.onEditingComplete,
              onFieldSubmitted: widget.onFieldSubmitted,
              onSaved: widget.onSaved,
              validator: widget.validator ??
                  (value) {
                    SchedulerBinding.instance.addPostFrameCallback((_){setState(() {
                      if (value == null || value.trim().isEmpty) {
                        onError = true;
                      } else {
                        onError = false;
                      }
                      return;
                    });});

                  },
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              cursorWidth: widget.cursorWidth,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              cursorColor: widget.cursorColor,
              keyboardAppearance: widget.keyboardAppearance,
              scrollPadding: widget.scrollPadding,
              enableInteractiveSelection: widget.enableInteractiveSelection,
              selectionControls: widget.selectionControls,
              buildCounter: widget.buildCounter,
              scrollPhysics: widget.scrollPhysics,
              autofillHints: widget.autofillHints,
              autovalidateMode: widget.autovalidateMode,
              scrollController: widget.scrollController,
              restorationId: widget.restorationId,
              enableIMEPersonalizedLearning:
                  widget.enableIMEPersonalizedLearning,
              mouseCursor: widget.mouseCursor,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          onError
              ? Text(
                  'Error Message',
                  style: TextStyle(
                      color: VTSTextFieldStyle.get('errorMessageColor'),
                      fontSize: VTSTextFieldStyle.get('fontSize')),
                )
              : const SizedBox()
        ],
      );
}
