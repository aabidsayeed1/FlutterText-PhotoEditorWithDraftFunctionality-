import 'package:flutter/material.dart';
import 'package:photo_editor/practicestackboard/helper/case_style.dart';
import 'package:photo_editor/practicestackboard/itemgroup/stack_board_item.dart';

/// adaptive text
class AdaptiveText extends StackBoardItem {
  const AdaptiveText(
    this.data, {
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticslabel,
    final int? id,
    final Future<bool> Function()? onDel,
    CaseStyle? caseStyle,
    bool? tapToEdit,
  }) : super(
            id: id,
            onDel: onDel,
            child: const SizedBox.shrink(),
            caseStyle: caseStyle,
            tapToEdit: tapToEdit ?? false);

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticslabel;
  @override
  AdaptiveText copyWith({
    String? data,
    int? id,
    Widget? child,
    Function(bool)? onEdit,
    Future<bool> Function()? onDel,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticslabel,
    CaseStyle? caseStyle,
    bool? tapToEdit,
  }) {
    return AdaptiveText(
      data ?? this.data,
      id: id ?? this.id,
      onDel: onDel ?? this.onDel,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      maxLines: maxLines ?? this.maxLines,
      semanticslabel: semanticslabel ?? this.semanticslabel,
      caseStyle: caseStyle ?? this.caseStyle,
      tapToEdit: tapToEdit ?? this.tapToEdit,
    );
  }
}
