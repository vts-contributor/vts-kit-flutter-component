library shimmer;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// An enum defines all supported directions of shimmer effect
///
/// * [VTSShimmerDirection.ltr] left to right direction
/// * [VTSShimmerDirection.rtl] right to left direction
/// * [VTSShimmerDirection.ttb] top to bottom direction
/// * [VTSShimmerDirection.btt] bottom to top direction
///
enum VTSShimmerDirection { ltr, rtl, ttb, btt }

///
/// A widget renders shimmer effect over [child] widget tree.
///
/// [child] defines an area that shimmer effect blends on. You can build [child]
/// from whatever [Widget] you like but there're some notices in order to get
/// exact expected effect and get better rendering performance:
///
/// * Use static [Widget] (which is an instance of [StatelessWidget]).
/// * [Widget] should be a solid color element. Every colors you set on these
/// [Widget]s will be overridden by colors of [gradient].
/// * Shimmer effect only affects to opaque areas of [child], transparent areas
/// still stays transparent.
///
/// [period] controls the speed of shimmer effect. The default value is 1500
/// milliseconds.
///
/// [direction] controls the direction of shimmer effect. The default value
/// is [VTSShimmerDirection.ltr].
///
/// [gradient] controls colors of shimmer effect.
///
/// [loop] the number of animation loop, set value of `0` to make animation run
/// forever.
///
/// [enabled] controls if shimmer effect is active. When set to false the animation
/// is paused
///
///
/// ## Pro tips:
///
/// * [child] should be made of basic and simple [Widget]s, such as [Container],
/// [Row] and [Column], to avoid side effect.
///
/// * use one [VTSShimmer] to wrap list of [Widget]s instead of a list of many [VTSShimmer]s
///
@immutable
class VTSShimmer extends StatefulWidget {
  const VTSShimmer({
    Key? key,
    required this.child,
    required this.gradient,
    this.direction = VTSShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
  }) : super(key: key);

  ///
  /// A convenient constructor provides an easy and convenient way to create a
  /// [VTSShimmer] which [gradient] is [LinearGradient] made up of `baseColor` and
  /// `highlightColor`.
  ///
  VTSShimmer.fromColors({
    Key? key,
    required this.child,
    required Color baseColor,
    required Color highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = VTSShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
  })  : gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              baseColor,
              baseColor,
              highlightColor,
              baseColor,
              baseColor
            ],
            stops: const <double>[
              0.0,
              0.35,
              0.5,
              0.65,
              1.0
            ]),
        super(key: key);

  final Widget child;
  final Duration period;
  final VTSShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  @override
  _VTSShimmerState createState() => _VTSShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(EnumProperty<VTSShimmerDirection>('direction', direction));
    properties.add(
        DiagnosticsProperty<Duration>('period', period, defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: null));
    properties.add(DiagnosticsProperty<int>('loop', loop, defaultValue: 0));
  }
}

class _VTSShimmerState extends State<VTSShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (widget.loop <= 0) {
          _controller.repeat();
        } else if (_count < widget.loop) {
          _controller.forward(from: 0.0);
        }
      });
    if (widget.enabled) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(VTSShimmer oldWidget) {
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (BuildContext context, Widget? child) => _Shimmer(
          child: child,
          direction: widget.direction,
          gradient: widget.gradient,
          percent: _controller.value,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _Shimmer extends SingleChildRenderObjectWidget {
  const _Shimmer({
    Widget? child,
    required this.percent,
    required this.direction,
    required this.gradient,
  }) : super(child: child);

  final double percent;
  final VTSShimmerDirection direction;
  final Gradient gradient;

  @override
  _ShimmerFilter createRenderObject(BuildContext context) =>
      _ShimmerFilter(percent, direction, gradient);

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer.direction = direction;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  _ShimmerFilter(this._percent, this._direction, this._gradient);

  VTSShimmerDirection _direction;
  Gradient _gradient;
  double _percent;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  set direction(VTSShimmerDirection newDirection) {
    if (newDirection == _direction) {
      return;
    }
    _direction = newDirection;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;
      Rect rect;
      double dx, dy;
      if (_direction == VTSShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      } else if (_direction == VTSShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else if (_direction == VTSShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      }
      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) =>
      start + (end - start) * percent;
}
