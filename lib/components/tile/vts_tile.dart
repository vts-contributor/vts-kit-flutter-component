import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/components/tile/styles.dart';
import 'package:vts_component/vts_component.dart';

class VTSTile extends StatelessWidget {
  const VTSTile({
    Key? key,
    this.elevation = 1,
    this.clipBehavior = Clip.none,

    this.title,
    this.titleText,
    this.titleIcon,
    this.imageProvider,
    this.imageShape = VTSAvatarShape.CIRCLE,
    this.subTitleText,

    this.description,
    this.descriptionText,
    this.descriptionAlignment = Alignment.centerRight,

    this.fontColor,
    this.titleFontColor,
    this.subtitleFontColor,
    this.descriptionFontColor,

    this.background,
    this.backgroundImg,
    this.backgroundColorFilter,
    this.padding,
    this.margin,
    this.boxDecoration,
    this.borderRadius,

  }) : assert(elevation >= 0.0), 
       super(key: key);

  /// The z-coordinate at which to place this tile. This controls the size of the shadow below the tile.
  final double elevation;

  /// Material's clipBehavior
  final Clip clipBehavior;

  /// Custom tile's title (Left part)
  /// All title, subtitle, image properties will be unused
  final Widget? title;

  /// Tile's title
  final String? titleText;

  /// Tile's icon placed next to title
  final Icon? titleIcon;

  /// Tile's image (avatar)
  final ImageProvider? imageProvider;

  /// Tile's image shape of type [VTSAvatarShape]
  final VTSAvatarShape imageShape;

  /// Tile's subtitle
  final String? subTitleText;

  /// Custom tile's description (Right part)
  /// [descriptionText] will be unused
  final Widget? description;

  /// Tile's description in text
  final String? descriptionText;

  /// Tile's description placement
  final Alignment descriptionAlignment;

  /// Tile's overall font color
  final Color? fontColor;

  /// Tile's specific title's font color
  final Color? titleFontColor;

  /// Tile's specific subtitle's font color
  final Color? subtitleFontColor;

  /// Tile's specific description's font color
  final Color? descriptionFontColor;

  /// Tile's background color
  final Color? background;

  /// Tile's background image
  final ImageProvider? backgroundImg;

  /// [backgroundImg] colorFilter
  final ColorFilter? backgroundColorFilter;

  /// Custom card boxDecoration
  /// All background properties will be unused
  final Decoration? boxDecoration;

  /// Tile's margin
  final EdgeInsetsGeometry? margin;

  /// Tile's padding
  final EdgeInsetsGeometry? padding;

  /// Tile's border radius
  final BorderRadius? borderRadius;


  Widget renderTitle(BuildContext context) =>
    title ??
    Container(
      padding: VTSTileStyle.get('titlePadding'),
      child: IntrinsicHeight(
        child: Row(
          children: [
            imageProvider != null
            ? Container(
              child: VTSAvatar(
                imageProvider: imageProvider,
                vtsShape: imageShape,
                margin: VTSTileStyle.get('imageMargin'),
                size: VTSTileStyle.get('imageSize'),
              )
            ) : const SizedBox.shrink(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                    style: VTSTileStyle.get('titleTextStyle'),
                    child: Row(
                      children: [
                        titleIcon == null
                        ? const SizedBox.shrink()
                        : IconTheme(
                          data: IconThemeData(
                            color: titleFontColor ?? fontColor ?? VTSTileStyle.get('titleTextStyle')?.color,
                            size: VTSTileStyle.get('titleIconSize')
                          ),
                          child: titleIcon!
                        ),
                        titleIcon != null ? const SizedBox(width: 8.0) : const SizedBox.shrink(),
                        Text(titleText ?? '', style: TextStyle(color: titleFontColor ?? fontColor))
                      ]
                    )
                  ),
                ),
                subTitleText != null
                ? Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                    style: VTSTileStyle.get('subtitleTextStyle'),
                    child: Text(subTitleText ?? '', style: TextStyle(color: subtitleFontColor ?? fontColor))
                  )
                ) : const SizedBox.shrink()
              ],
            )
          ],
        )
      ) 
    );


  Widget renderDescription(BuildContext context) =>
    Expanded(
      child: Container(
        alignment: descriptionAlignment,
        child: DefaultTextStyle(
          style: VTSTileStyle.get('descriptionTextStyle'),
          child: IconTheme(
            data: IconThemeData(
              color: descriptionFontColor ?? fontColor ?? VTSTileStyle.get('descriptionTextStyle')?.color,
              size: VTSTileStyle.get('titleIconSize')
            ),
            child: 
              description 
              ?? (descriptionText != null 
                ? Text(descriptionText!)
                : const SizedBox.shrink()
              )
          )
        ),
      )
    );

  @override
  Widget build(BuildContext context) {
    final layoutBorderRadius = borderRadius ?? VTSTileStyle.get('containerBorderRadius');

    return Container(
      decoration: boxDecoration ?? BoxDecoration(
        border: VTSTileStyle.get('containerBorder'),
        borderRadius: layoutBorderRadius,
        color: 
          backgroundImg == null 
          ? background ?? VTSTileStyle.get('containerBackground') 
          : null,
        image: backgroundImg == null 
          ? null 
          : DecorationImage(
            image: backgroundImg!,
            fit: BoxFit.cover,
            colorFilter: backgroundColorFilter
          )
      ),
      margin: margin ?? VTSTileStyle.get('containerMargin'),
      padding: padding ?? VTSTileStyle.get('containerPadding'),
      child: Material(
        type: MaterialType.card,
        color: VTSColors.TRANSPARENT,
        shadowColor: VTSColors.TRANSPARENT,
        borderRadius: layoutBorderRadius,
        clipBehavior: clipBehavior,
        elevation: elevation,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              renderTitle(context),
              renderDescription(context)
            ],
          ),
        ),
      )
    );
  }
}
