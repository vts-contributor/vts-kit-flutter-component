// ignore_for_file: avoid_classes_with_only_static_members, type_annotate_public_apis

class Generator {
  static dynamic fromMap(Map<dynamic, dynamic> content, Map<dynamic, dynamic> result, {prefix = ''}) {
    for (var k in content.keys) {
      final key = k.toString();
      final joinPrefix = prefix != '' ? prefix + '_' + key : key;

      if (content[k] is Map) {
        fromMap(content[k], result, prefix: joinPrefix);
      } else {
        result[joinPrefix] = content[k]; 
      }
    }
    return result;
  }
} 