import 'package:flutter/widgets.dart';
import 'package:vts_component/components/avatar/index.dart';
import 'package:vts_component/components/avatar/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSAvatar extends StatelessWidget {
  const VTSAvatar(
    {
      Key? key,
      this.imageProvider,
      this.vtsShape = VTSAvatarShape.STANDARD,
      this.vtsSize = VTSAvatarSize.SM,
      this.size,
      this.boxFit = BoxFit.cover,
      this.colorFilter,
      this.borderSide = BorderSide.none,
      this.margin
    }) : super(key: key);

  /// The image of avatar
  final ImageProvider? imageProvider;
  
  /// shape of avatar [VTSAvatarShape] i.e, standard, circle, square
  final VTSAvatarShape vtsShape;

  /// Size of [VTSAvatarSize] i.e, sm, md, lg, xl, xxl
  final VTSAvatarSize vtsSize;

  /// Size of avatar in double
  final double? size;

  /// How the image should be inscribed into the box.
  final BoxFit? boxFit;

  /// A color filter to apply to the image before painting it.
  final ColorFilter? colorFilter;

  /// A border to draw around the [VTSAvatar].
  final BorderSide borderSide;

  /// Margin around [VTSAvatar]
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    double getSize() => size ?? VTSAvatarStyle.get('size', selector: vtsSize);

    return Container(
      margin: margin,
      constraints: BoxConstraints(
        minHeight: getSize(),
        minWidth: getSize(),
        maxWidth: getSize(),
        maxHeight: getSize(),
      ),
      decoration: ShapeDecoration(
        image: imageProvider != null
        ? DecorationImage(
            image: imageProvider!,
            fit: boxFit,
            colorFilter: colorFilter
          )
        : null,
        shape: RoundedRectangleBorder(
          borderRadius: VTSAvatarStyle.get('borderRadius', selector: vtsShape),
          side: borderSide
        )
      )
    );
  }
}
