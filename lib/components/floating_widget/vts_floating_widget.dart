import 'package:flutter/material.dart';

class VTSFLoatingWidget extends StatefulWidget {
  /// Creates a Floating body can be used to display the quick messages, warning and erros.
  const VTSFLoatingWidget(
      {Key? key,
      this.child,
      this.horizontalPosition,
      this.verticalPosition,
      this.blurnessColor,
      this.showBlurness = false,
      this.body})
      : super(key: key);

  ///child of  type [Widget] which floats across the body based on horizontal and vertical position
  final Widget? child;

  ///body of type [Widget] which is same as Scaffold's body
  final Widget? body;

  /// horizontalPosition of type [double] which  aligns the child horizontally across the body
  final double? horizontalPosition;

  /// verticalPosition of type [double] which  aligns the child vertically across the body
  final double? verticalPosition;

  ///blurnessColor of tye [Color] or [VTSColors] which is used to blur the backgroundColor when ever the [child] is used in [GFFloatingWidget]
  final Color? blurnessColor;

  ///type of bool which allows to show or hide the blurness of the backgroundColor whenever the [child]  is used in [GFFloatingWidget]
  final bool showBlurness;

  @override
  _VTSFLoatingWidgetState createState() => _VTSFLoatingWidgetState();
}

class _VTSFLoatingWidgetState extends State<VTSFLoatingWidget> {
  Widget? child;

  @override
  void initState() {
    child = widget.child;
    super.initState();
  }

  @override
  void didUpdateWidget(VTSFLoatingWidget oldWidget) {
    child = widget.child;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: widget.body ?? Container(),
          ),
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: widget.showBlurness
                  ? widget.blurnessColor ?? Colors.black54
                  : null,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: widget.verticalPosition ?? 0.0,
                    left: widget.horizontalPosition ?? 0.0,
                    child: widget.child ?? Container(),
                  )
                ],
              ),
            ),
          )
        ],
      );
}
