import 'package:flutter/widgets.dart';
import 'package:vts_component/components/image/index.dart';
import 'package:vts_component/components/image/styles.dart';

class VTSImage extends StatelessWidget {
  const VTSImage(
    {
      Key? key,
      this.imageProvider,
      this.vtsShape = VTSImageShape.STANDARD,
      this.width,
      this.height,
      this.boxFit = BoxFit.cover,
      this.colorFilter,
      this.borderSide = BorderSide.none,
      this.margin,
      this.padding,
      this.child,
      this.alignment,
      this.borderRadius
    }) : super(key: key);

  /// The image of avatar
  final ImageProvider? imageProvider;

  /// Width of image in double
  final double? width;

  /// Height of image in double
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit? boxFit;

  /// A color filter to apply to the image before painting it.
  final ColorFilter? colorFilter;

  /// A border to draw around the [VTSImage].
  final BorderSide borderSide;

  /// Border radius of [VTSImage]
  final BorderRadius? borderRadius;

  /// Shape of image [VTSImageShape] i.e, standard, circle, square
  final VTSImageShape vtsShape;

  /// Margin around [VTSImage]
  final EdgeInsetsGeometry? margin;

  /// Inner padding of [VTSImage]
  final EdgeInsetsGeometry? padding;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// Overlay child
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    double? circleSize() => width != null ? width : height;
    double? getWidth() => vtsShape == VTSImageShape.CIRCLE || vtsShape == VTSImageShape.SQUARE 
                          ? circleSize() 
                          : (width ?? MediaQuery.of(context).size.width);
    double? getHeight() => vtsShape == VTSImageShape.CIRCLE || vtsShape == VTSImageShape.SQUARE 
                          ? circleSize() 
                          : height;

    return Container(
      // margin: margin,
      width: getWidth(),
      height: getHeight(),
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: ShapeDecoration(
      image: imageProvider != null
        ? DecorationImage(
            image: imageProvider!,
            fit: boxFit,
            colorFilter: colorFilter
          )
        : null,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? VTSImageStyle.get('borderRadius', selector: vtsShape),
          side: borderSide
        )
      ),
      child: child
    );
  }
}
