import 'package:flutter/material.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/alert/styles.dart';
import 'package:vts_component/components/alert/typing.dart';

class VTSAlert extends StatefulWidget {
  const VTSAlert({
    Key? key,
    required this.title,
    this.icon,
    this.closeCustomIconButton,
    this.titleTextStyle = const TextStyle(
        color: VTSColors.BLACK_1,
        fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.5,
        overflow: TextOverflow.ellipsis),
    this.titleAlignment,
    this.subtitle,
    this.subtitleTextStyle = const TextStyle(
        color: VTSColors.BLACK_1,
        fontFamily: VTSCommon.DEFAULT_FONT_FAMILY,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5,
        overflow: TextOverflow.ellipsis),
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
    this.duration,
  }) : super(key: key);

  /// type of [Icon] used to show icon at the left side of the the [VTSAlert]
  final Icon? icon;

  /// type of [IconButton] used to show button with icon at the right side of the [VTSAlert]
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

  /// pass color of type [Color] for background of [VTSAlert]
  final Color? backgroundColor;

  /// width of type [double] used to control the width of the [VTSAlert]
  final double? width;

  ///type of [VTSAlertWidgetType] which takes the type ie, basic, rounded and fullWidth for the [VTSAlert]
  final VTSAlertWidgetType widgetType;

  /// type of [VTSAlertType] which take the alert's type ERROR_OUTLINE, ERROR_FILL, SUCCESS_OUTLINE, SUCCESS_FILL, WARNING_OULINE, WARNING_FILL, INFO_OUTLINE, INFO_FILL for the [VTSAlert], This will apply the template to the [VTSAlert] and cannot modify some features like Color, Icon, TextStyle,... If you want to customize  VTSAlert widget in your own way , please don't insert or comment this line of code.
  final VTSAlertType? alertType;

  /// type of [Alignment] used to align the [VTSAlert]
  final Alignment? alignment;

  /// type of [Duration]
  final Duration? duration;

  @override
  _VTSAlertState createState() => _VTSAlertState();
}

class _VTSAlertState extends State<VTSAlert> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: widget.duration ?? VTSCommon.ANIMATION_NORMAL_DURATION,
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
                  border: VTSAlertStyle()
                      .getBorder(widget.alertType, widget.border),
                  borderRadius: widget.widgetType == VTSAlertWidgetType.BASIC
                      ? BorderRadius.circular(3)
                      : widget.widgetType == VTSAlertWidgetType.ROUNDED
                          ? BorderRadius.circular(
                              widget.borderRadius ?? 10,
                            )
                          : BorderRadius.zero,
                  color: VTSAlertStyle().getBackgroundColor(
                      widget.alertType, widget.backgroundColor),
                  boxShadow: VTSAlertStyle()
                      .getListBoxShadow(widget.alertType, widget.shadow),
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
                      VTSAlertStyle().getIcon(widget.alertType, widget.icon),
                      widget.icon != null || widget.alertType != null
                          ? const SizedBox(
                              width: 15,
                            )
                          : Container(),
                      Expanded(
                        flex: 3,
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
                                style: VTSAlertStyle().getTitleTextStyle(
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
                                      style: VTSAlertStyle()
                                          .getSubtitleTextStyle(
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
}
