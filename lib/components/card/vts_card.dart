import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_component/components/card/styles.dart';
import 'package:vts_component/common/style/vts_common.dart';

import 'package:vts_component/vts_component.dart';

class VTSCard extends StatelessWidget {
  const VTSCard(
      {Key? key,
      this.vtsType = VTSCardType.BASIC,
      
      this.elevation = 1,
      this.clipBehavior = Clip.none,

      this.background,
      this.backgroundImg,
      this.backgroundColorFilter,

      this.fontColor,
      this.titleFontColor,
      this.subtitleFontColor,
      this.bodyFontColor,

      this.padding,
      this.margin,
      this.boxDecoration,
      this.borderRadius,

      this.title,
      this.subtitle,
      this.header,

      this.anchorActions,
      this.anchorTop,
      this.anchorRight,

      this.body,
      this.bodyText,
      this.bodyMaxLine,

      this.footer,
      this.footerActions,
      this.footerButtons,
      this.footerRowAlignment,

      this.imageProvider,
      this.imageWidthPercent = 33.33333,
    }) : assert(elevation == null || elevation >= 0.0),
         super(key: key);

  /// Tab type of [VTSCardType] i.e, basic, avatar, full image
  final VTSCardType vtsType;

  /// The z-coordinate at which to place this card. This controls the size of the shadow below the card.
  final double elevation;

  /// Material's clipBehavior
  final Clip clipBehavior;

  /// Card's background color
  final Color? background;

  /// Card's background image
  final ImageProvider? backgroundImg;

  /// [backgroundImg] colorFilter
  final ColorFilter? backgroundColorFilter;

  /// Card's overall font color
  final Color? fontColor;

  /// Card's specific title's font color
  final Color? titleFontColor;

  /// Card's specific subtitle's font color
  final Color? subtitleFontColor;

  /// Card's specific body's font color
  final Color? bodyFontColor;

  /// Card's padding
  final EdgeInsetsGeometry? padding;

  /// Card's margin
  final EdgeInsetsGeometry? margin;

  /// Custom card boxDecoration
  /// All background properties will be unused
  final Decoration? boxDecoration;

  /// Card's border radius
  final BorderRadius? borderRadius;

  /// Card's title
  final String? title;

  /// Card's subtitle
  final String? subtitle;

  /// Custom card's header part
  /// [title] and [subtitle] will be unused
  final Widget? header;

  /// Actions placed at top-right corner
  final List<Widget>? anchorActions;

  /// Specific anchor's top position
  final double? anchorTop;

  /// Specific anchor's right position
  final double? anchorRight;

  /// Custom card's body part
  /// [bodyText] will be unused
  final Widget? body;

  /// Card's body text content
  final String? bodyText;

  /// Truncate text on overflow and display least defined number of line
  final int? bodyMaxLine;

  /// Custon card's footer part
  /// [footerActions] and [footerButtons] will be unused
  final Widget? footer;

  /// Render list of buttons seperated with body by a top border 
  final List<VTSButton>? footerActions;

  /// Render list of buttons
  final List<VTSButton>? footerButtons;

  /// Custom alignment for list of buttons
  final MainAxisAlignment? footerRowAlignment;

  /// ImageProvider for [VTSCardType.AVATAR] and [VTSCardType.FULL_IMAGE]
  final ImageProvider? imageProvider;

  /// Custom width of image to percentage width of card
  /// Only use for [VTSCardType.FULL_IMAGE]
  final double? imageWidthPercent;

  Widget renderHeader(BuildContext context) =>
    header ??
    Container(
      padding: VTSCardStyle.get('headerPadding', selector: vtsType),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DefaultTextStyle(
              style: VTSCardStyle.get('titleTextStyle'),
              child: Text(title ?? '', style: TextStyle(color: titleFontColor ?? fontColor))
            ),
          ),
          subtitle != null 
          ? Align(
            alignment: Alignment.centerLeft,
            child: DefaultTextStyle(
              style: VTSCardStyle.get('subtitleTextStyle'),
              child: Text(subtitle ?? '', style: TextStyle(color: subtitleFontColor ?? fontColor))
            )
          )
          : const SizedBox.shrink()
        ],
      )
    );

  Widget renderFooter(BuildContext context) {
    if (footer != null) return footer!;
    if (footerActions != null)
      return Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: VTSCommon.BORDER_COLOR_LIGHT, width: 1))
        ),
        child: Row(
          mainAxisAlignment: footerRowAlignment ?? (footerActions!.length == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween),
          children: 
            footerActions!.map(
              (e) => Container(
                child: e, 
                padding: VTSCardStyle.get('footerActionPadding')
              )
            ).toList(),
        )
      );

    if (footerButtons != null) {
      return Row(
        mainAxisAlignment: footerRowAlignment ?? MainAxisAlignment.center,
        children: footerButtons!
            .map((e) => Container(
                child: e, padding: VTSCardStyle.get('footerButtonPadding')))
            .toList(),
      );
    }

    return SizedBox(
      height: VTSCardStyle.get('footerMinHeight')
    );
  }

  Widget renderBody(BuildContext context) {
    final content = 
      body ?? 
      (bodyText != null 
        ? Align(
          alignment: Alignment.centerLeft, 
          child: Text(
            bodyText!, style: TextStyle(color: bodyFontColor ?? fontColor), 
            maxLines: bodyMaxLine,
            overflow: bodyMaxLine != null ? TextOverflow.ellipsis : null,
          )
        ) 
        : const SizedBox.shrink()
      );
    return Container(
      padding: VTSCardStyle.get('bodyPadding', selector: vtsType),
      child: DefaultTextStyle(
        style: VTSCardStyle.get('bodyTextStyle'),
        child: Container(child: content)
      )
    );
  }

  Widget renderLayout(BuildContext context) {
    // Variable
    final layoutBorderRadius = borderRadius ?? VTSCardStyle.get('containerBorderRadius');

    // Render

    Widget layout = const SizedBox.shrink();
    if (vtsType == VTSCardType.BASIC)
      layout = Column(
        children: [
          renderHeader(context),
          renderBody(context),
          renderFooter(context),
        ],
      );
    if (vtsType == VTSCardType.AVATAR)
      layout = Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              VTSAvatar(
                imageProvider: imageProvider,
                vtsShape: VTSAvatarShape.CIRCLE,
                margin: VTSCardStyle.get('avatarMargin'),
                size: VTSCardStyle.get('avatarSize'),
              ),
              Expanded(
                child: Column(
                  children: [renderHeader(context)],
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: (VTSCardStyle.get('avatarSize') ?? 0.0) + (VTSCardStyle.get('avatarMargin')?.right ?? 0.0)),
                  child: renderBody(context)
                ) 
              )
            ]
          ),
          renderFooter(context)
        ],
      );

    if (vtsType == VTSCardType.FULL_IMAGE) {
      double imageFlex = imageWidthPercent ?? VTSCardStyle.get('imageWidthPercent') ?? 0; 
      layout = IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: imageFlex.toInt().round(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.merge(VTSCardStyle.get('containerBorder'), const Border(right: BorderSide.none)),
                    borderRadius: BorderRadius.only(
                      topLeft: layoutBorderRadius.topLeft,
                      bottomLeft: layoutBorderRadius.bottomLeft,
                    )
                  ),
                  margin: VTSCardStyle.get('imageMargin'),
                  child: Container(
                    child: VTSImage(
                      boxFit: BoxFit.cover,
                      imageProvider: imageProvider,
                      vtsShape: VTSImageShape.SQUARE,
                      borderRadius: BorderRadius.only(
                        topLeft: layoutBorderRadius.topLeft,
                        bottomLeft: layoutBorderRadius.bottomLeft,
                      )
                    ),
                  ) 
                )
              ),
              Expanded(
                flex: (100 - imageFlex).toInt().round(),
                child: Container(
                  child: Column(
                    children: [
                      renderHeader(context),
                      renderBody(context),
                      renderFooter(context)
                    ],
                  ) 
                ),
              ),
            ]
          ),
      );
    }

    final container = ClipRRect(
      borderRadius: layoutBorderRadius,
      child: Container(
        decoration: boxDecoration ?? BoxDecoration(
          border: VTSCardStyle.get('containerBorder'),
          borderRadius: layoutBorderRadius,
          color: 
            backgroundImg == null 
            ? background ?? VTSCardStyle.get('containerBackground') 
            : null,
          image: backgroundImg == null 
            ? null 
            : DecorationImage(
              image: backgroundImg!,
              fit: BoxFit.cover,
              colorFilter: backgroundColorFilter
            )
        ),
        margin: margin ?? VTSCardStyle.get('containerMargin'),
        padding: padding ?? VTSCardStyle.get('containerPadding', selector: vtsType),
        child: Material(
          type: MaterialType.card,
          color: VTSColors.TRANSPARENT,
          shadowColor: VTSColors.TRANSPARENT,
          borderRadius: layoutBorderRadius,
          clipBehavior: clipBehavior,
          elevation: elevation,
          child: layout,
        )
      )
    );

    return anchorActions == null
        ? container
        : Stack(
          children: [
            container,
            Positioned(
              top: anchorTop ?? VTSCardStyle.get('anchorTop'),
              right: anchorRight ?? VTSCardStyle.get('anchorRight'),
              child: FractionalTranslation(
                translation: const Offset(-0.5, 0.5),
                child: Row(
                  children: anchorActions!.map(
                    (e) => Container(
                      child: e,
                      padding: const EdgeInsets.only(left: 8.0),
                    )
                  ).toList()
                )
              )
            )
          ],
        );
  }

  @override
  Widget build(BuildContext context) => renderLayout(context);
}
