import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    this.onTap,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  final Widget icon;
  final VoidCallback? onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return Padding(
      padding: margin,
      child: !kIsWeb &&
              (platform == TargetPlatform.iOS ||
                  platform == TargetPlatform.macOS)
          ? CupertinoButton(
              onPressed: onTap,
              padding: padding,
              child: icon,
            )
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(100.0),
              child: Padding(
                padding: padding,
                child: icon,
              ),
            ),
    );
  }
}
