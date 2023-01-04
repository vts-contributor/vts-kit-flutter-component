import 'package:flutter/material.dart';
import 'package:vts_component/common/style/vts_common.dart';
import 'package:vts_component/components/badge/styles.dart';
import 'package:vts_component/components/badge/typings.dart';
import 'package:vts_component/vts_component.dart';

class VTSBadge extends StatefulWidget {
  const VTSBadge({
    Key? key,
    required this.parent,
    this.text,
    this.vtsType = VTSBadgeType.SOLID,
    this.vtsShape = VTSBadgeShape.STANDARD,
    this.vtsSize = VTSBadgeSize.SM,
    this.vtsPosition = VTSBadgePosition.TOP_RIGHT,
    this.primaryColor,
    this.secondaryColor,
    this.textStyle,
    this.height,
    this.padding,
    this.offset
  }) : super(key: key);

  /// Parent widget
  final Widget? parent;

  /// Badge type of [VTSBadgeType] i.e, solid, outline
  final VTSBadgeType vtsType;

  /// Badge type of [VTSBadgeShape] i.e, standard, pill, square, circle
  final VTSBadgeShape vtsShape;

  /// Badge type of [VTSBadgeSize] i.e, sm, md
  final VTSBadgeSize vtsSize;

  /// Badge type of [VTSBadgePosition] i.e, topleft, topright, bottomleft, bottomright
  final VTSBadgePosition vtsPosition;

  /// Primary color determine background, border color
  final Color? primaryColor;

  /// Primary color determine text, icon color
  final Color? secondaryColor;
  
  /// Badge's content
  final String? text;

  /// TextStyle of badge
  final TextStyle? textStyle;

  /// Override badge height preset
  final double? height;

  /// Override badge padding preset
  final EdgeInsetsGeometry? padding;

  /// Override offset translation preset
  final Offset? offset;

  @override
  _VTSBadgeState createState() => _VTSBadgeState();
}

class _VTSBadgeState extends State<VTSBadge> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(VTSBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Color getPrimaryColor() => widget.primaryColor ?? VTSBadgeStyle.get('primaryColor');
    Color getSecondaryColor() => widget.secondaryColor ?? VTSBadgeStyle.get('secondaryColor');
    double? getHeight() => widget.height ?? VTSBadgeStyle.get('height', selector: widget.vtsSize);
    double? getWidth() => widget.vtsShape == VTSBadgeShape.CIRCLE || widget.vtsShape == VTSBadgeShape.SQUARE ? getHeight() : null;
    EdgeInsets? getPadding() => widget.padding ?? VTSBadgeStyle.get('padding', selector: widget.vtsShape);
    Color getBackground() => widget.vtsType == VTSBadgeType.OUTLINE ? getSecondaryColor() : getPrimaryColor();
    Color getBorderColor() => widget.vtsType == VTSBadgeType.OUTLINE ? getPrimaryColor() : getSecondaryColor();
    Color getFontColor() => widget.vtsType == VTSBadgeType.OUTLINE ? getPrimaryColor() : getSecondaryColor();

    return Container(
      child: Stack(
        children: <Widget>[
          widget.parent!,
          Positioned(
            left: VTSBadgeStyle.get('LTRB', selector: widget.vtsPosition)[0],
            top: VTSBadgeStyle.get('LTRB', selector: widget.vtsPosition)[1],
            right: VTSBadgeStyle.get('LTRB', selector: widget.vtsPosition)[2],
            bottom: VTSBadgeStyle.get('LTRB', selector: widget.vtsPosition)[3],
            child: FractionalTranslation(
              translation: widget.offset ?? VTSBadgeStyle.get('translation', selector: widget.vtsPosition),
              child: Material(
                type: MaterialType.button,
                textStyle: 
                  widget.textStyle 
                  ?? TextStyle(
                    color: getFontColor(),
                    fontSize: VTSBadgeStyle.get('fontSize'),
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontFamily: VTSCommon.DEFAULT_FONT_FAMILY
                  ),
                shape: RoundedRectangleBorder(        
                  borderRadius: VTSBadgeStyle.get('borderRadius', selector: widget.vtsShape),
                  side: BorderSide(
                    width: 1,
                    color: getBorderColor()
                  )
                ),
                color: getBackground(),
                child: Container(
                  height: getHeight(),
                  width: getWidth(),
                  padding: getPadding(), 
                  child: Center(
                    child: Text(widget.text ?? '', textAlign: TextAlign.center)
                  )
                )
              ),
            )
          ),
        ],
      ),
    );
  }
}
