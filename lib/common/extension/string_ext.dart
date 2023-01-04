extension StringExtension on String? {
  String trimLowerCase() => this?.toLowerCase().trim() ?? '';
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}