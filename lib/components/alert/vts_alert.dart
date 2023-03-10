import 'package:flutter/material.dart';
import 'package:vts_component/components/alert/typing.dart';

class VTSAlert extends StatefulWidget {
  const VTSAlert({
    Key? key,
    required this.title,
    this.icon,
    this.closeCustomIconButton,
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
    this.alertType,
    this.alignment,
    this.padding,
    this.shadow,
    this.border,
    this.borderRadius,
  }) : super(key: key);

  /// head icon
  final Icon? icon;

  // custom IconButton widget
  final IconButton? closeCustomIconButton;

  /// title of type [String] used to describe the title of the [VTSAlert]
  final String title;

  ///type of [TextStyle] to change the style of the title
  final TextStyle? titleTextStyle;

  /// type of [Alignment] used to align the title text inside the [VTSAlert]
  final Alignment? titleAlignment;

  /// title of type [String] used to describe the subtitle of the [VTSAlert]
  final String? subtitle;

  ///type of [TextStyle] to change the style of the subtitle
  final TextStyle? subtitleTextStyle;

  /// type of [Alignment] used to align the subtitle text inside the [VTSAlert]
  final Alignment? subtitleAlignment;

  /// topBar of  type [Widget] can be used to show a widget at the top of title.
  final Widget? topBar;

  /// type of [Alignment] used to align the topBar widget [VTSAlert]
  final Alignment? topBarAlignment;

  /// bottomBar of  type [Widget] can be used to show a widget at the bottom of subtitle.
  final Widget? bottomBar;

  /// type of [Alignment] used to align the bottom widget [VTSAlert]
  final Alignment? bottomBarAlignment;

  /// type of [List] of type [BoxShadow] to give shadow to [VTSAlert]
  final List<BoxShadow>? shadow;

  /// type of [EdgeInsetsGeometry] to give padding inside [VTSAlert]
  final EdgeInsetsGeometry? padding;

  /// type of [double] to give circular radius to [VTSAlert]
  final double? borderRadius;

  /// type of [BoxBorder]
  final BoxBorder? border;

  ///pass color of type [Color] or [ ] for background of [VTSAlert]
  final Color? backgroundColor;

  /// width of type [double] used to control the width of the [VTSAlert]
  final double? width;

  ///type of [VTSAlertWidgetType] which takes the type ie, basic, rounded and fullWidth for the [VTSAlert]
  final VTSAlertWidgetType widgetType;

  final VTSAlertType? alertType;

  /// type of [Alignment] used to align the [VTSAlert]
  final Alignment? alignment;

  @override
  _VTSAlertState createState() => _VTSAlertState();
}

class _VTSAlertState extends State<VTSAlert> with TickerProviderStateMixin {
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
                  border: _getBorder(widget.alertType, widget.border),
                  borderRadius: widget.widgetType == VTSAlertWidgetType.BASIC
                      ? BorderRadius.circular(3)
                      : widget.widgetType == VTSAlertWidgetType.ROUNDED
                          ? BorderRadius.circular(
                              widget.borderRadius ?? 10,
                            )
                          : BorderRadius.zero,
                  color: _getBackgroundColor(
                      widget.alertType, widget.backgroundColor),
                  boxShadow: widget.shadow ??
                      [
                        BoxShadow(
                          color: Colors.white.withOpacity(0),
                          offset: const Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 0,
                        )
                      ],
                ),
                child: ClipRRect(
                  borderRadius: widget.widgetType == VTSAlertWidgetType.ROUNDED
                      ? BorderRadius.circular(
                          widget.borderRadius ?? 10,
                        )
                      : BorderRadius.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getIcon(widget.alertType, widget.icon),
                      widget.icon != null || widget.alertType != null
                          ? const SizedBox(
                              width: 10,
                            )
                          : Container(),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment:
                                  widget.topBarAlignment ?? Alignment.center,
                              child: widget.topBar ?? Container(),
                            ),
                            Align(
                              alignment:
                                  widget.titleAlignment ?? Alignment.topLeft,
                              child: Text(
                                widget.title,
                                style: _getTitleTextStyle(
                                    widget.alertType, widget.titleTextStyle),
                              ),
                            ),
                            widget.subtitle != null
                                ? const SizedBox(
                                    height: 10,
                                  )
                                : Container(),
                            widget.subtitle != null
                                ? Align(
                                    alignment: widget.subtitleAlignment ??
                                        Alignment.topLeft,
                                    child: Text(
                                      widget.subtitle!,
                                      style: _getSubtitleTextStyle(
                                          widget.alertType,
                                          widget.subtitleTextStyle),
                                    ),
                                  )
                                : Container(),
                            widget.subtitle != null
                                ? const SizedBox(
                                    height: 10,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.closeCustomIconButton ?? Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Widget _getIcon(VTSAlertType? alertType, Icon? icon) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return const Icon(
          Icons.highlight_off,
          size: 30,
          color: Color.fromRGBO(203, 0, 43, 1),
        );
      case VTSAlertType.ERROR_OUTLINE:
        return const Icon(
          Icons.highlight_off,
          size: 30,
          color: Color.fromRGBO(203, 0, 43, 1),
        );
      case VTSAlertType.INFO_FILL:
        return const Icon(
          Icons.info_outline,
          size: 30,
          color: Color.fromRGBO(42, 177, 235, 1),
        );
      case VTSAlertType.INFO_OUTLINE:
        return const Icon(
          Icons.info_outline,
          size: 30,
          color: Color.fromRGBO(42, 177, 235, 1),
        );
      case VTSAlertType.SUCCESS_FILL:
        return const Icon(
          Icons.check_circle_outline_outlined,
          size: 30,
          color: Color.fromRGBO(0, 171, 118, 1),
        );
      case VTSAlertType.SUCCESS_OUTLINE:
        return const Icon(
          Icons.check_circle_outline_outlined,
          size: 30,
          color: Color.fromRGBO(0, 171, 118, 1),
        );
      case VTSAlertType.WARNING_FILL:
        return const Icon(
          Icons.warning_amber_outlined,
          size: 30,
          color: Color.fromRGBO(219, 168, 22, 1),
        );
      case VTSAlertType.WARNING_OUTLINE:
        return const Icon(
          Icons.warning_amber_outlined,
          size: 30,
          color: Color.fromRGBO(219, 168, 22, 1),
        );
      default:
        return icon ??
            const SizedBox(
              width: 20,
            );
    }
  }

  Color _getBackgroundColor(VTSAlertType? alertType, Color? backgroundColor) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return const Color.fromRGBO(255, 245, 246, 1);
      case VTSAlertType.ERROR_OUTLINE:
        return const Color.fromRGBO(255, 245, 246, 1);
      case VTSAlertType.INFO_FILL:
        return const Color.fromRGBO(232, 248, 255, 1);
      case VTSAlertType.INFO_OUTLINE:
        return const Color.fromRGBO(232, 248, 255, 1);
      case VTSAlertType.SUCCESS_FILL:
        return const Color.fromRGBO(229, 252, 242, 1);
      case VTSAlertType.SUCCESS_OUTLINE:
        return const Color.fromRGBO(229, 252, 242, 1);
      case VTSAlertType.WARNING_FILL:
        return const Color.fromRGBO(251, 246, 231, 1);
      case VTSAlertType.WARNING_OUTLINE:
        return const Color.fromRGBO(251, 246, 231, 1);
      default:
        return backgroundColor ?? Colors.white;
    }
  }

  TextStyle _getTitleTextStyle(
      VTSAlertType? alertType, TextStyle? titleTextStyle) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return const TextStyle(
            color: Color.fromRGBO(203, 0, 43, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      case VTSAlertType.ERROR_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(203, 0, 43, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      case VTSAlertType.INFO_FILL:
        return const TextStyle(
            color: Color.fromRGBO(42, 177, 235, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      case VTSAlertType.INFO_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(42, 177, 235, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      case VTSAlertType.SUCCESS_FILL:
        return const TextStyle(
            color: Color.fromRGBO(0, 171, 118, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      case VTSAlertType.SUCCESS_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(0, 171, 118, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      case VTSAlertType.WARNING_FILL:
        return const TextStyle(
            color: Color.fromRGBO(219, 168, 22, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      case VTSAlertType.WARNING_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(219, 168, 22, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700);
      default:
        return titleTextStyle ??
            const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            );
    }
  }

  TextStyle _getSubtitleTextStyle(
      VTSAlertType? alertType, TextStyle? subtitleTextStyle) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return const TextStyle(
            color: Color.fromRGBO(203, 0, 43, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      case VTSAlertType.ERROR_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(203, 0, 43, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      case VTSAlertType.INFO_FILL:
        return const TextStyle(
            color: Color.fromRGBO(42, 177, 235, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      case VTSAlertType.INFO_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(42, 177, 235, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      case VTSAlertType.SUCCESS_FILL:
        return const TextStyle(
            color: Color.fromRGBO(42, 177, 235, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      case VTSAlertType.SUCCESS_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(0, 171, 118, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      case VTSAlertType.WARNING_FILL:
        return const TextStyle(
            color: Color.fromRGBO(219, 168, 22, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      case VTSAlertType.WARNING_OUTLINE:
        return const TextStyle(
            color: Color.fromRGBO(219, 168, 22, 1),
            fontSize: 17,
            fontWeight: FontWeight.w400);
      default:
        return subtitleTextStyle ??
            const TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            );
    }
  }

  BoxBorder _getBorder(VTSAlertType? alertType, BoxBorder? border) {
    switch (alertType) {
      case VTSAlertType.ERROR_FILL:
        return Border.all(color: const Color.fromRGBO(239, 112, 138, 1));
      case VTSAlertType.ERROR_OUTLINE:
        return Border.all(color: const Color.fromRGBO(239, 112, 138, 1));
      case VTSAlertType.INFO_FILL:
        return Border.all(color: const Color.fromRGBO(42, 177, 235, 1));
      case VTSAlertType.INFO_OUTLINE:
        return Border.all(color: const Color.fromRGBO(42, 177, 235, 1));
      case VTSAlertType.SUCCESS_FILL:
        return Border.all(color: const Color.fromRGBO(0, 171, 118, 1));
      case VTSAlertType.SUCCESS_OUTLINE:
        return Border.all(color: const Color.fromRGBO(0, 171, 118, 1));
      case VTSAlertType.WARNING_FILL:
        return Border.all(color: const Color.fromRGBO(219, 168, 22, 1));
      case VTSAlertType.WARNING_OUTLINE:
        return Border.all(color: const Color.fromRGBO(219, 168, 22, 1));
      default:
        return border ?? Border.all(color: Colors.black);
    }
  }
}
