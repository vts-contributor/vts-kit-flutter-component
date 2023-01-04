import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:vts_component/components/tabs/styles.dart';
import 'package:vts_component/components/tabs/typings.dart';
import 'package:vts_component/vts_component.dart';

class VTSTabBar extends StatefulWidget {
  const VTSTabBar({
    Key? key,
    required this.vtsType,
    required this.content,
    required this.tabController,
    this.height,
    this.background,
    this.indicatorColor,
    this.indicatorWeight,
    this.indicator,
    this.labelPadding,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.onTabChange,
    this.isScrollable = false,
    this.scrollStretchWidth = true,
    this.itemPadding
  }) : super(key: key);
 
  /// Tab type of [VTSTabType] i.e, segment, topbar, bottombar
  final VTSTabType vtsType;

  /// This widget's selection and animation state.
  final TabController? tabController;

  /// Tab title content, list of type [VTSTabItem]
  final List<VTSTabItem> content;
  
  /// Determine if tabbar is scrollable
  /// 
  /// By default, tabbar is unscrollable,
  /// all items use stretch width.
  /// If [isScrollable] enabled, 
  /// all items use min width, except using [scrollStretchWidth] 
  /// consider adding [itemPadding] or [labelPadding] for controlling item width.
  final bool isScrollable;

  /// Make item when using [isScrollable] to use strech width
  final bool scrollStretchWidth;

  /// Sets tab height
  final double? height;

  /// Tabbar background
  final Color? background;

  /// Defines the appearance of the selected tab indicator.
  final Decoration? indicator;

  /// The color of the line that appears below the selected tab.
  final Color? indicatorColor;

  /// The thickness of the line that appears below the selected tab.
  final double? indicatorWeight;

  /// The color of selected tab labels.
  final Color? labelColor;

  /// The color of unselected tab labels.
  final Color? unselectedLabelColor;

  /// The text style of the selected tab labels.
  final TextStyle? labelStyle;

  /// The text style of the unselected tab labels
  final TextStyle? unselectedLabelStyle;

  /// The padding added to each of the tab labels.
  /// Padding won't expand indicator's width
  final EdgeInsetsGeometry? labelPadding;

  /// The padding added to each of the tab labels.
  /// Padding expand indicator's width as well
  final EdgeInsets? itemPadding;

  /// Trigger on tabbar tap
  final void Function(int)? onTabChange;

  @override
  _VTSTabBarState createState() => _VTSTabBarState();
}

class _VTSTabBarState extends State<VTSTabBar> {
  late int selectedIndex = 0;
  late bool isTextOnly = false;
  late bool isIconOnly = false;
  late bool isHybrid = false;
  late bool isSingleRow = false;

  DragStartBehavior dragStartBehavior = DragStartBehavior.start;

  @override
  void initState() {
    isTextOnly = widget.content.where((item) => item.text != null && item.icon == null).length == widget.content.length;
    isIconOnly = widget.content.where((item) => item.text == null && item.icon != null).length == widget.content.length;
    isHybrid = !isTextOnly && !isIconOnly;
    isSingleRow = widget.content.where((item) => (item.text == null && item.icon != null) || (item.text != null && item.icon == null)).length == widget.content.length;
    
    widget.tabController!.addListener(() {
      _handleSelectedChange(widget.tabController!.index);
    });

    super.initState();
  }

  List<Widget> buildSegment(Map<int, VTSTabItem> map) {
    final List<Widget> result = [];
    final isFirst = (index) => index == 0;
    map.forEach((index, item) => { 
      result.add(
        Tab(
          child: Container(
            width: widget.isScrollable ? null : double.infinity,
            padding: 
              widget.itemPadding 
              ?? EdgeInsets.symmetric(horizontal: VTSTabStyle.get('itemPadding', widget.vtsType)),
            decoration: BoxDecoration(
              color: VTSColors.TRANSPARENT,
              border: !isFirst(index) && index != selectedIndex && index != selectedIndex + 1
                ? const Border(
                  left: BorderSide(
                    color: VTSColors.ILUS_GRAY_1,
                    width: 1,
                  ),
                )
                : null,
            ),
            child: Text(
              item.text ?? '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      )
    });
    return result;
  }

  List<Widget> buildFixedLabeled(Map<int, VTSTabItem> map) {
    final List<Widget> result = [];
    map.forEach((index, item) => {
      result.add(
        Tab(
          height: 
            widget.height
            ?? VTSTabStyle.get('height', widget.vtsType, extra: [isSingleRow ? 'single' : 'multi']),
          iconMargin: EdgeInsets.zero,
          child: Container(
            constraints: widget.isScrollable && widget.scrollStretchWidth ? BoxConstraints(minWidth: MediaQuery.of(context).size.width / map.length) : null,
            padding: 
              widget.itemPadding 
              ?? EdgeInsets.symmetric(horizontal: VTSTabStyle.get('itemPadding', widget.vtsType)),
            child: IconTheme.merge(
              data: IconThemeData(            
                size: VTSTabStyle.get('iconFontSize', widget.vtsType)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: widget.isScrollable ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
                children: [
                  item.icon ?? const SizedBox.shrink(),
                  item.icon != null && item.text != null 
                    ? SizedBox(height: VTSTabStyle.get('iconMargin', widget.vtsType)) 
                    : const SizedBox.shrink(),
                  item.text != null 
                    ? Text(
                      item.text!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ) : const SizedBox.shrink()
                ],
              ),
            )
          )
        )
      )
    });
    return result;
  }

  List<Widget> getTabRender() {
    final widgetMap = widget.content.asMap();
    switch (widget.vtsType) {
      case VTSTabType.SEGMENT:
        return buildSegment(widgetMap);
      case VTSTabType.TOPBAR:
        return buildFixedLabeled(widgetMap);
      case VTSTabType.BOTTOMBAR:
        return buildFixedLabeled(widgetMap);
    }
  }

  void _handleSelectedChange(int index) {
    setState(() => selectedIndex = index);
    if (widget.onTabChange != null) {
      widget.onTabChange!(index);
    }
  }

  @override
  Widget build(BuildContext context) =>
    Container(
      width: widget.isScrollable ? null : MediaQuery.of(context).size.width,
      height: 
        widget.height
        ?? VTSTabStyle.get('height', widget.vtsType, extra: [isSingleRow ? 'single' : 'multi']),
      decoration: BoxDecoration(
        border: VTSTabStyle.get('border', widget.vtsType),
        borderRadius: VTSTabStyle.get('borderRadius', widget.vtsType),
      ),
      child: DefaultTabController(
        // initialIndex: widget.initialIndex,
        length: widget.content.length,
        child: Material(
          borderRadius: VTSTabStyle.get('borderRadius', widget.vtsType),
          type: MaterialType.button,
          color: widget.background
            ?? VTSTabStyle.get('background', widget.vtsType),
          child: TabBar(
            isScrollable: widget.isScrollable,
            tabs: getTabRender(),
            // onTabChange: _handleSelectedChange,
            controller: widget.tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: VTSTabStyle.get('indicatorPadding', widget.vtsType),
            labelColor: 
              widget.labelColor
              ?? VTSTabStyle.get('selectedFontColor', widget.vtsType),
            unselectedLabelColor: 
              widget.unselectedLabelColor
              ?? VTSTabStyle.get('fontColor', widget.vtsType),
            labelStyle: 
              widget.labelStyle
              ?? VTSTabStyle.get('labelStyle', widget.vtsType),
            unselectedLabelStyle: 
              widget.unselectedLabelStyle
              ?? VTSTabStyle.get('unselectedLabelStyle', widget.vtsType),
            labelPadding: 
              widget.labelPadding
              ?? VTSTabStyle.get('labelPadding', widget.vtsType),
            indicator: 
              widget.indicator
              ?? VTSTabStyle.get('indicator', widget.vtsType),
            indicatorColor: 
              widget.indicatorColor 
              ?? VTSTabStyle.get('indicatorColor', widget.vtsType, extra: [isHybrid ? 'hybrid' : isIconOnly ? 'single-icon' : 'single-label']),
            indicatorWeight: 
              widget.indicatorWeight
              ?? VTSTabStyle.get('indicatorWeight', widget.vtsType),
          ),
        ),
      ),
    );
}
