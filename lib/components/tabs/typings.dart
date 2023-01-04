import 'package:flutter/cupertino.dart';

enum VTSTabType { SEGMENT, TOPBAR, BOTTOMBAR }

class VTSTabItem { 
  VTSTabItem({this.text, this.icon});
  
  final String? text;
  final Icon? icon;
}