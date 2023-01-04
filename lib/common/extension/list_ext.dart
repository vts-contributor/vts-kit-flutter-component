extension ListExtension on List? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}