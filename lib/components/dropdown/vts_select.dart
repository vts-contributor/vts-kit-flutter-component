import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/common/extension/index.dart';
import 'package:vts_component/common/style/vts_color.dart';
import 'package:vts_component/components/base/field_control/field_control.dart';
import 'package:vts_component/components/base/field_control/field_control_action.dart';
import 'package:vts_component/components/base/field_control/typings.dart';
import 'package:vts_component/components/dropdown/typings.dart';
import 'package:vts_component/components/dropdown/vts_select_bottomsheet.dart';
import 'package:vts_component/components/dropdown/vts_select_overlay.dart';

class VTSSelect extends StatefulWidget {

  const VTSSelect({
    Key? key,
    required this.items,
    this.enabled = true,
    this.multiselect = false,
    this.vtsSize = VTSFieldControlSize.MD,
    this.vtsType = VTSSelectType.DROPDOWN,
    
    this.value,
    this.onChange,
    this.onChangeReturnObject,

    this.itemHeight,
    this.itemTextStyle,
    this.itemActiveTextStyle,
    this.itemBackground,
    this.itemActiveBackground,
    this.maxItemDropdown,
    this.selectedItemSuffix = const Icon(Icons.done, color: VTSColors.PRIMARY_1),
    
    this.customPreviewLabelFn,

    this.bottomSheetHeightRatio = 0.9,
    this.bottomSheetLabel,
    this.searchPlaceholder,
    this.searchFn,
    this.emptyLabel = 'No data found',
    this.emptyLabelTextStyle,


    this.borderRadius,
    this.placeholder = '--Select--',
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
  }) :  assert(bottomSheetHeightRatio <= 1.0 && bottomSheetHeightRatio > 0, "Bottomsheet's height ratio must be in range 0-1."),
        assert(
          !multiselect
          || (multiselect 
          && ((value is List && value.length == 0) || (value is List<VTSSelectItem>?) || (value is List<int>?) || (value is List<String>?))), 
          'Value of multiselect dropdown must be List of VTSSelectItem, int or string or null.'
        ),
        assert(
          multiselect
          || (!multiselect 
          && ((value is VTSSelectItem?) || (value is int?) || (value is String?))), 
          'Value of dropdown must be VTSSelectItem?, int? or string?.'
        ),
        super(key: key);


  /// List of options which are derivative of `VTSSelectItem`
  /// [VTSSelectClassicItem] support classic options (label/value)
  /// [VTSSelectObjectItem<T>] support object options using pass in mapper
  /// Other cases, implement [VTSSelectItem]
  final List<VTSSelectItem> items;

  /// Whether the dropdown is enabled or disabled
  final bool enabled;

  /// Specify single-select or multi-select mode
  final bool multiselect;

  /// Dropdown size of [VTSFieldControlSize] i.e, sm, md
  final VTSFieldControlSize vtsSize;

  /// Dropdown size of [VTSSelectType] i.e, dropdown, bottomsheet
  final VTSSelectType vtsType;

  /// Current dropdown value, type of value depend on usage.
  /// In case of single-select, value can be [value of option] or [VTSSelectItem]
  /// In case of multi-select, value can be [list of options's values] or [List<VTSSelectItem>]
  final dynamic value;

  /// Trigger on value changed
  /// By default, value of option will be returned, 
  /// if `onChangeReturnObject` is specified, `VTSSelectItem` will be returned 
  /// (return type is list in case of multi-select)
  final void Function(dynamic)? onChange;

  /// Return [VTSSelectItem] instead of value of option
  final bool? onChangeReturnObject;

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

  /// Append a custom widget at the end of selected item's label
  final Widget? selectedItemSuffix;

  /// Custom preview label, given list of selected items
  final String Function(List<VTSSelectItem> data)? customPreviewLabelFn;

  /// Max height of bottomsheet which calculated by ratio between 0 and 1 compared to full screen height
  final double bottomSheetHeightRatio;
  
  /// Top label of bottomsheet
  final String? bottomSheetLabel;

  /// Search placeholder of bottomsheet
  final String? searchPlaceholder;

  /// Custom search function
  final List<VTSSelectItem>? Function(List<VTSSelectItem> data, String? searchText)? searchFn;

  /// Custom label to display if no result found
  final String? emptyLabel;

  /// Custom text style for emptyLabel
  final TextStyle? emptyLabelTextStyle;

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
  _VTSSelectState createState() => _VTSSelectState();

}

class _VTSSelectState extends State<VTSSelect> with TickerProviderStateMixin {
  static const DEFAULT_PREVIEW = '';

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  int? _currentIndex;
  VTSSelectItem? _currentValue;
  List<int>? _currentIndexes;
  List<VTSSelectItem>? _currentValues;
  late String _previewText = DEFAULT_PREVIEW;
  dynamic updatedItems = double.infinity;

  StateSetter ? _sheetStateSetter; // Bottomsheet re-render using controller
  
  bool get isMultiple => widget.multiselect == true;
  VTSSelectType get vtsType => isMultiple ? VTSSelectType.BOTTOMSHEET : widget.vtsType;

  bool get hasValue => isMultiple ? !_currentValues.isNullOrEmpty() : _currentValue != null;

  late VTSFieldControlStateStyle<Color> backgrounds;
  late VTSFieldControlStateStyle<TextStyle> textStyles;
  late VTSFieldControlStateStyle<Color> borderColors;
  late VTSFieldControlStateStyle<List<BoxShadow>>? boxShadows;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _updateValue();
    });

    backgrounds = VTSFieldControlStateStyle(
      defaultStyle: widget.background,
      hoverStyle: widget.hoverBackground,
      focusStyle: widget.focusBackground
    );
    textStyles = VTSFieldControlStateStyle(
      defaultStyle: widget.textStyle,
      hoverStyle: widget.hoverTextStyle,
      focusStyle: widget.focusTextStyle
    );
    borderColors = VTSFieldControlStateStyle(
      defaultStyle: widget.borderColor,
      hoverStyle: widget.hoverBorderColor,
      focusStyle: widget.focusBorderColor
    );
    boxShadows = VTSFieldControlStateStyle(
      defaultStyle: widget.boxShadow,
      hoverStyle: widget.hoverBoxShadow,
      focusStyle: widget.focusBoxShadow
    );
  }

  @override
  void didUpdateWidget(covariant VTSSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != updatedItems)
      Future.delayed(Duration.zero, () async {
        _updateValue();
      });

    if (widget.items != oldWidget.items)
      Future.delayed(Duration.zero, () async {
        _updateValue();
      });

    if (widget.items.isNotEmpty) {
      if (_sheetStateSetter != null)
        Future.delayed(Duration.zero, () async {
          _sheetStateSetter!((){});
        });
        
      if (_overlayEntry != null)
        Future.delayed(Duration.zero, () async {
          _overlayEntry!.markNeedsBuild();
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateValue({notify = true}) {
    if (!(widget.value != null && widget.items.isNotEmpty && (!widget.multiselect || (!!widget.multiselect && widget.value?.length > 0))))
      return;
    debugPrint('update value');
    setState(() {
      if (widget.multiselect) {
        if (widget.value is List<VTSSelectItem>) {
          final listValue = widget.value as List<VTSSelectItem>;
          final listCompare = listValue.map((item) => item.getValue());
          _currentValues = widget.items.where((item) => listCompare.contains(item.getValue())).toList();
        }
        else {
          final listValue = widget.value as List;
          _currentValues = widget.items.where((element) => listValue.contains(element.getValue())).toList();
        }
        _currentIndexes = _currentValues!.map((item) => _getIndex(item)).toList();
        _previewText = _renderMultiselectPreviewLabel(_currentValues);
      } else {
        if (widget.value is VTSSelectItem) {
          final filter = widget.items.where((element) => element.getValue() == widget.value.getValue());
          _currentValue = filter.isNotEmpty ? filter.first : null;
        }
        else {
          final filter = widget.items.where((element) => element.getValue() == widget.value);
          _currentValue = filter.isNotEmpty ? filter.first : null;
        }
        _currentIndex = _currentValue != null ? _getIndex(_currentValue) : null;
        _previewText = _currentValue != null ? _currentValue!.getLabel() : DEFAULT_PREVIEW;
      }
    });
    if (notify) {
      _notifyChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    var actionIcons = [
      VTSFieldControlActionIconItem(
        icon: const Icon(Icons.arrow_drop_down),
        onTap: _togglePopup
      )
    ];

    if (hasValue && widget.enabled)
      actionIcons = [
        VTSFieldControlActionIconItem(
          icon: const Icon(Icons.close),
          onTap: () => _onItemSelect(null)
        ),
        ...actionIcons
      ];

    return CompositedTransformTarget(
      link: _layerLink,
      child: VTSFieldControl(
        readonly: true,
        placeholder: widget.placeholder,
        text: _previewText,
        suffix: VTSFieldControlAction(
          icons: actionIcons,
        ),
        onTap: () {_togglePopup();},
        onFocus: (focused) {
          if (!focused && vtsType != VTSSelectType.BOTTOMSHEET) 
            _togglePopup(close: true);
        },
        backgrounds: backgrounds,
        textStyles: textStyles,
        borderColors: borderColors,
        boxShadows: boxShadows,
        borderRadius: widget.borderRadius,
        height: widget.height,
        enabled: widget.enabled,
        vtsSize: widget.vtsSize,
      )
    );
  }

  String _renderMultiselectPreviewLabel(List<VTSSelectItem>? values) {
    if (values.isNullOrEmpty())
      return DEFAULT_PREVIEW;
    else {
      if (widget.customPreviewLabelFn != null)
        return widget.customPreviewLabelFn!(values!);
      else
        return values!.map((item) => item.getLabel()).join(', ');
    }
  }

  int _getIndex(item) => widget.items.indexOf(item);

  void _notifyChange() {
    final notifyChange = (updated) {
      if (updated != updatedItems) {
        final notifyFn = widget.onChange ?? (dynamic) {};
        updatedItems = updated;
        notifyFn(updated);
      }
    };
    if (isMultiple) {
      if (widget.onChangeReturnObject == true) {
        notifyChange(_currentValues);
      }
      else {
        final notifyValue = _currentValues!.map((item) => item.getValue());
        if (widget.items.isNotEmpty) {
          if (widget.items[0].getValue() is int)
            notifyChange(List<int>.from(notifyValue));
          else
            notifyChange(List<String>.from(notifyValue));
        }
      }
    } else {
      if (widget.onChangeReturnObject == true)
        notifyChange(_currentValue);
      else
        notifyChange(_currentValue != null ? _currentValue!.getValue() : null);
    }
  }

  void _onItemSelect(VTSSelectItem? item) {
    if (!widget.enabled)
      return;

    if (isMultiple) {
      setState(() {
        if (item != null) {
          if (!_currentValues.isNullOrEmpty() && _currentValues!.contains(item)) {
            final index = _currentValues!.indexOf(item);
            _currentIndexes!.removeAt(index);
            _currentValues!.removeAt(index);
            _previewText = _renderMultiselectPreviewLabel(_currentValues);
          }
          else {
            final index = _getIndex(item);
            _currentValues = [...(_currentValues ?? []), widget.items[index]];
            _currentIndexes = [...(_currentIndexes ?? []), index];
            _previewText = _renderMultiselectPreviewLabel(_currentValues);
          }
        } else {
          _currentIndexes = [];
          _currentValues = [];
          _previewText = DEFAULT_PREVIEW;
        }
        _notifyChange();

        if (_sheetStateSetter != null)
          _sheetStateSetter!((){});
      });
    } else {
      _togglePopup( close: true );
      setState(() {
        if (item != null) {
          _currentIndex = _getIndex(item);
          _currentValue = item;
          _previewText = item.getLabel();
        } else {
          _currentIndex = null;
          _currentValue = null;
          _previewText = DEFAULT_PREVIEW;
        }
      });
      _notifyChange();
    }
  }

  OverlayEntry _createOverlayEntry() => OverlayEntry(
    builder: (ctx) => VTSSelectOverlay(
      items: widget.items,
      onTap: _onItemSelect,
      itemHeight: widget.itemHeight,
      layerLink: _layerLink,
      parentContext: context,
      value: _currentValue,
      itemTextStyle: widget.itemTextStyle,
      itemActiveTextStyle: widget.itemActiveTextStyle,
      itemBackground: widget.itemBackground,
      itemActiveBackground: widget.itemActiveBackground,
      maxItemDropdown: widget.maxItemDropdown,
      selectedItemSuffix: widget.selectedItemSuffix,
      emptyLabel: widget.emptyLabel,
      emptyLabelTextStyle: widget.emptyLabelTextStyle
    )
  );

  void _showBottomSheet({bool close = false}) {
    if (_isOpen) {
      Navigator.pop(context);
      setState(() { _isOpen = false; });
    } else {
      if (!close) {
        showModalBottomSheet(
          backgroundColor: VTSColors.WHITE_1,
          isScrollControlled: true,
          context: context, 
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            )
          ),
          builder: (ctx) 
            => StatefulBuilder(
              builder: (ctx2, StateSetter sheetState) {
                _sheetStateSetter = sheetState;
                return VTSSelectBottomSheet(
                  items: widget.items,
                  onTap: _onItemSelect,
                  itemHeight: widget.itemHeight,
                  bottomSheetLabel: widget.bottomSheetLabel,
                  searchPlaceholder: widget.searchPlaceholder,
                  searchFn: widget.searchFn,
                  emptyLabel: widget.emptyLabel,
                  emptyLabelTextStyle: widget.emptyLabelTextStyle,
                  value: isMultiple
                    ? _currentValues
                    : _currentValue != null ? [_currentValue] : null,
                  itemTextStyle: widget.itemTextStyle,
                  itemActiveTextStyle: widget.itemActiveTextStyle,
                  itemBackground: widget.itemBackground,
                  itemActiveBackground: widget.itemActiveBackground,
                  maxItemDropdown: widget.maxItemDropdown,
                  selectedItemSuffix: widget.selectedItemSuffix,
                  bottomSheetHeightRatio: widget.bottomSheetHeightRatio,
                  isMultiple: isMultiple
                );
              }
            )
        ).whenComplete(() {
          setState(() { _isOpen = false; });
          _sheetStateSetter = null;
        });
        setState(() { _isOpen = true; });
      } else {
        setState(() { _isOpen = false; });
        _sheetStateSetter = null;
      }
    }
  }

  void _showDropdown({bool close = false}) {
    if (_isOpen || close) {
      if (_isOpen) {
        _overlayEntry!.remove();
      }
      setState(() { _isOpen = false; });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
      setState(() => _isOpen = true);
    }
  }

  void _togglePopup({bool close = false}) {
    if (!widget.enabled)
      return;
    switch (vtsType) {
      case VTSSelectType.DROPDOWN:
        _showDropdown(close: close);
        break;
      case VTSSelectType.BOTTOMSHEET:
        _showBottomSheet(close: close);
        break;
      default:
        _showDropdown(close: close);
        break;
    }
  }
}