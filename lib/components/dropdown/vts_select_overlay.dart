import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/dropdown/index.dart';
import 'package:vts_component/components/dropdown/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSSelectOverlay<T> extends StatefulWidget {
  VTSSelectOverlay(
    {
      Key? key,
      required this.items,
      required this.value,
      required this.onTap,
      required this.layerLink,
      required this.parentContext,

      this.itemHeight,
      this.itemTextStyle,
      this.itemActiveTextStyle,
      this.itemBackground,
      this.itemActiveBackground,

      this.maxItemDropdown,
      this.selectedItemSuffix,

      this.emptyLabel,
      this.emptyLabelTextStyle
    })
    : assert(items.map((item) => item.getValue()).toSet().length == items.length, "Items's values must be unique"), 
      super(key: key);

  final List<VTSSelectItem> items;
  final VTSSelectItem? value;

  final double? itemHeight;
  final TextStyle? itemTextStyle;
  final TextStyle? itemActiveTextStyle;
  final Color? itemBackground;
  final Color? itemActiveBackground;
  final int? maxItemDropdown;
  
  final Function(VTSSelectItem item) onTap;
  final Widget? selectedItemSuffix;

  final String? emptyLabel;
  final TextStyle? emptyLabelTextStyle;

  final LayerLink layerLink;
  final BuildContext parentContext;
  
  @override
  _VTSSelectOverlayState<T> createState() => _VTSSelectOverlayState<T>();
}

class _VTSSelectOverlayState<T> extends State<VTSSelectOverlay<T>> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: VTSCommon.ANIMATION_NORMAL_DURATION);
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant VTSSelectOverlay<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _getIndex(VTSSelectItem item) => widget.items.indexOf(item);
    final RenderBox renderBox = widget.parentContext.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height + 1;
    final double itemHeight = widget.itemHeight ?? VTSSelectStyle.get('itemHeight', selector: VTSSelectType.DROPDOWN);
    double maxHeight = MediaQuery.of(context).size.height - topOffset - 15;
    if (widget.maxItemDropdown != null)
      maxHeight = min(itemHeight * widget.maxItemDropdown!, maxHeight);
    final itemLength = widget.items.length;
    final realMaxItem = min(itemLength, (maxHeight / itemHeight).floor());
    final selectedIndex = widget.value != null ? widget.items.indexOf(widget.value!) : 0;
    int offsetIndex = min(itemLength - realMaxItem, selectedIndex);
    offsetIndex = offsetIndex < 0 ? 0 : offsetIndex;
    final double initialOffset = itemHeight * offsetIndex;

    List<Widget> listViewContent;
    if (widget.items.isNotEmpty) {
      final itemBackground = widget.itemBackground ?? VTSSelectStyle.get('itemBackground', selector: VTSSelectType.DROPDOWN);
      final itemActiveBackground = widget.itemActiveBackground ?? VTSSelectStyle.get('itemActiveBackground', selector: VTSSelectType.DROPDOWN);
      final itemTextStyle = widget.itemTextStyle ?? VTSSelectStyle.get('itemTextStyle', selector: VTSSelectType.DROPDOWN);
      final itemActiveTextStyle = widget.itemActiveTextStyle ?? VTSSelectStyle.get('itemActiveTextStyle', selector: VTSSelectType.DROPDOWN);
      listViewContent = 
        widget.items.map((item) 
          => Material(
            color: widget.value != null && widget.value!.getValue() == item.getValue() ? itemActiveBackground : itemBackground,
            key: Key(item.getValue().toString()),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: itemHeight,
                      padding: VTSSelectStyle.get('itemPadding', selector: VTSSelectType.DROPDOWN),
                      alignment: Alignment.centerLeft,
                      child: DefaultTextStyle(
                        style: widget.value != null && widget.value!.getValue() == item.getValue() ? itemActiveTextStyle : itemTextStyle,
                        child: Text(item.getLabel())
                      ),
                    ),
                  ),
                  widget.value != null && widget.value!.getValue() == item.getValue() && widget.selectedItemSuffix != null
                  ? Container(
                    height: itemHeight,
                    padding: EdgeInsets.only(right: VTSSelectStyle.get('itemPadding', selector: VTSSelectType.DROPDOWN).left),
                    child: widget.selectedItemSuffix
                  )
                  : const SizedBox.shrink()
                ],
              ),
              onTap: () {_onTap(item);},
            )
          )
        ).toList();
    } else {
      if (widget.emptyLabel != null)
        listViewContent = [
          Container(
              height: itemHeight,
              padding: VTSSelectStyle.get('itemPadding', selector: VTSSelectType.DROPDOWN),
              alignment: Alignment.center,
              child: Text(widget.emptyLabel!, style: widget.emptyLabelTextStyle ?? VTSSelectStyle.get('emptyLabelTextStyle'))
          )
        ];
      else
        listViewContent = [const SizedBox.shrink()];
    }

    final listView = ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      controller: ScrollController(initialScrollOffset: initialOffset),
      children: listViewContent
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: topOffset,
            width: size.width,
            child: CompositedTransformFollower(
              offset: Offset(0, size.height + 1),
              link: widget.layerLink,
              showWhenUnlinked: false,
              child: Container(
                decoration: VTSSelectStyle.get('dropdownDecoration', selector: VTSSelectType.DROPDOWN),
                child: Material(
                  elevation: 1.0,
                  child: SizeTransition(
                    axisAlignment: 1,
                    sizeFactor: _expandAnimation,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: maxHeight < itemHeight ? double.infinity : maxHeight,
                      ),
                      child: Container(
                        child: listView
                      )
                    ) 
                  ),
                ),
              )
            ),
          ),
        ],
      )
    );
  }

  void _onTap(VTSSelectItem item) {
    widget.onTap(item);
  }
}