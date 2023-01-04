import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/index.dart';
import 'package:vts_component/components/base/field_control/field_control.dart';
import 'package:vts_component/components/base/field_control/field_control_action.dart';
import 'package:vts_component/components/base/field_control/typings.dart';
import 'package:vts_component/components/dropdown/vts_select_overlay.dart';
import 'package:vts_component/components/search_bar/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSSearchBar extends StatefulWidget {

  const VTSSearchBar({
    Key? key,
    required this.items,
    this.onInputChange,
    this.onSelectChange,
    this.onSelectChangeReturnObject,
    this.onSubmit,
    this.onFocus,
    
    this.searchFn,
    this.emptyLabel,
    this.emptyLabelTextStyle,

    this.showAlways = false,
    this.itemHeight,
    this.itemTextStyle,
    this.itemActiveTextStyle,
    this.itemBackground,
    this.itemActiveBackground,
    this.maxItemDropdown,

    this.prefixIcon,
    this.borderRadius,
    this.placeholder = 'Search',
    this.height,
    this.background,
    this.hoverBackground,
    this.focusBackground,
    this.textStyle,
    this.hoverTextStyle,
    this.focusTextStyle,
    this.borderColor,
    this.hoverBorderColor,
    this.focusBorderColor,
    this.boxShadow,
    this.hoverBoxShadow,
    this.focusBoxShadow,
  }) : super(key: key);

  /// List of options which are derivative of [VTSSelectItem]
  /// Set [items] to [] to hide dropdown
  /// [VTSSelectClassicItem] support classic options (label/value)
  /// [VTSSelectObjectItem<T>] support object options using pass in mapper
  /// Other cases, implement [VTSSelectItem]
  final List<VTSSelectItem> items;

  /// Trigger on user input
  final void Function(String?)? onInputChange;

  /// Trigger on user select from suggestion
  /// By default, value of option will be returned, 
  /// if [onChangeReturnObject] is specified, [VTSSelectItem] will be returned
  final bool? onSelectChangeReturnObject;

  /// Return [VTSSelectItem] instead of value of option
  final void Function(dynamic)? onSelectChange;

  /// Trigger on user touch search button or press Enter or select from suggestion (will return label of option)
  final void Function(String?)? onSubmit;

  final Function(bool focus)? onFocus;

  /// Custom search function
  final List<VTSSelectItem>? Function(List<VTSSelectItem> data, String? searchText)? searchFn;
  
  /// Custom label to display if no result found
  final String? emptyLabel;

  /// Custom text style for [emptyLabel]
  final TextStyle? emptyLabelTextStyle;

  /// Always display suggestion dropdown even if input is empty
  final bool showAlways;

  /// Height of each option
  final double? itemHeight;
  
  /// Text style of option's label
  final TextStyle? itemTextStyle;

  /// Text style of option's label on active
  final TextStyle? itemActiveTextStyle;

  /// Background of option item
  final Color? itemBackground;

  /// Background of option item on active
  final Color? itemActiveBackground;

  /// Maximum number of option can be displayed on screen
  final int? maxItemDropdown;

  /// Custom prefix icon of input
  final Icon? prefixIcon;

  /// Override preset border radius
  final BorderRadius? borderRadius;

  /// Override preset input's placeholder
  final String? placeholder;

  /// Override preset input's height
  final double? height;

  /// Override preset input's background
  final Color? background;

  /// Override preset input's background on hovered
  final Color? hoverBackground;

  /// Override preset input's background on focused
  final Color? focusBackground;

  /// Override preset input's textStyle
  final TextStyle? textStyle;

  /// Override preset input's textStyle on hovered
  final TextStyle? hoverTextStyle;

  /// Override preset input's textStyle on focused
  final TextStyle? focusTextStyle;

  /// Override preset input's borderColor
  final Color? borderColor;

  /// Override preset input's borderColor on hovered
  final Color? hoverBorderColor;

  /// Override preset input's borderColor on focused
  final Color? focusBorderColor;

  /// Override preset input's boxShadow
  final List<BoxShadow>? boxShadow;

  /// Override preset input's boxShadow on hovered
  final List<BoxShadow>? hoverBoxShadow;

  /// Override preset input's boxShadow on focused
  final List<BoxShadow>? focusBoxShadow;

  @override
  _VTSSearchBarState createState() => _VTSSearchBarState();
}

class _VTSSearchBarState extends State<VTSSearchBar> with TickerProviderStateMixin {
  static const DEFAULT_VALUE = '';
  static const DEFAULT_INDEX = -1;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late String _currentValue = DEFAULT_VALUE;
  late int _currentIndex = DEFAULT_INDEX;
  bool get hasValue => !_currentValue.isNullOrEmpty() && _currentValue != DEFAULT_VALUE;
  List<VTSSelectItem>? _searchItems;
  bool hasFocus = false;

  late VTSFieldControlStateStyle<Color> backgrounds;
  late VTSFieldControlStateStyle<TextStyle> textStyles;
  late VTSFieldControlStateStyle<Color> borderColors;
  late VTSFieldControlStateStyle<List<BoxShadow>>? boxShadows;

  @override
  void initState() {
    super.initState();

    backgrounds = VTSFieldControlStateStyle(
      defaultStyle: widget.background ?? VTSSearchBarStyle.get('background', selector: VTSFieldControlState.DEFAULT),
      hoverStyle: widget.hoverBackground ?? VTSSearchBarStyle.get('background', selector: VTSFieldControlState.HOVER),
      focusStyle: widget.focusBackground ?? VTSSearchBarStyle.get('background', selector: VTSFieldControlState.FOCUS)
    );

    textStyles = VTSFieldControlStateStyle(
      defaultStyle: widget.textStyle ?? VTSSearchBarStyle.get('textStyle', selector: VTSFieldControlState.DEFAULT),
      hoverStyle: widget.hoverTextStyle ?? VTSSearchBarStyle.get('textStyle', selector: VTSFieldControlState.HOVER),
      focusStyle: widget.focusTextStyle ?? VTSSearchBarStyle.get('textStyle', selector: VTSFieldControlState.FOCUS)
    );

    borderColors = VTSFieldControlStateStyle(
      defaultStyle: widget.borderColor ?? VTSSearchBarStyle.get('borderColor', selector: VTSFieldControlState.DEFAULT),
      hoverStyle: widget.hoverBorderColor ?? VTSSearchBarStyle.get('borderColor', selector: VTSFieldControlState.HOVER),
      focusStyle: widget.focusBorderColor ?? VTSSearchBarStyle.get('borderColor', selector: VTSFieldControlState.FOCUS)
    );

    boxShadows = VTSFieldControlStateStyle(
      defaultStyle: widget.boxShadow ?? VTSSearchBarStyle.get('boxShadow', selector: VTSFieldControlState.DEFAULT),
      hoverStyle: widget.hoverBoxShadow ?? VTSSearchBarStyle.get('boxShadow', selector: VTSFieldControlState.HOVER),
      focusStyle: widget.focusBoxShadow ?? VTSSearchBarStyle.get('boxShadow', selector: VTSFieldControlState.FOCUS)
    );
  }

  @override
  void didUpdateWidget(covariant VTSSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items)
      Future.delayed(Duration.zero, () async {
        if (!_currentValue.isNullOrEmpty())
          _searchItems = _applyFilter(_currentValue);

        if (_overlayEntry != null)
          _overlayEntry!.markNeedsBuild();
        else if (widget.items.isNotEmpty && hasFocus)
          _toggleDropdown();
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefixIcons = [
      VTSFieldControlActionIconItem(
        icon: widget.prefixIcon ?? const Icon(Icons.search),
        onTap: () => _onSubmit(_currentValue)
      )
    ];

    final suffixIcon = 
      hasValue 
        ? [
          VTSFieldControlActionIconItem(
            icon: const Icon(Icons.close),
            onTap: _clear
          ),
        ] 
        : null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: VTSFieldControl(
        placeholder: widget.placeholder,
        text: _currentValue,
        prefix: VTSFieldControlAction(
          icons: prefixIcons,
        ),
        suffix: VTSFieldControlAction(
          icons: suffixIcon,
        ),
        onInput: _onInput,
        onSubmit: () => _onSubmit(_currentValue),
        onFocus: (focused) {
          hasFocus = focused;
          if (widget.onFocus != null)
            widget.onFocus!(focused);
          if (!focused) _toggleDropdown(close: true);
        },
        onTap: (widget.showAlways || !_currentValue.isNullOrEmpty()) ? _toggleDropdown : null,
        backgrounds: backgrounds,
        textStyles: textStyles,
        borderColors: borderColors,
        boxShadows: boxShadows,
        borderRadius: widget.borderRadius ?? VTSSearchBarStyle.get('borderRadius'),
        height: widget.height,
      )
    );
  }

  int _getIndex(item) => widget.items.indexOf(item);

  void _onInput(String? value) {
    _markForRebuild();

    setState(() {
      _currentIndex = DEFAULT_INDEX;
      _currentValue = value ?? DEFAULT_VALUE;
      _searchItems = _applyFilter(value);
    });

    if (!_isOpen)
      _toggleDropdown();

    if (widget.onInputChange != null)
      widget.onInputChange!(value);
  }

  void _onItemSelect(VTSSelectItem? item) {
    _toggleDropdown( close: true );
    final notifyChange = widget.onSelectChange ?? (dynamic) {};
    setState(() {
      if (item != null) {
        _currentIndex = _getIndex(item);
        _currentValue = item.getLabel();
      } else {
        _currentIndex = DEFAULT_INDEX;
        _currentValue = DEFAULT_VALUE;
      }
      _onSubmit(_currentValue);
    });

    if (widget.onSelectChangeReturnObject == true)
      notifyChange(_currentIndex != DEFAULT_INDEX ? widget.items[_currentIndex] : null);
    else
      notifyChange(_currentIndex != DEFAULT_INDEX ? widget.items[_currentIndex].getValue() : null);

    FocusScope.of(context).unfocus();
  }

  void _onSubmit(String? value) {
    if (widget.onSubmit != null)
      widget.onSubmit!(value);
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

  void _markForRebuild() {
    if (_overlayEntry != null)
      _overlayEntry!.markNeedsBuild();
  }

  void _clear() {
    final notifyChange = widget.onSelectChange ?? (dynamic) {};

    _markForRebuild();
    setState(() {
      _currentIndex = DEFAULT_INDEX;
      _currentValue = DEFAULT_VALUE;
      _searchItems = null;
    });
    notifyChange(null);
  }

  OverlayEntry _createOverlayEntry() => OverlayEntry(
    builder: (ctx) => VTSSelectOverlay(
      items: _searchItems ?? widget.items,
      onTap: _onItemSelect,
      itemHeight: widget.itemHeight,
      layerLink: _layerLink,
      parentContext: context,
      emptyLabel: widget.emptyLabel,
      emptyLabelTextStyle: widget.emptyLabelTextStyle,
      value: _currentIndex != DEFAULT_INDEX ? widget.items[_currentIndex] : null,
      itemTextStyle: widget.itemTextStyle,
      itemActiveTextStyle: widget.itemActiveTextStyle,
      itemBackground: widget.itemBackground,
      itemActiveBackground: widget.itemActiveBackground,
      maxItemDropdown: widget.maxItemDropdown,
    )
  );

  void _toggleDropdown({bool close = false}) {
    if (_isOpen || close) {
      if (_isOpen) {
        _overlayEntry!.remove();
      }
      setState(() {
        _isOpen = false;
        _searchItems = null;
      });
    } else {
      if (widget.items.isNullOrEmpty() && widget.emptyLabel.isNullOrEmpty())
        return;
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
      setState(() {
        _isOpen = true;
        _searchItems = !_currentValue.isNullOrEmpty() ? _applyFilter(_currentValue) : null;
      });
    }
  }
}