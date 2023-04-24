import 'package:equatable/equatable.dart';

class ListWrapper<T> with EquatableMixin {
  ListWrapper(this.list);
  final List<T> list;

  @override
  List<Object?> get props => [list];
}

/// An Extension to convert a List into ListWrapper class
extension ListExtension<T> on List<T> {
  /// Converts List into ListWrapper class
  ListWrapper<T> toWrapperClass() => ListWrapper<T>(this);
}
