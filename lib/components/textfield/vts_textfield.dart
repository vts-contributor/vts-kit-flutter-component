import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vts_component/components/base/field_control/typings.dart';

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
      this.hintColor,
      this.borderColor = const Color(0xFF8F9294),
      this.errorColor = const Color(0xFFEE0033),
      this.contentPadding,
      this.inputLabel,
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

  final Color? hintColor;
  final Color? borderColor;
  final Color? errorColor;
  final EdgeInsetsGeometry? contentPadding;
  final String? inputLabel;
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

  late VTSFieldControlStateStyle<Color> backgrounds;
  late VTSFieldControlStateStyle<TextStyle> textStyles;
  late VTSFieldControlStateStyle<Color> borderColors;
  @override
  void initState() {
    super.initState();
    currentColor = widget.borderColor;
    backgrounds = VTSFieldControlStateStyle();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hasLabelText
              ? Text(
                  widget.inputLabel ?? 'Input Label',
                  style: widget.labelStyle ??
                      TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: widget.enable
                              ? Color(0xFF000000)
                              : Color(0xFF8F9294)),
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
                    hintStyle: TextStyle(
                      color: widget.hintColor ?? Color(0xFF8F9294),
                      fontWeight: FontWeight.w300,
                    ),
                    filled: true,
                    fillColor: widget.enable
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFFE9E9E9),
                    contentPadding: widget.contentPadding ??
                        const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                    // errorText: "Error Message",
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide:
                          BorderSide(color: Color(0xFF8F9294), width: 1.0),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0)),
                      borderSide: BorderSide(
                        color: onError
                            ? const Color(0xFFEE0033)
                            : const Color(0xFF44494D),
                        width: 1.0,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide:
                          BorderSide(color: Color(0xFFEE0033), width: 1.0),
                    ),
                    errorStyle: const TextStyle(fontSize: 16),
                    hintText: widget.hintText,
                  ),
              keyboardType: widget.keyboardType ?? TextInputType.text,
              textCapitalization: widget.textCapitalization,
              textInputAction: widget.textInputAction,
              style: widget.style ??
                  const TextStyle(
                      decoration: TextDecoration.none, fontSize: 16),
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
                    setState(() {
                      if (value == null || value.trim().isEmpty) {
                        onError = true;
                      } else {
                        onError = false;
                      }
                      return;
                    });
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
              ? const Text(
                  'Error Message',
                  style: TextStyle(color: Color(0xFFEE0033), fontSize: 16.0),
                )
              : const SizedBox()
        ],
      );
}
