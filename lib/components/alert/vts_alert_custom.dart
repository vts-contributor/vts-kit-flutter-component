import 'package:flutter/material.dart';
import 'package:vts_component/components/alert/typing.dart';

class VTSAlertCustom extends StatefulWidget {
  /// Alert has to be wrap inside the body like [GFFloatingWidget]. See [GFFloatingWidget]
  const VTSAlertCustom({
    Key? key,
    this.showButton = true,
    required this.title,
    this.titleTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    this.titleAlignment,
    this.subtitle,
    this.subtitleTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    ),
    this.subtitleAlignment,
    this.topBar,
    this.topBarAlignment,
    this.bottomBar,
    this.bottomBarAlignment,
    this.backgroundColor,
    this.width,
    this.widgetType = VTSAlertWidgetType.ROUNDED,
    this.alignment,
    this.padding,
    this.shadow,
    this.borderRadius,
    this.closeButton,
    this.duration,
  }) : super(key: key);

  /// Show button or not, default is true
  final bool showButton;

  /// title of type [String] used to describe the title of the [VTSAlertCustom]
  final String title;

  ///type of [TextStyle] to change the style of the title
  final TextStyle titleTextStyle;

  /// type of [Alignment] used to align the title text inside the [VTSAlertCustom]
  final Alignment? titleAlignment;

  /// title of type [String] used to describe the subtitle of the [VTSAlertCustom]
  final String? subtitle;

  ///type of [TextStyle] to change the style of the subtitle
  final TextStyle subtitleTextStyle;

  /// type of [Alignment] used to align the subtitle text inside the [VTSAlertCustom]
  final Alignment? subtitleAlignment;

  /// topBar of  type [Widget] can be used to show a widget at the top of title.
  final Widget? topBar;

  /// type of [Alignment] used to align the topBar widget [VTSAlertCustom]
  final Alignment? topBarAlignment;

  /// bottomBar of  type [Widget] can be used to show a widget at the bottom of subtitle.
  final Widget? bottomBar;

  /// type of [Alignment] used to align the bottom widget [VTSAlertCustom]
  final Alignment? bottomBarAlignment;

  /// type of [List] of type [BoxShadow] to give shadow to [VTSAlertCustom]
  final List<BoxShadow>? shadow;

  /// type of [EdgeInsetsGeometry] to give padding inside [VTSAlertCustom]
  final EdgeInsetsGeometry? padding;

  /// type of [double] to give circular radius to [VTSAlertCustom]
  final double? borderRadius;

  ///pass color of type [Color] for background of [VTSAlertCustom]
  final Color? backgroundColor;

  /// width of type [double] used to control the width of the [VTSAlertCustom]
  final double? width;

  ///type of [VTSAlertWidgetType] which takes the type ie, basic, rounded and fullWidth for the [VTSAlertCustom]
  final VTSAlertWidgetType widgetType;

  /// type of [Alignment] used to align the [VTSAlertCustom]
  final Alignment? alignment;

  final ElevatedButton? closeButton;

  /// type of [Duration]
  final Duration? duration;

  @override
  _VTSAlertCustomState createState() => _VTSAlertCustomState();
}

class _VTSAlertCustomState extends State<VTSAlertCustom>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: animation,
        child: Column(
          children: <Widget>[
            Align(
              alignment: widget.alignment ?? Alignment.center,
              child: Container(
                width: widget.widgetType == VTSAlertWidgetType.FULLWIDTH
                    ? MediaQuery.of(context).size.width
                    : widget.width ?? MediaQuery.of(context).size.width * 0.885,
                constraints: const BoxConstraints(
                  minHeight: 50,
                ),
                margin: widget.widgetType == VTSAlertWidgetType.FULLWIDTH
                    ? const EdgeInsets.only(
                        left: 0,
                        right: 0,
                      )
                    : const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 20,
                      ),
                padding: widget.padding ??
                    const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 10,
                    ),
                decoration: BoxDecoration(
                  borderRadius: widget.widgetType == VTSAlertWidgetType.BASIC
                      ? BorderRadius.circular(3)
                      : widget.widgetType == VTSAlertWidgetType.ROUNDED
                          ? BorderRadius.circular(
                              widget.borderRadius ?? 10,
                            )
                          : BorderRadius.zero,
                  color: widget.backgroundColor ?? Colors.white, // fix this
                  boxShadow: widget.shadow ?? [],
                ),
                child: ClipRRect(
                  borderRadius: widget.widgetType == VTSAlertWidgetType.ROUNDED
                      ? BorderRadius.circular(
                          widget.borderRadius ?? 10,
                        )
                      : BorderRadius.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: widget.topBarAlignment ?? Alignment.center,
                        child: widget.topBar ?? Container(),
                      ),
                      Align(
                          alignment: widget.titleAlignment ?? Alignment.topLeft,
                          child: Text(
                            widget.title,
                            style: widget.titleTextStyle,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.subtitle != null
                          ? Align(
                              alignment:
                                  widget.subtitleAlignment ?? Alignment.topLeft,
                              child: Text(
                                widget.subtitle ?? 'SubTitle',
                                style: widget.subtitleTextStyle,
                              ))
                          : Container(),
                      widget.showButton
                          ? Align(
                              alignment: widget.bottomBarAlignment ??
                                  Alignment.bottomRight,
                              child: widget.bottomBar ?? Container(),
                            )
                          : Container(
                              height: 10,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
