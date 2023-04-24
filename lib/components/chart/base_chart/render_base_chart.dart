import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'base_chart_data.dart';
import 'vts_touch_event.dart';

abstract class RenderBaseChart<R extends BaseTouchResponse> extends RenderBox
    implements MouseTrackerAnnotation {
  RenderBaseChart(VTSTouchData<R>? touchData, BuildContext context)
      : _buildContext = context {
    updateBaseTouchData(touchData);
    initGestureRecognizers();
  }

  BuildContext get buildContext => _buildContext;
  BuildContext _buildContext;
  set buildContext(BuildContext value) {
    _buildContext = value;
    markNeedsPaint();
  }

  void updateBaseTouchData(VTSTouchData<R>? value) {
    _touchCallback = value?.touchCallback;
  }

  BaseTouchCallback<R>? _touchCallback;
  MouseCursorResolver<R>? _mouseCursorResolver;
  Duration? _longPressDuration;

  MouseCursor _latestMouseCursor = MouseCursor.defer;

  late bool _validForMouseTracker;

  late PanGestureRecognizer _panGestureRecognizer;

  late TapGestureRecognizer _tapGestureRecognizer;

  late LongPressGestureRecognizer _longPressGestureRecognizer;

  void initGestureRecognizers() {
    _panGestureRecognizer = PanGestureRecognizer();
    _panGestureRecognizer
      ..onDown = (dragDownDetails) {
        _notifyTouchEvent(VTSPanDownEvent(dragDownDetails));
      }
      ..onStart = (dragStartDetails) {
        _notifyTouchEvent(VTSPanStartEvent(dragStartDetails));
      }
      ..onUpdate = (dragUpdateDetails) {
        _notifyTouchEvent(VTSPanUpdateEvent(dragUpdateDetails));
      }
      ..onCancel = () {
        _notifyTouchEvent(VTSPanCancelEvent());
      }
      ..onEnd = (dragEndDetails) {
        _notifyTouchEvent(VTSPanEndEvent(dragEndDetails));
      };

    _tapGestureRecognizer = TapGestureRecognizer();
    _tapGestureRecognizer
      ..onTapDown = (tapDownDetails) {
        _notifyTouchEvent(VTSTapDownEvent(tapDownDetails));
      }
      ..onTapCancel = () {
        _notifyTouchEvent(VTSTapCancelEvent());
      }
      ..onTapUp = (tapUpDetails) {
        _notifyTouchEvent(VTSTapUpEvent(tapUpDetails));
      };

    _longPressGestureRecognizer =
        LongPressGestureRecognizer(duration: _longPressDuration);
    _longPressGestureRecognizer
      ..onLongPressStart = (longPressStartDetails) {
        _notifyTouchEvent(VTSLongPressStart(longPressStartDetails));
      }
      ..onLongPressMoveUpdate = (longPressMoveUpdateDetails) {
        _notifyTouchEvent(
          VTSLongPressMoveUpdate(longPressMoveUpdateDetails),
        );
      }
      ..onLongPressEnd = (longPressEndDetails) =>
          _notifyTouchEvent(VTSLongPressEnd(longPressEndDetails));
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => Size(constraints.maxWidth, constraints.maxHeight);

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (_touchCallback == null) {
      return;
    }
    if (event is PointerDownEvent) {
      _longPressGestureRecognizer.addPointer(event);
      _tapGestureRecognizer.addPointer(event);
      _panGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent) {
      _notifyTouchEvent(VTSPointerHoverEvent(event));
    }
  }

  @override
  PointerEnterEventListener? get onEnter =>
      (event) => _notifyTouchEvent(VTSPointerEnterEvent(event));

  @override
  PointerExitEventListener? get onExit =>
      (event) => _notifyTouchEvent(VTSPointerExitEvent(event));

  void _notifyTouchEvent(VTSTouchEvent event) {
    if (_touchCallback == null) {
      return;
    }
    final localPosition = event.localPosition;
    R? response;
    if (localPosition != null) {
      response = getResponseAtLocation(localPosition);
    }
    _touchCallback!(event, response);

    if (_mouseCursorResolver == null) {
      _latestMouseCursor = MouseCursor.defer;
    } else {
      _latestMouseCursor = _mouseCursorResolver!(event, response);
    }
  }


  @override
  MouseCursor get cursor => _latestMouseCursor;

  @override
  bool get validForMouseTracker => _validForMouseTracker;


  R getResponseAtLocation(Offset localPosition);

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    super.detach();
  }
}
