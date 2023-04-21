import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

abstract class VTSTouchEvent {
  Offset? get localPosition => null;

  bool get isInterestedForInteractions => this is! VTSPanEndEvent &&
        this is! VTSPanCancelEvent &&
        this is! VTSPointerExitEvent &&
        this is! VTSLongPressEnd &&
        this is! VTSTapUpEvent &&
        this is! VTSTapCancelEvent;
}

class VTSPanDownEvent extends VTSTouchEvent {
  VTSPanDownEvent(this.details);

  final DragDownDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSPanStartEvent extends VTSTouchEvent {
  VTSPanStartEvent(this.details);

  final DragStartDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSPanUpdateEvent extends VTSTouchEvent {
  VTSPanUpdateEvent(this.details);

  final DragUpdateDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSPanCancelEvent extends VTSTouchEvent {}

class VTSPanEndEvent extends VTSTouchEvent {
  VTSPanEndEvent(this.details);

  final DragEndDetails details;
}

class VTSTapDownEvent extends VTSTouchEvent {
  VTSTapDownEvent(this.details);

  final TapDownDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSTapCancelEvent extends VTSTouchEvent {}

class VTSTapUpEvent extends VTSTouchEvent {
  VTSTapUpEvent(this.details);

  final TapUpDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSLongPressStart extends VTSTouchEvent {
  VTSLongPressStart(this.details);

  final LongPressStartDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSLongPressMoveUpdate extends VTSTouchEvent {
  VTSLongPressMoveUpdate(this.details);

  final LongPressMoveUpdateDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSLongPressEnd extends VTSTouchEvent {
  VTSLongPressEnd(this.details);

  final LongPressEndDetails details;

  @override
  Offset get localPosition => details.localPosition;
}

class VTSPointerEnterEvent extends VTSTouchEvent {
  VTSPointerEnterEvent(this.event);

  final PointerEnterEvent event;

  @override
  Offset get localPosition => event.localPosition;
}

class VTSPointerHoverEvent extends VTSTouchEvent {
  VTSPointerHoverEvent(this.event);

  final PointerHoverEvent event;

  @override
  Offset get localPosition => event.localPosition;
}

class VTSPointerExitEvent extends VTSTouchEvent {
  VTSPointerExitEvent(this.event);

  final PointerExitEvent event;

  @override
  Offset get localPosition => event.localPosition;
}
