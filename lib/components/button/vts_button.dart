import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/button/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSButton extends StatefulWidget {
  const VTSButton({
    Key? key,
    required this.onPressed,
    this.onHighlightChanged,
    this.elevation = 0.0,
    this.focusElevation = 4.0,
    this.hoverElevation = 4.0,
    this.highlightElevation = 1.0,
    this.disabledElevation = 0.0,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.child,
    this.vtsType = VTSButtonType.PRIMARY,
    this.vtsShape = VTSButtonShape.STANDARD,
    this.vtsSize = VTSButtonSize.MD,
    this.text,
    this.icon,
    this.blockButton,
    this.onLongPress,
    this.enabled = true,
    this.textStyle,
    this.background,
    this.fontColor,
    this.highlightColor,
    this.splashColor,
    this.border,
    this.boxDecoration,
    this.boxConstraints,
    this.width,
    this.height
  })  : assert(focusElevation >= 0.0),
        assert(hoverElevation >= 0.0),
        assert(highlightElevation >= 0.0),
        assert(disabledElevation >= 0.0),
        super(key: key);

  /// Whether the button is enabled or disabled.
  final bool enabled;

  /// Button type of [VTSButtonType] i.e, primary, secondary, link, text
  final VTSButtonType vtsType;

  /// Button type of [VTSButtonShape] i.e, standard, pill, circle
  final VTSButtonShape vtsShape;

  /// Button type of [VTSButtonSize] i.e, sm, md, (lg for iconOnly)
  final VTSButtonSize vtsSize;

  /// Typically the button's label.
  final Widget? child;

  /// text of type [String] is alternative to child. text will get priority over child
  final String? text;

  /// icon of type [Widget]
  final Icon? icon;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// The elevation for the button's [Material] when the button is [enabled] but not pressed.
  final double elevation;

  /// The elevation for the button's [Material] when the button is [enabled] and a pointer is hovering over it.
  final double hoverElevation;

  /// The elevation for the button's [Material] when the button is [enabled] and has the input focus.
  final double focusElevation;

  /// The elevation for the button's [Material] when the button is [enabled] and pressed.
  final double highlightElevation;

  /// The elevation for the button's [Material] when the button is not [enabled].
  final double disabledElevation;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// Called by the underlying [InkWell] widget's InkWell.onHighlightChanged callback.
  final ValueChanged<bool>? onHighlightChanged;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Properties to Override preset
  /// {@macro flutter.widgets.Clip}
  final Clip clipBehavior;
  
  /// on true state blockButton gives block size button
  final bool? blockButton;

  /// Override [textStyle] preset
  final TextStyle? textStyle;

  /// Override [color] preset
  final Color? background;

  /// Override [textStyle]'s font color preset
  final Color? fontColor;

  /// Override [highlightColor] preset
  final Color? highlightColor;
  
  /// Override [splashColor] preset
  final Color? splashColor;

  /// Override [border] preset
  final ShapeBorder? border;

  /// Override [boxDecoration] preset
  final Decoration? boxDecoration;
  
  /// Override [boxConstraints] preset
  final BoxConstraints? boxConstraints;
  
  /// Override [width] preset
  final double? width;
  
  /// Override [height] preset
  final double? height;

  @override
  _VTSButtonState createState() => _VTSButtonState();
}

class _VTSButtonState extends State<VTSButton> {
  Widget? child;
  Widget? icon;
  Function? onPressed;
  late VTSButtonSize vtsSize;
  late bool iconOnly;
  FocusNode? focusNode;

  final Set<VTSButtonState> _states = <VTSButtonState>{};

  @override
  void initState() {
    child = widget.text != null ? Text(widget.text!) : widget.child;
    icon = widget.icon;
    onPressed = widget.onPressed;
    focusNode = widget.focusNode ?? new FocusNode();
    iconOnly = icon != null && widget.text == null && widget.child == null;
    vtsSize = 
      (widget.vtsType == VTSButtonType.LINK || widget.vtsType == VTSButtonType.TEXT)
        ? iconOnly ? widget.vtsSize : VTSButtonSize.SM 
        : widget.vtsSize == VTSButtonSize.LG && !iconOnly 
          ? VTSButtonSize.MD 
          : widget.vtsSize;
    _updateState(
      VTSButtonState.DISABLE,
      !widget.enabled,
    );
    super.initState();
  }

  bool get _hovered => _states.contains(VTSButtonState.HOVER);
  bool get _focused => _states.contains(VTSButtonState.FOCUS);
  bool get _active => _states.contains(VTSButtonState.ACTIVE);
  bool get _disabled => _states.contains(VTSButtonState.DISABLE);

  VTSButtonState get _highPriorityState {
    // The highest state, will be used to determine some styles
    if (_disabled) {
      return VTSButtonState.DISABLE;
    }
    if (_active) {
      return VTSButtonState.ACTIVE;
    }
    if (_focused) {
      return VTSButtonState.FOCUS;
    }
    if (_hovered) {
      return VTSButtonState.HOVER;
    }
    return VTSButtonState.DEFAULT;
  }

  void _updateState(VTSButtonState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  void _handleHighlightChanged(bool value) {
    if (_active != value) {
      setState(() {
        _updateState(VTSButtonState.ACTIVE, value);
        if (widget.onHighlightChanged != null) {
          widget.onHighlightChanged!(value);
        }
      });
    }
  }

  void _handleHoveredChanged(bool value) {
    if (_hovered != value) {
      setState(() {
        _updateState(VTSButtonState.HOVER, value);
      });
    }
  }

  void _handleFocusedChanged(bool value) {
    if (_focused != value) {
      setState(() {
        _updateState(VTSButtonState.FOCUS, value);
      });
    }
  }

  void _handleOnTap() {
    focusNode?.requestFocus();
    onPressed != null && widget.enabled ? onPressed!() : null;
  }

  @override
  void didUpdateWidget(VTSButton oldWidget) {
    _updateState(VTSButtonState.DISABLE, !widget.enabled);
    // If the button is disabled while a press gesture is currently ongoing,
    // InkWell makes a call to handleHighlightChanged. This causes an exception
    // because it calls setState in the middle of a build. To preempt this, we
    // manually update pressed to false when this situation occurs.
    if (_disabled && _active) {
      _handleHighlightChanged(false);
    }
    child = widget.text != null ? Text(widget.text!) : widget.child;
    icon = widget.icon;
    onPressed = widget.onPressed;
    focusNode = widget.focusNode ?? new FocusNode();
    iconOnly = icon != null && widget.text == null && widget.child == null;
    vtsSize = 
      (widget.vtsType == VTSButtonType.LINK || widget.vtsType == VTSButtonType.TEXT)
        ? iconOnly ? widget.vtsSize : VTSButtonSize.SM 
        : widget.vtsSize == VTSButtonSize.LG && !iconOnly 
          ? VTSButtonSize.MD 
          : widget.vtsSize;
    super.didUpdateWidget(oldWidget);
  }

  double get _effectiveElevation {
    // These conditionals are in order of precedence, so be careful about
    // reorganizing them.
    if (_disabled) {
      return widget.disabledElevation;
    }
    if (_active) {
      return widget.highlightElevation;
    }
    if (_hovered) {
      return widget.hoverElevation;
    }
    if (_focused) {
      return widget.focusElevation;
    }
    return widget.elevation;
  }

  dynamic getStyle(
    String key, 
    List<Object> extra
  ) => VTSButtonStyle.get(key, iconOnly, extra: extra);

  dynamic getStyleAppendHasIcon(
    String key, 
    List<Object> extra
  ) => VTSButtonStyle.getAppendHasIcon(key, iconOnly, widget.icon != null, extra: extra);

  Color get borderColor => widget.background != null ? VTSColors.TRANSPARENT : getStyle('color', [widget.vtsType, _highPriorityState, 'borderColor']);
  Color get background => widget.background ?? getStyle('color', [widget.vtsType, _highPriorityState, 'background']);
  Color get fontColor => widget.fontColor ?? getStyle('color', [widget.vtsType, _highPriorityState, 'fontColor']);
  TextDecoration? get textDecoration => getStyle('textDecoration', [widget.vtsType, _highPriorityState]);
  Color get highlightColor => background;
  TextStyle get textStyle => widget.textStyle ?? TextStyle(
    color: fontColor,
    fontSize: getStyle('fontSize', [vtsSize]),
    fontWeight: getStyle('fontWeight', [widget.vtsType]),
    decoration: textDecoration,
    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY
  );
  double get height => getStyle('height', [vtsSize]);
  double? get width => iconOnly ? height : widget.blockButton == true ? MediaQuery.of(context).size.width : null;
  BoxConstraints? get boxConstraints => getStyleAppendHasIcon('boxConstrains', []);
  EdgeInsetsGeometry? get padding => getStyle('padding', [widget.vtsShape]) ?? getStyleAppendHasIcon('padding', [vtsSize]);
  Color get iconFontColor => fontColor;
  double get iconFontSize {
    if (!iconOnly)
      return getStyle('iconFontSize', [vtsSize]);
    else
      return widget.vtsType != VTSButtonType.TEXT ? getStyle('iconFontSize', [vtsSize]) : height;
  }
  BorderRadius get borderRadius => getStyle('borderRadius', [widget.vtsShape]);
  ShapeBorder getBorder() {
    final outlineBorder = RoundedRectangleBorder(
      borderRadius: borderRadius,
      side: BorderSide(color: borderColor, width: 1)
    );

    if (_focused) {
      final extraBorder = RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: const BorderSide(color: VTSColors.WHITE_1, width: 1)
      );
      return extraBorder + outlineBorder;
    }
    return outlineBorder;
  }
  BoxDecoration? get boxDecoration => 
    _hovered && !_disabled 
      ? BoxDecoration( 
          boxShadow: const [VTSCommon.BLUR3_X0_Y1],
          borderRadius: borderRadius
        ) 
      : null;


  Widget? renderBody() {
    if (iconOnly) {
      return icon;
    }
    return icon != null 
      && child != null 
    ? Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon!,
        const SizedBox(width: 8),
        child!
      ],
    )
    : child;
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (widget.vtsType == VTSButtonType.LINK || widget.vtsType == VTSButtonType.TEXT) {
      result = Container(
        child: Material(
          textStyle: textStyle,
          clipBehavior: widget.clipBehavior,
          color: VTSColors.TRANSPARENT,
          child: InkWell(
            onHover: _handleHoveredChanged,
            onTap: _handleOnTap,
            onLongPress: widget.onLongPress,
            onHighlightChanged: _handleHighlightChanged,
            hoverColor: VTSColors.TRANSPARENT,
            focusColor: VTSColors.TRANSPARENT,
            highlightColor: VTSColors.TRANSPARENT,
            splashColor: VTSColors.TRANSPARENT,
            child: IconTheme.merge(
              data: IconThemeData(color: iconFontColor, size: iconFontSize),
              child: Container(
                child: Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: renderBody()
                ),
              ),
            ),
          )
        )
      );
    } else {
      result = Container(
        constraints: widget.boxConstraints ?? boxConstraints,
        decoration: widget.boxDecoration ?? boxDecoration,
        child: Material(
          elevation: _effectiveElevation,
          textStyle: textStyle,
          shape: widget.border ?? getBorder(),
          color: background,
          type: MaterialType.button,
          clipBehavior: widget.clipBehavior,
          child: InkWell(
            hoverColor: widget.background != null ? null : VTSColors.TRANSPARENT,
            focusColor: widget.background != null ? null : VTSColors.TRANSPARENT,
            splashColor: _disabled ? VTSColors.TRANSPARENT : widget.splashColor ?? VTSCommon.SPLASH_COLOR,
            highlightColor: widget.background != null ? (widget.highlightColor != null ? widget.highlightColor : null) : highlightColor,
            canRequestFocus: widget.enabled,
            onHighlightChanged: _handleHighlightChanged,
            onHover: _handleHoveredChanged,
            onTap: _handleOnTap,
            onLongPress: widget.onLongPress,
            customBorder: widget.border ?? getBorder(),
            child: IconTheme.merge(
              data: IconThemeData(color: iconFontColor, size: iconFontSize),
              child: Container(
                height: widget.height ?? height,
                width: widget.width ?? width,
                padding: padding,
                child: Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: renderBody()
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: _InputPadding(
        minSize: Size.zero,
        child: Focus(
          focusNode: focusNode,
          onFocusChange: _handleFocusedChanged,
          autofocus: widget.autofocus,
          child: result,
          canRequestFocus: widget.enabled,
        ),
      ),
    );
  }
}

/// A widget to pad the area around a [MaterialButton]'s inner [Material].
///
/// Redirect taps that occur in the padded area around the child to the center
/// of the child. This increases the size of the button and the button's
/// "tap target", but not its material or its ink splashes.
class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({
    Key? key,
    Widget? child,
    this.minSize,
  }) : super(
          key: key,
          child: child,
        );

  final Size? minSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderInputPadding(minSize);

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox? child]) : super(child);

  Size? get minSize => _minSize;
  Size? _minSize;

  set minSize(Size? value) {
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null && minSize != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize!.width);
    }
    return 0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null && minSize != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize!.height);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null && minSize != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize!.width);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null && minSize != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize!.height);
    }
    return 0;
  }

  @override
  void performLayout() {
    if (child != null && minSize != null) {
      child!.layout(constraints, parentUsesSize: true);
      // ignore: avoid_as
      final BoxParentData childParentData = child!.parentData as BoxParentData;
      final double height = math.max(child!.size.width, minSize!.width);
      final double width = math.max(child!.size.height, minSize!.height);
      size = constraints.constrain(Size(height, width));
      childParentData.offset =
          // ignore: avoid_as
          Alignment.center.alongOffset(size - child!.size as Offset);
    } else {
      size = Size.zero;
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }

    if (child != null) {
      final Offset center = child!.size.center(Offset.zero);
      return result.addWithRawTransform(
        transform: MatrixUtils.forceToPoint(center),
        position: center,
        hitTest: (BoxHitTestResult result, Offset position) {
          assert(position == center);
          return child!.hitTest(
            result,
            position: center,
          );
        },
      );
    }

    throw Exception('child property cannot be null');
  }
}
