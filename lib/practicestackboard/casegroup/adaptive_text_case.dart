// Default text style
import 'package:flutter/material.dart';
import 'package:photo_editor/practicestackboard/casegroup/item_case.dart';
import 'package:photo_editor/practicestackboard/helper/operate_state.dart';
import 'package:photo_editor/practicestackboard/helper/safe_state.dart';
import 'package:photo_editor/practicestackboard/itemgroup/adaptive_text.dart';

const TextStyle _defaultStyle = TextStyle(fontSize: 20);

class AdaptiveTextCase extends StatefulWidget {
  const AdaptiveTextCase(
      {super.key,
      required this.adaptiveText,
      this.onDel,
      this.onTap,
      this.operateState});

  @override
  State<AdaptiveTextCase> createState() => _AdaptiveTextCaseState();
  // adaptive text object
  final AdaptiveText adaptiveText;
  // remove interceptio
  final void Function()? onDel;
  // click callback
  final void Function()? onTap;
  // operating status
  final OperateState? operateState;
}

class _AdaptiveTextCaseState extends State<AdaptiveTextCase>
    with SafeState<AdaptiveTextCase> {
  // is editing
  bool _isEditing = false;
  // text content
  late String _text = widget.adaptiveText.data;
  // input box width
  double _textFieldWidth = 100;
  // text style
  TextStyle get _style => widget.adaptiveText.style ?? _defaultStyle;
  // calculate text size
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return ItemCase(
      isCenter: false,
      canEdit: true,
      onTap: widget.onTap,
      tapToEdit: widget.adaptiveText.tapToEdit,
      onDel: widget.onDel,
      operateState: widget.operateState,
      caseStyle: widget.adaptiveText.caseStyle,
      onOperateStateChanged: (OperateState s) {
        if (s != OperateState.editing && _isEditing) {
          safeSetState(() => _isEditing = false);
        } else if (s == OperateState.editing && !_isEditing) {
          safeSetState(() => _isEditing = true);
        }
        return;
      },
      onSizeChanged: (Size s) {
        final Size size = _textSize(_text, _style);
        _textFieldWidth = size.width + 8;
        return;
      },
      child: _isEditing ? _buildEditongBox : _buildTextBox,
    );
  }

// text only
  Widget get _buildTextBox {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          _text,
          style: _style,
          textAlign: widget.adaptiveText.textAlign,
          textDirection: widget.adaptiveText.textDirection,
          locale: widget.adaptiveText.locale,
          softWrap: widget.adaptiveText.softWrap,
          overflow: widget.adaptiveText.overflow,
          textScaleFactor: widget.adaptiveText.textScaleFactor,
          maxLines: widget.adaptiveText.maxLines,
          semanticsLabel: widget.adaptiveText.semanticslabel,
        ),
      ),
    );
  }

// editing
  Widget get _buildEditongBox {
    return FittedBox(
      child: SizedBox(
        width: _textFieldWidth,
        child: TextFormField(
          autofocus: true,
          initialValue: _text,
          onChanged: (String v) => _text = v,
          style: _style,
          textAlign: widget.adaptiveText.textAlign ?? TextAlign.start,
          textDirection: widget.adaptiveText.textDirection,
          maxLines: widget.adaptiveText.maxLines,
        ),
      ),
    );
  }
}
