import 'package:flutter/material.dart';
import 'package:photo_editor/practicestackboard/helper/case_style.dart';

/// custom object
@immutable
class StackBoardItem {
  const StackBoardItem({
    required this.child,
    this.id,
    this.onDel,
    this.caseStyle,
    this.tapToEdit = false,
  });

  /// item id
  final int? id;

  /// child control
  final Widget child;

  /// remove callback
  final Future<bool> Function()? onDel;

  /// Frame style
  final CaseStyle? caseStyle;
  // Click to edit
  final bool tapToEdit;

  /// object copy
  StackBoardItem copyWith({
    int? id,
    Widget? child,
    Future<bool> Function()? onDel,
    CaseStyle? caseStyle,
    bool? tapToEdit,
  }) =>
      StackBoardItem(
        id: id ?? this.id,
        child: child ?? this.child,
        onDel: onDel ?? this.onDel,
        caseStyle: caseStyle ?? this.caseStyle,
        tapToEdit: tapToEdit ?? this.tapToEdit,
      );
  // Object comparison
  bool sameWith(StackBoardItem item) => item.id == id;
  @override
  bool operator ==(Object other) => other is StackBoardItem && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
