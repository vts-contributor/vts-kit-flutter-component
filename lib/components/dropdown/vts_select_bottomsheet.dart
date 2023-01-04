import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/index.dart';
import 'package:vts_component/components/base/field_control/field_control.dart';
import 'package:vts_component/components/base/field_control/field_control_action.dart';
import 'package:vts_component/components/base/field_control/typings.dart';
import 'package:vts_component/components/dropdown/index.dart';
import 'package:vts_component/components/dropdown/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSSelectBottomSheet<T> extends StatefulWidget {
  VTSSelectBottomSheet(
    {
      Key? key,
      required this.items,
      required this.value,
      required this.onTap,
      required this.isMultiple,

      this.bottomSheetHeightRatio,
      this.bottomSheetLabel,
      this.searchPlaceholder,
      this.searchFn,

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
  final List<VTSSelectItem?>? value;
  final bool isMultiple;

  final double? itemHeight;
  final TextStyle? itemTextStyle;
  final TextStyle? itemActiveTextStyle;
  final Color? itemBackground;
  final Color? itemActiveBackground;
  final int? maxItemDropdown;
  
  final Function(VTSSelectItem item) onTap;
  final Widget? selectedItemSuffix;

  final double? bottomSheetHeightRatio;
  final String? bottomSheetLabel;
  final String? searchPlaceholder;
  final List<VTSSelectItem>? Function(List<VTSSelectItem> data, String? searchText)? searchFn;

  final String? emptyLabel;
  final TextStyle? emptyLabelTextStyle;
  
  @override
  _VTSSelectBottomSheetState<T> createState() => _VTSSelectBottomSheetState<T>();
}

class _VTSSelectBottomSheetState<T> extends State<VTSSelectBottomSheet<T>> with TickerProviderStateMixin {
  String? _searchText;
  List<VTSSelectItem>? _searchItems;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VTSSelectBottomSheet<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  void _clear() {
    setState(() {
      _searchText = null;
      _searchItems = null;
    });
  }

  List<VTSSelectItem>? _applyFilter(String? value) {
    if (widget.searchFn != null)
      return widget.searchFn!(widget.items, value);

    final filter = !value.isNullOrEmpty()
      ? widget.items.where((element) => 
          element.getLabel().trimLowerCase().contains(value.trimLowerCase())
        ).toList()
      : widget.items;

    return filter;
  }

  Widget renderTopLabel() {
    if (widget.bottomSheetLabel == null) 
      return const SizedBox.shrink();
    
    final topLabelHeight = VTSSelectStyle.get('topLabelHeight', selector: VTSSelectType.BOTTOMSHEET);
    final topLabelTextStyle = VTSSelectStyle.get('topLabelTextStyle', selector: VTSSelectType.BOTTOMSHEET);
    return  Container(
      constraints: BoxConstraints(
        minHeight: topLabelHeight,
        maxHeight: topLabelHeight
      ),
      alignment: Alignment.center,
      child: Text(widget.bottomSheetLabel!, style: topLabelTextStyle, overflow: TextOverflow.ellipsis,),
    );
  }

  Widget renderSearch() {
    final searchHeight = VTSSelectStyle.get('searchHeight', selector: VTSSelectType.BOTTOMSHEET);
    final searchBackground = VTSSelectStyle.get('searchBackground', selector: VTSSelectType.BOTTOMSHEET);
    final searchPadding = VTSSelectStyle.get('searchPadding', selector: VTSSelectType.BOTTOMSHEET);
    final searchInputBackgrounds = VTSSelectStyle.get('searchInputBackgrounds', selector: VTSSelectType.BOTTOMSHEET);
    final searchInputBorderColors = VTSSelectStyle.get('searchInputBorderColors', selector: VTSSelectType.BOTTOMSHEET);
    
    final prefixIcons = [
      VTSFieldControlActionIconItem(
        icon: const Icon(Icons.search),
        onTap: () {}
      )
    ];

    final suffixIcon = 
      !_searchText.isNullOrEmpty() 
        ? [
          VTSFieldControlActionIconItem(
            icon: const Icon(Icons.close),
            onTap: _clear
          ),
        ] 
        : null;

    return  Container(
      constraints: BoxConstraints(
        minHeight: searchHeight,
        maxHeight: searchHeight
      ),
      color: searchBackground,
      alignment: Alignment.center,
      padding: searchPadding,
      child: VTSFieldControl(
        backgrounds: searchInputBackgrounds,
        borderColors: searchInputBorderColors,
        prefix: VTSFieldControlAction(
          icons: prefixIcons,
        ),
        suffix: VTSFieldControlAction(
          icons: suffixIcon,
        ),
        placeholder: widget.searchPlaceholder,
        onInput: (value) => setState(() {
          _searchText = value;
          _searchItems = _applyFilter(value);
        }),
        text: _searchText,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSheetHeightRatio = widget.bottomSheetHeightRatio ?? 0.9;
    final maxBottomSheetHeight = bottomSheetHeightRatio * MediaQuery.of(context).size.height;
    late double maxItemSectionHeight;

    final double itemHeight = widget.itemHeight ?? VTSSelectStyle.get('itemHeight', selector: VTSSelectType.BOTTOMSHEET);

    if (widget.maxItemDropdown != null) {
      final double topLabelHeight = widget.bottomSheetLabel != null ? VTSSelectStyle.get('topLabelHeight', selector: VTSSelectType.BOTTOMSHEET) : 0.0;
      final double searchHeight = VTSSelectStyle.get('searchHeight', selector: VTSSelectType.BOTTOMSHEET);
      final calcItemListViewHeight = itemHeight * widget.maxItemDropdown!;
      final totalHeight = calcItemListViewHeight + topLabelHeight + searchHeight;
      maxItemSectionHeight = totalHeight > maxBottomSheetHeight
                            ? maxBottomSheetHeight - topLabelHeight - searchHeight
                            : calcItemListViewHeight;
    }

    if (maxItemSectionHeight > widget.items.length * itemHeight) {
      maxItemSectionHeight = widget.items.length * itemHeight;
      maxItemSectionHeight = maxItemSectionHeight > 0 ? maxItemSectionHeight : itemHeight - 1;
    }

    final itemLength = widget.items.length;
    final realMaxItem = min(itemLength, (maxItemSectionHeight / itemHeight).floor());
    final firstSelectedIndex = 
      !widget.value.isNullOrEmpty() 
      ? widget.items.indexWhere((item) => widget.value!.contains(item))
      : 0;
    int offsetIndex = min(itemLength - realMaxItem, firstSelectedIndex);
    offsetIndex = offsetIndex < 0 ? 0 : offsetIndex;
    final double initialOffset = itemHeight * offsetIndex;

    List<Widget> content;
    final items = _searchItems ?? widget.items;

    if (items.isNotEmpty) {
      final itemBackground = widget.itemBackground ?? VTSSelectStyle.get('itemBackground', selector: VTSSelectType.BOTTOMSHEET);
      final itemActiveBackground = widget.itemActiveBackground ?? VTSSelectStyle.get('itemActiveBackground', selector: VTSSelectType.BOTTOMSHEET);
      final itemTextStyle = widget.itemTextStyle ?? VTSSelectStyle.get('itemTextStyle', selector: VTSSelectType.BOTTOMSHEET);
      final itemActiveTextStyle = widget.itemActiveTextStyle ?? VTSSelectStyle.get('itemActiveTextStyle', selector: VTSSelectType.BOTTOMSHEET);
      final itemPadding = VTSSelectStyle.get('itemPadding', selector: VTSSelectType.BOTTOMSHEET);
      final isSelected = (VTSSelectItem item) => !widget.value.isNullOrEmpty() ? widget.value!.contains(item) : false;

      content = 
        items.map((item) 
          => Material(
            color: 
              !widget.value.isNullOrEmpty() 
              && isSelected(item)
                ? itemActiveBackground 
                : itemBackground,
            child: Column(
              children: [
                InkWell(
                  // key: Key(item.getValue().toString()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: itemHeight,
                          padding: itemPadding,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              widget.isMultiple
                              ? Transform.scale(
                                  scale: 16/18,
                                  child: Checkbox(
                                    checkColor: VTSColors.WHITE_1,
                                    fillColor: MaterialStateProperty.all(VTSColors.PRIMARY_0),
                                    onChanged: (e){},
                                    value: isSelected(item),
                                  )
                                )
                              : const SizedBox.shrink(),
                              DefaultTextStyle(
                                style: isSelected(item) ? itemActiveTextStyle : itemTextStyle,
                                child: Text(item.getLabel())
                              ),
                            ],
                          )
                        ),
                      ),
                      isSelected(item) && widget.selectedItemSuffix != null
                      ? Container(
                        height: itemHeight,
                        padding: EdgeInsets.only(right: itemPadding.left),
                        child: widget.selectedItemSuffix
                      )
                      : const SizedBox.shrink()
                    ],
                  ),
                  onTap: () {_onTap(item);},
                ),
                Container(
                  height: 1.0,
                  margin: EdgeInsets.only(left: itemPadding.left),
                  color: VTSSelectStyle.get('itemSeperatorColor', selector: VTSSelectType.BOTTOMSHEET)
                )
              ]
            )
          )
        ).toList();
    } else {
      if (widget.emptyLabel != null)
        content = [
          Container(
              height: maxItemSectionHeight,
              alignment: Alignment.center,
              child: Text(widget.emptyLabel!, style: widget.emptyLabelTextStyle ?? VTSSelectStyle.get('emptyLabelTextStyle'))
          )
        ];
      else
        content = [const SizedBox.shrink()];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        renderTopLabel(),
        renderSearch(),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxItemSectionHeight
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            controller: ScrollController(initialScrollOffset: initialOffset),
            children: content
          )
        )
      ],
    );
  }

  void _onTap(VTSSelectItem item) {
    widget.onTap(item);
  }
}