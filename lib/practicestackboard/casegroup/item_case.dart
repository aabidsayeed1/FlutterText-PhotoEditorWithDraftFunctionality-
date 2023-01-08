//* configuration item
// ignore_for_file: unused_element
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:photo_editor/practicestackboard/helper/case_style.dart';
import 'package:photo_editor/practicestackboard/helper/ex_value_builder.dart';
import 'package:photo_editor/practicestackboard/helper/operate_state.dart';

import '../helper/get_size.dart';
import '../helper/safe_state.dart';
import '../helper/safe_value_notifier.dart';

class _Config {
  _Config({this.size, this.offset, this.angle});

  /// default allocation
  _Config.def({this.offset = Offset.zero, this.angle = 0});

  /// size
  Size? size;

  /// Location
  Offset? offset;

  /// angle
  double? angle;

  /// copy
  _Config copy({Size? size, Offset? offset, double? angle}) => _Config(
      size: size ?? this.size,
      offset: offset ?? this.offset,
      angle: angle ?? this.angle);
}

/// Operating shell
class ItemCase extends StatefulWidget {
  const ItemCase({
    Key? key,
    required this.child,
    this.isCenter = true,
    this.tools,
    this.caseStyle = const CaseStyle(),
    this.tapToEdit = false,
    this.operateState = OperateState.idle,
    this.canEdit = false,
    this.onDel,
    this.onSizeChanged,
    this.onOperateStateChanged,
    this.onOffsetChanged,
    this.onAngleChanged,
    this.onTap,
  }) : super(key: key);

  @override
  State<ItemCase> createState() => _ItemCaseState();

  /// child control
  final Widget child;

  /// tool layer
  final Widget? tools;

  //Whether to perform center alignment (auto wrap Center)
  final bool isCenter;

  /// Can edit
  final bool canEdit;

  /// Frame style
  final CaseStyle? caseStyle;

  /// Click to edit, default false
  final bool tapToEdit;

  /// Operating status
  final OperateState? operateState;

  /// Remove interception
  final void Function()? onDel;

  /// Click callback
  final void Function()? onTap;

  /// Size change callback /// The return value can control whether to continue
  final bool? Function(Size size)? onSizeChanged;

  ///Position change callback
  final bool? Function(Offset offset)? onOffsetChanged;

  /// Angle change callback
  final bool? Function(double offset)? onAngleChanged;

  /// Operation status callback
  final bool? Function(OperateState)? onOperateStateChanged;
}

class _ItemCaseState extends State<ItemCase> with SafeState<ItemCase> {
  /// Basic parameter status
  late SafeValueNotifier<_Config> _config;

  /// Operating status
  late OperateState _operateState;

  /// Frame style
  CaseStyle get _caseStyle => widget.caseStyle ?? const CaseStyle();

  @override
  void initState() {
    super.initState();
    _operateState = widget.operateState ?? OperateState.idle;
    _config = SafeValueNotifier<_Config>(_Config.def());
    _config.value.offset = widget.caseStyle?.initOffset;
  }

  @override
  void didUpdateWidget(covariant ItemCase oldWidget) {
    if (widget.operateState != null &&
        widget.operateState != oldWidget.operateState) {
      _operateState = widget.operateState!;
      safeSetState(() {});
      widget.onOperateStateChanged?.call(_operateState);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _config.dispose();
    super.dispose();
  }

  /// click
  void _onTap() {
    if (widget.tapToEdit) {
      if (_operateState != OperateState.editing) {
        _operateState = OperateState.editing;
        safeSetState(() {});
      }
    } else if (_operateState == OperateState.complete) {
      safeSetState(() => _operateState = OperateState.idle);
    }
    widget.onTap?.call();
    widget.onOperateStateChanged?.call(_operateState);
  }

  /// Switch back to normal state
  void _changeToIdle() {
    if (_operateState != OperateState.idle) {
      _operateState = OperateState.idle;
      widget.onOperateStateChanged?.call(_operateState);
      safeSetState(() {});
    }
  }

  /// Move operation
  void _moveHandle(DragUpdateDetails dud) {
    if (_operateState != OperateState.moving) {
      if (_operateState == OperateState.scalling ||
          _operateState == OperateState.rotating) {
        _operateState = OperateState.moving;
      } else {
        _operateState = OperateState.moving;
        safeSetState(() {});
      }
      widget.onOperateStateChanged?.call(_operateState);
    }
    final double angle = _config.value.angle ?? 0;
    final double sina = math.sin(-angle);
    final double cona = math.cos(-angle);
    Offset d = dud.delta;
    final Offset changeTo =
        _config.value.offset?.translate(d.dx, d.dy) ?? Offset.zero;

    // vector rotation
    d = Offset(sina * d.dy + cona * d.dx, cona * d.dy - sina * d.dx);
    final Offset? realOffset = _config.value.offset?.translate(d.dx, d.dy);
    if (realOffset == null) return;

    // mobile interception
    if (!(widget.onOffsetChanged?.call(realOffset) ?? true)) return;
    _config.value = _config.value.copy(offset: realOffset);
    widget.onOffsetChanged?.call(changeTo);
  }

  /// zoom operation
  void _scaleHandle(DragUpdateDetails dud) {
    if (_operateState != OperateState.scalling) {
      if (_operateState == OperateState.moving ||
          _operateState == OperateState.rotating) {
        _operateState = OperateState.scalling;
      } else {
        _operateState = OperateState.scalling;
        safeSetState(() {});
      }
      widget.onOperateStateChanged?.call(_operateState);
    }
    if (_config.value.offset == null) return;
    if (_config.value.size == null) return;

    final double angle = _config.value.angle ?? 0;
    final double fsina = math.sin(-angle);
    final double fcosa = math.cos(-angle);
    final Offset d = dud.globalPosition;
    // to maintain the size of icons while scalling
    final double min = _caseStyle.iconSize * 3;
    Offset start = _config.value.offset! +
        Offset(-_caseStyle.iconSize / 2, _caseStyle.iconSize * 2);
    start = Offset(fsina * start.dy + fcosa * start.dx,
        fcosa * start.dy - fsina * start.dx);

    double w = d.dx - start.dx;
    double h = d.dy - start.dy;

    // reached minimum value
    if (w < min) w = min;
    if (h < min) h = min;

    Size s = Size(w, h);
    if (d.dx < 0 && s.width < min) s = Size(min, h);
    if (d.dy < 0 && s.height < min) s = Size(w, min);

    // zoom intercept

    if (!(widget.onSizeChanged?.call(s) ?? true)) return;
    if (widget.caseStyle?.boxAspectRatio != null) {
      if (s.width < s.height) {
        _config.value.size =
            Size(s.width, s.width / widget.caseStyle!.boxAspectRatio!);
      } else {
        _config.value.size =
            Size(s.height * widget.caseStyle!.boxAspectRatio!, s.height);
      }
    } else {
      _config.value.size = s;
    }
    _config.value = _config.value.copy();
  }

  /// Rotation operation
  void _rotateHandle(DragUpdateDetails dud) {
    if (_operateState != OperateState.rotating) {
      if (_operateState == OperateState.moving ||
          _operateState == OperateState.scalling) {
        _operateState = OperateState.rotating;
      } else {
        _operateState = OperateState.rotating;
        safeSetState(() {});
      }
      widget.onOperateStateChanged?.call(_operateState);
    }
    if (_config.value.size == null) return;
    if (_config.value.offset == null) return;
    final Offset start = _config.value.offset!;
    final Offset global = dud.globalPosition
        .translate(_caseStyle.iconSize / 2, _caseStyle.iconSize * 2.5);
    final Size size = _config.value.size!;
    final Offset center =
        Offset(start.dx + size.width / 2, start.dy + size.height / 2);
    final double l = (global - center).distance;
    final double s = (global.dy - center.dy).abs();
    double angle = math.asin(s / l);
    if (global.dx < center.dx) {
      if (global.dy < center.dy) {
        angle = math.pi + angle;
        // print('fourth quadrant');
      } else {
        angle = math.pi - angle;
        // print('third quadrant');
      }
    } else {
      if (global.dy < center.dy) {
        angle = 2 * math.pi - angle;
        // print('first quadrant');
      }
    }
    //rotation interception
    if (!(widget.onAngleChanged?.call(angle) ?? true)) return;

    _config.value = _config.value.copy(angle: angle);
  }

  /// Rotate back to 0 degrees
  void _turnback() {
    if (_config.value.angle != 0) {
      _config.value = _config.value.copy(angle: 0);
    }
  }

  /// Body mouse pointer style

  MouseCursor get _cursor {
    if (_operateState == OperateState.moving) {
      return SystemMouseCursors.grabbing;
    } else if (_operateState == OperateState.editing) {
      return SystemMouseCursors.click;
    }
    return SystemMouseCursors.grab;
  }

  @override
  Widget build(BuildContext context) {
    return ExValueBuilder<_Config>(
        shouldRebuild: (_Config? p, _Config? n) =>
            p?.offset != n?.offset || p?.angle != n?.angle,
        valueListenable: _config,
        child: MouseRegion(
          cursor: _cursor,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanUpdate: _moveHandle,
            onPanEnd: (_) => _changeToIdle(),
            onTap: _onTap,
            child: Stack(children: [
              _border,
              _child,
              if (widget.tools != null) _tools,
              if (widget.canEdit && _operateState != OperateState.complete)
                _edit,
              if (_operateState != OperateState.complete) _rotate,
              if (_operateState != OperateState.complete) _check,
              if (widget.onDel != null &&
                  _operateState != OperateState.complete)
                _del,
              if (_operateState != OperateState.complete) _scale,
            ]),
          ),
        ),
        builder: (_, _Config? c, Widget? child) {
          return Positioned(
              top: c?.offset?.dy ?? 0,
              left: c?.offset?.dx ?? 0,
              child: Transform.rotate(
                angle: c?.angle ?? 0,
                child: child,
              ));
        });
  }

  /// child control
  Widget get _child {
    Widget content = widget.child;
    if (_config.value.size == null) {
      content = GetSize(
        onChange: ((Size? size) {
          if (size != null && _config.value.size == null) {
            _config.value.size = Size(size.width + _caseStyle.iconSize + 40,
                size.height + _caseStyle.iconSize + 40);
            safeSetState(() {});
          }
        }),
        child: content,
      );
    }
    if (widget.isCenter) content = Center(child: content);

    return ExValueBuilder<_Config>(
      shouldRebuild: ((_Config? previous, _Config? next) =>
          previous?.size != next?.size),
      valueListenable: _config,
      builder: ((_, _Config? c, Widget? child) => SizedBox.fromSize(
            size: c?.size,
            child: child,
          )),
      child: Padding(
        padding: EdgeInsets.all(_caseStyle.iconSize / 2),
        child: content,
      ),
    );
  }

  /// border

  Widget get _border {
    return Positioned(
        top: _caseStyle.iconSize / 2,
        bottom: _caseStyle.iconSize / 2,
        left: _caseStyle.iconSize / 2,
        right: _caseStyle.iconSize / 2,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: _operateState == OperateState.complete
                ? Colors.transparent
                : _caseStyle.borderColor,
            width: _caseStyle.borderWidth * 2,
          )),
        ));
  }

  Widget get _edit {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (_operateState == OperateState.editing) {
            _operateState = OperateState.idle;
          } else {
            _operateState = OperateState.editing;
          }
          safeSetState(() {});
          widget.onOperateStateChanged?.call(_operateState);
        },
        child: _toolCase(Icon(_operateState == OperateState.editing
            ? Icons.border_color
            : Icons.edit)),
      ),
    );
  }

  /// Delete handle
  Widget get _del {
    return Positioned(
        top: 0,
        right: 0,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget.onDel?.call(),
            child: _toolCase(const Icon(Icons.clear)),
          ),
        ));
  }

  /// Zoom handle
  Widget get _scale {
    return Positioned(
        bottom: 0,
        right: 0,
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeUpLeftDownRight,
          child: GestureDetector(
            onPanUpdate: _scaleHandle,
            onPanEnd: (_) => _changeToIdle(),
            child: _toolCase(const RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.open_in_full_outlined),
            )),
          ),
        ));
  }

  /// Rotate the handle
  Widget get _rotate {
    return Positioned(
        top: 0,
        bottom: 0,
        right: 0,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onPanUpdate: _rotateHandle,
            onPanEnd: (_) => _changeToIdle(),
            onDoubleTap: _turnback,
            child: _toolCase(const RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.refresh,
              ),
            )),
          ),
        ));
  }

  /// Complete the operation
  Widget get _check {
    return Positioned(
        bottom: 0,
        left: 0,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (_operateState != OperateState.complete) {
                _operateState = OperateState.complete;
                safeSetState(() {});
                widget.onOperateStateChanged?.call(_operateState);
              }
            },
            child: _toolCase(const Icon(Icons.check)),
          ),
        ));
  }

  /// Operating handle shell
  Widget _toolCase(Widget child) {
    return Container(
      width: _caseStyle.iconSize,
      height: _caseStyle.iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _caseStyle.borderColor,
      ),
      child: IconTheme(
        data: Theme.of(context).iconTheme.copyWith(
              color: _caseStyle.iconColor,
              size: _caseStyle.iconSize * 0.6,
            ),
        child: child,
      ),
    );
  }

  /// toolbar
  Widget get _tools {
    return Positioned(
        left: _caseStyle.iconSize / 2,
        top: _caseStyle.iconSize / 2,
        right: _caseStyle.iconSize / 2,
        bottom: _caseStyle.iconSize / 2,
        child: widget.tools!);
  }
}
