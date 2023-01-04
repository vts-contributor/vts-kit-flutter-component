import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vts_component/components/toast/index.dart';
import 'package:vts_component/components/toast/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSToast extends StatefulWidget {
  const VTSToast({
    Key? key,
    this.vtsType = VTSToastType.STANDARD,

    this.child,
    this.text,
    this.fontColor,
    this.textStyle,

    this.width,
    this.background,
    this.boxDecoration,
    
    this.padding,
    this.margin,

    this.autoDismiss = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.appearDuration = const Duration(seconds: 0),
    this.dismissDuration = const Duration(seconds: 5),

    this.cancelButton,
    this.cancelText,
    this.cancelIcon,
    this.cancelFontColor
  }) : super(key: key);

  /// Custom toast's content
  /// Has priority over [text]
  final Widget? child;

  /// Toast's content in text
  final String? text;
  
  /// Custom content font color
  final Color? fontColor;

  /// Toast's background color
  final Color? background;

  /// Toast's content textStyle
  final TextStyle? textStyle;

  /// Toast's width
  final double? width;

  ///type of [VTSToastType] which takes the type ie, standard, rounded, full width
  final VTSToastType vtsType;

  /// Automatic hide toast
  final bool autoDismiss;

  /// Custom animation timing
  final Duration animationDuration;

  /// Use with [autoDismiss] to specify duration after which toast will be hided
  final Duration dismissDuration;

  /// Specify duration after which toast will be showed
  final Duration appearDuration;

  /// Toast's padding
  final EdgeInsetsGeometry? padding;

  /// Toast's margin
  final EdgeInsetsGeometry? margin;

  /// Toast's [boxDecoration]
  final Decoration? boxDecoration;

  /// Custom cancel widget
  /// Other cancel properties will be unused
  final Widget? cancelButton;

  /// Cancel button using text content 
  final String? cancelText;

  /// Cancel button using icon content 
  final Icon? cancelIcon;

  /// Custom cancelation text/icon font color
  final Color? cancelFontColor;

  @override
  _VTSToastState createState() => _VTSToastState();
}

class _VTSToastState extends State<VTSToast> with TickerProviderStateMixin {
  late AnimationController animationController, fadeAnimationController;
  late Animation<double> animation, fadeAnimation;
  Timer? timer;
  bool hideToast = false;

  @override
  void initState() {
    animationController =
        AnimationController(duration: widget.animationDuration, vsync: this);
    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    if (mounted) {
      animationController.addListener(() {
        if (fadeAnimation.isCompleted) {
          fadeAnimationController =
              AnimationController(duration: widget.animationDuration, vsync: this)
                ..addListener(() => setState(() {}));
          fadeAnimation = Tween<double>(
            begin: 0,
            end: 1,
          ).animate(fadeAnimationController);

          if (widget.autoDismiss) {
            timer = Timer(widget.dismissDuration, () {
              if (mounted) {
                fadeAnimationController.forward();
              }
            });
          }

          fadeAnimation = Tween<double>(
            begin: 1,
            end: 0,
          ).animate(fadeAnimationController);
          fadeAnimation.addStatusListener((AnimationStatus state) {
            if (fadeAnimation.isCompleted) {
              setState(() {
                hideToast = true;
              });
            }
          });
        }
      });
      
      timer = Timer(widget.appearDuration, () {
        if (mounted) {
          animationController.forward();
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    fadeAnimationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double getWidth() 
      => widget.vtsType == VTSToastType.FULL_WIDTH 
      ? MediaQuery.of(context).size.width
      : widget.width ?? MediaQuery.of(context).size.width * VTSToastStyle.get('toastWidthRatio');

    EdgeInsets? getPadding() => widget.padding ?? VTSToastStyle.get('padding');

    EdgeInsets? getMargin() 
      => widget.margin
      ?? (widget.vtsType == VTSToastType.FULL_WIDTH 
      ? const EdgeInsets.only(left: 0, right: 0) 
      : VTSToastStyle.get('margin'));

    Decoration? getBoxDecoration() 
      => widget.boxDecoration 
      ?? BoxDecoration(
        borderRadius: VTSToastStyle.get('borderRadius', selector: widget.vtsType),
        color: widget.background ?? VTSToastStyle.get('background'),
        boxShadow: VTSToastStyle.get('boxShadow'),
      );

    Widget? cancelWidget = const SizedBox.shrink();
    if (widget.cancelButton != null)
      cancelWidget = widget.cancelButton!;
    else if (widget.cancelText != null && widget.cancelIcon != null) {
      cancelWidget = VTSButton(
        text: widget.cancelText,
        icon: widget.cancelIcon,
        vtsType: VTSButtonType.TEXT,
        fontColor: widget.cancelFontColor ?? VTSToastStyle.get('cancelFontColor'),
        onPressed: () {fadeAnimationController.forward();},
      );
    }
    else if (widget.cancelText != null)
      cancelWidget = VTSButton(
        text: widget.cancelText,
        vtsType: VTSButtonType.TEXT,
        fontColor: widget.cancelFontColor ?? VTSToastStyle.get('cancelFontColor'),
        onPressed: () {fadeAnimationController.forward();},
      );
    else if (widget.cancelIcon != null)
      cancelWidget = VTSButton(
        icon: widget.cancelIcon,
        vtsType: VTSButtonType.TEXT,
        vtsSize: VTSButtonSize.MD,
        fontColor: widget.cancelFontColor ?? VTSToastStyle.get('cancelFontColor'),
        onPressed: () {fadeAnimationController.forward();},
      );

    return hideToast
      ? const SizedBox.shrink()
      : FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            children: <Widget>[
              Container(
                width: getWidth(),
                margin: getMargin(),
                padding: getPadding(),
                decoration: getBoxDecoration(),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: widget.child != null
                            ? widget.child
                            : DefaultTextStyle(
                                style: 
                                  widget.textStyle 
                                  ?? VTSToastStyle.get('textStyle')
                                    .merge(TextStyle(color: widget.fontColor ?? VTSToastStyle.get('fontColor'))), 
                                child: Text(widget.text!, style: widget.textStyle))
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    cancelWidget
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
