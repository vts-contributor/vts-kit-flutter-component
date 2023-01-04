// ignore_for_file: sort_constructors_first

import 'package:vts_component/common/extension/index.dart';

enum VTSSelectType {DROPDOWN, BOTTOMSHEET}

abstract class VTSSelectItem {
  String getLabel();
  dynamic getValue();
}

class VTSSelectObjectItem<T> implements VTSSelectItem {
  final T object;
  final String Function(T item) labelMappingFn; 
  final dynamic Function(T item) valueMappingFn; 

  const VTSSelectObjectItem({
    required this.object,
    required this.labelMappingFn,
    required this.valueMappingFn,
  });

  @override
  String getLabel() => labelMappingFn(object);
  
  @override
  dynamic getValue() {
    final value = valueMappingFn(object);
    assert(value is String || value is int, 'Mapped value must be of type String or Int');
    return value;
  }
    
  bool operator ==(o) => o is VTSSelectObjectItem && getValue() == o.getValue();
}

class VTSSelectClassicItem implements VTSSelectItem {
  late String label; 
  final dynamic value; 

  VTSSelectClassicItem({
    this.label = '',
    required this.value,
  }) : assert(value is String || value is int, 'Value must be of type String or Int') {
    if (label.isNullOrEmpty())
      label = value.toString();
  }

  @override
  String getLabel() => label;
  
  @override
  dynamic getValue() => value;

  bool operator ==(o) => o is VTSSelectClassicItem && getValue() == o.getValue();

  static List<VTSSelectClassicItem> fromListString(List<String> list) 
    => list.map((item) => VTSSelectClassicItem(value: item, label: item)).toList();
}



// class VTSSelectItem<T> {
//   final T value;
//   final String? label;

//   final String Function(T item)? labelRenderFn; 

//   const VTSSelectItem({
//     required this.value,
//     this.label,
//     this.labelRenderFn,
//   }): assert(label != null || labelRenderFn != null);

//   String getLabel() => label ?? labelRenderFn!(value);
//   dynamic getValue() => value;

//   static List<VTSSelectItem<String>> fromListString(List<String> list) 
//     => list.map((item) => VTSSelectItem<String>(value: item, label: item)).toList();
// }