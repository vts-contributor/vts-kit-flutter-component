import 'package:flutter/material.dart';
import 'package:vts_component/components/accordion/styles.dart';

class VTSAccordion extends StatefulWidget {
  /// An accordion is used to show (and hide) content. Use [showAccordion] to hide & show the accordion content.
  const VTSAccordion(
      {Key? key,

      this.title,
      this.titleText,
      this.titleBorder,
      this.titleBorderRadius,
      this.titlePadding,
      this.collapsedTitleTextStyle,
      this.expandedTitleTextStyle,
      this.collapsedTitleBackground,
      this.expandedTitleBackground,


      this.content,
      this.contentText,
      this.contentBorder,
      this.contentBorderRadius,
      this.contentPadding,
      this.contentBackground,
      this.contentTextStyle,

      this.margin,

      this.collapsedToggle,
      this.collapsedIcon,
      this.collapsedText,

      this.expandedToggle,
      this.expandedIcon,
      this.expandedText,


      this.showAccordion = false,
      this.onToggle,
    }) : super(key: key);

  /// Custom accordion's title
  /// [titleText] will be unused
  final Widget? title;

  /// Accordion's title using Text()
  final String? titleText;

  /// Title's border
  final Border? titleBorder;

  /// Title's border radius
  final BorderRadius? titleBorderRadius;

  /// Title's padding
  final EdgeInsetsGeometry? titlePadding;
  
  /// Title's text style on collapsed
  final TextStyle? collapsedTitleTextStyle;

  /// Title's text style on expanded
  final TextStyle? expandedTitleTextStyle;

  /// Title's background color on collapsed
  final Color? collapsedTitleBackground;

  /// Title's background color on expanded
  final Color? expandedTitleBackground;

  /// Custom accordion's content
  /// [contentText] will be unused
  final String? contentText;

  /// Accordion's content using Text()
  final Widget? content;

  /// Content's border
  final Border? contentBorder;

  /// Content's border radius
  final BorderRadius? contentBorderRadius;

  /// Content's padding
  final EdgeInsetsGeometry? contentPadding;

  /// Content's background color
  final Color? contentBackground;

  /// Content's text style
  final TextStyle? contentTextStyle;

  /// Accordion's margin
  final EdgeInsetsGeometry? margin;

  /// Toggle's widget on collapsed
  /// [collapsedText] and [collapsedIcon] will be unused
  final Widget? collapsedToggle;

  /// Toggle's widget on expanded
  /// [expandedText] and [expandedIcon] will be unused
  final Widget? expandedToggle;

  /// Toggle's widget on collapsed using Text()
  final String? collapsedText;

  /// Toggle's widget on expanded using Text()
  final String? expandedText;

  /// Toggle's widget on collapsed using Icon()
  final Icon? collapsedIcon;

  /// Toggle's widget on expanded using Icon()
  final Icon? expandedIcon;

  /// Whether to expand accordion
  final bool showAccordion;

  /// Trigger on arrcordion toggled
  final Function(bool)? onToggle;

  @override
  _VTSAccordionState createState() => _VTSAccordionState();
}

class _VTSAccordionState extends State<VTSAccordion>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController controller;
  late Animation<Offset> offset;
  late bool showAccordion;

  @override
  void initState() {
    showAccordion = widget.showAccordion;
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    offset = Tween(
      begin: const Offset(0, -0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget _iconToggle(Icon icon) 
    => IconTheme(
      data: IconThemeData(
        size: VTSAccordionStyle.get('toggleIconSize'),
        color: VTSAccordionStyle.get('toggleColor'),
      ),
      child: Container(child: icon),
    );

  Widget _textToggle(String text) 
    => DefaultTextStyle(
      style: VTSAccordionStyle.get('toggleTextStyle'),
      child: Container(child: Text(text)),
    );

  Widget buildToggle() {
    if (showAccordion) {
      return widget.expandedToggle
        ?? (widget.expandedIcon != null
            ? _iconToggle(widget.expandedIcon!)
            : null)
        ?? (widget.expandedText != null
            ? _textToggle(widget.expandedText!)
            : null)
        ?? _iconToggle(VTSAccordionStyle.get('expandedToggle'));
    } else {
      return widget.collapsedToggle
        ?? (widget.collapsedIcon != null
            ? _iconToggle(widget.collapsedIcon!)
            : null)
        ?? (widget.collapsedText != null
            ? _textToggle(widget.collapsedText!)
            : null)
        ?? _iconToggle(VTSAccordionStyle.get('collaspedToggle'));
    }
  }

  Widget buildTitle(BuildContext context) => InkWell(
    onTap: _toggleCollapsed,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: widget.titleBorderRadius ?? VTSAccordionStyle.get('titleBorderRadius'),
        border: widget.titleBorder ?? VTSAccordionStyle.get('titleBorder'),
        color: showAccordion
            ? widget.expandedTitleBackground ?? VTSAccordionStyle.get('expandedTitleBackground')
            : widget.collapsedTitleBackground ?? VTSAccordionStyle.get('collapsedTitleBackground'),
      ),
      padding: widget.titlePadding ?? VTSAccordionStyle.get('titlePadding'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DefaultTextStyle(
              style: 
                showAccordion 
                  ? widget.expandedTitleTextStyle ?? VTSAccordionStyle.get('expandedTitleTextStyle')
                  : widget.collapsedTitleTextStyle ?? VTSAccordionStyle.get('collapsedTitleTextStyle'),
              child: 
                widget.title
                ?? (widget.titleText != null
                  ? Text(widget.titleText!)
                  : const SizedBox.shrink())
            ),
          ),
          buildToggle()
        ],
      ),
    ),
  );

  Widget buildContent(BuildContext context) 
    =>  showAccordion
        ? Container(
            decoration: BoxDecoration(
              borderRadius: widget.contentBorderRadius ?? VTSAccordionStyle.get('contentBorderRadius'),
              border: widget.contentBorder ?? VTSAccordionStyle.get('contentBorder'),
              color: widget.contentBackground ?? VTSAccordionStyle.get('contentBackground'),
            ),
            width: MediaQuery.of(context).size.width,
            padding: widget.contentPadding ?? VTSAccordionStyle.get('contentPadding'),
            child: SlideTransition(
              position: offset,
              child: DefaultTextStyle(
                style: widget.contentTextStyle ?? VTSAccordionStyle.get('contentTextStyle'),
                child:
                  widget.content
                  ?? (widget.contentText != null
                    ? Text(widget.contentText!)
                    : const SizedBox.shrink()),
              )
            ))
        : const SizedBox.shrink();

  @override
  Widget build(BuildContext context) => Container(
        margin: widget.margin ?? VTSAccordionStyle.get('margin'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildTitle(context),
            buildContent(context)
          ],
        ),
      );

  void _toggleCollapsed() {
    setState(() {
      switch (controller.status) {
        case AnimationStatus.completed:
          controller.forward(from: 0);
          break;
        case AnimationStatus.dismissed:
          controller.forward();
          break;
        default:
      }
      showAccordion = !showAccordion;
      if (widget.onToggle != null) {
        widget.onToggle!(showAccordion);
      }
    });
  }
}
