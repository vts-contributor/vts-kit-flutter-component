import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/components/base/field_control/typings.dart';
import 'package:vts_component/common/style/vts_common.dart';

class VTSFieldControlAction extends StatefulWidget {
  const VTSFieldControlAction({
    Key? key,
    this.items,
    this.icons
  }): super(key: key);

  final List<Widget>? items;
  final List<VTSFieldControlActionIconItem>? icons;

  @override
  _VTSFieldControlActionState createState() => _VTSFieldControlActionState();
}

class _VTSFieldControlActionState extends State<VTSFieldControlAction> {
  late int tapIndex = -100;
  late List<Widget>? items;
  late List<VTSFieldControlActionIconItem>? icons;

  @override
  void initState() {
    super.initState();
  }

  @override
  didUpdateWidget(VTSFieldControlAction oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  List<Widget> renderRow(BuildContext context) {
    if (widget.items != null)
      return widget.items!.toList();
    if (widget.icons != null) {
      int getIndexItem(item) => widget.icons!.indexOf(item);

      return widget.icons!.map(
        (item) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
            key: Key(getIndexItem(item).toString()),
            child: IconTheme(
              data: IconThemeData(
                color: getIndexItem(item) == tapIndex
                  ? VTSCommon.ACTION_FONT_COLOR_ACTIVE
                  : VTSCommon.ACTION_FONT_COLOR_DEFAULT,
                size: VTSCommon.ACTION_ICON_FONT_SIZE
              ), 
              child: MouseRegion(child: item.icon, cursor: SystemMouseCursors.click)
            ),
            onTapDown: (e) {
              setState(() { 
                tapIndex = getIndexItem(item); 
              });
            },
            onTapUp: (e) {
              setState(() { 
                tapIndex = -100; 
              });
              item.onTap();
            },
            // onTap: (){
            //   item.onTap();
            // },
          ),
        )
      ).toList();
    }
    return [const SizedBox.shrink()];
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: renderRow(context)
  );
}