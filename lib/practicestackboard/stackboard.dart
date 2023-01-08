import 'package:flutter/material.dart';
import 'package:photo_editor/practicestackboard/casegroup/adaptive_text_case.dart';
import 'package:photo_editor/practicestackboard/casegroup/item_case.dart';
import 'package:photo_editor/practicestackboard/helper/case_style.dart';
import 'package:photo_editor/practicestackboard/helper/operate_state.dart';
import 'package:photo_editor/practicestackboard/helper/safe_state.dart';
import 'package:photo_editor/practicestackboard/itemgroup/adaptive_text.dart';

import 'itemgroup/stack_board_item.dart';

/// laminated board
class StackBoard extends StatefulWidget {
  const StackBoard(
      {super.key,
      this.controller,
      this.background,
      this.caseStyle,
      this.customBuilder,
      required this.tapToCancelAllItem,
      required this.tapItemToMoveTop});

  @override
  State<StackBoard> createState() => _StackBoardState();

  /// Overlay controller
  final StackBoardController? controller;

  /// background
  final Widget? background;

  /// Operation box style
  final CaseStyle? caseStyle;
  // Custom type control builder
  final Widget? Function(StackBoardItem item)? customBuilder;

  /// Click the blank space to cancel all selections (comparatively consumes performance, closed by default)
  final bool tapToCancelAllItem;

  /// Click item to move to the top level
  final bool tapItemToMoveTop;
}

class _StackBoardState extends State<StackBoard> with SafeState<StackBoard> {
  late List<StackBoardItem> _children;
  int _lastId = 0;
  OperateState? _operateState;
  Key _getKey(int? id) => Key('StackBoardItem$id');
  @override
  void initState() {
    super.initState();
    _children = <StackBoardItem>[];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller?._stackBoardState = this;
  }

  // add one
  void _add<T extends StackBoardItem>(StackBoardItem item) {
    if (_children.contains(item)) throw 'duplicate id';
    _children.add(item.copyWith(
        id: item.id ?? _lastId, caseStyle: item.caseStyle ?? widget.caseStyle));
    _lastId++;
    safeSetState(() {});
  }

// Remove the specified id item
  void _remove(int? id) {
    _children.removeWhere((StackBoardItem b) => b.id == id);
    safeSetState(() {});
  }

// Move the item to the top level
  void _moveItemToTop(int? id) {
    if (id == null) return;
    final StackBoardItem item =
        _children.firstWhere((StackBoardItem i) => i.id == id);
    _children.removeWhere((StackBoardItem i) => i.id == id);
    _children.add(item);
    safeSetState(() {});
  }

  // clean up
  void _clear() {
    _children.clear();
    _lastId = 0;
    safeSetState(() {});
  }

// Unselect all
  void _unFocus() {
    _operateState = OperateState.complete;
    safeSetState(() {});
    Future<void>.delayed(const Duration(milliseconds: 500), (() {
      _operateState = null;
      safeSetState(() {});
    }));
  }

  // delete action
  Future<void> _onDel(StackBoardItem box) async {
    final bool del = (await box.onDel?.call()) ?? true;
    if (del) _remove(box.id);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.background == null) {
      child = Stack(
        fit: StackFit.expand,
        children:
            _children.map((StackBoardItem box) => _buildItem(box)).toList(),
      );
    } else {
      child = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          widget.background!,
          ..._children.map((StackBoardItem box) => _buildItem(box)).toList(),
        ],
      );
    }

    if (widget.tapToCancelAllItem) {
      child = GestureDetector(
        onTap: _unFocus,
        child: child,
      );
    }
    return child;
  }

  // build item
  Widget _buildItem(StackBoardItem item) {
    Widget child = ItemCase(
      key: _getKey(item.id),
      onDel: () => _onDel(item),
      onTap: () => _moveItemToTop(item.id),
      caseStyle: item.caseStyle,
      operateState: _operateState,
      child: Container(
        width: 150,
        height: 150,
        alignment: Alignment.center,
        child: const Text(
            'unknown item type, please use customBuilder to build it'),
      ),
    );
    if (item is AdaptiveText) {
      child = AdaptiveTextCase(
        key: _getKey(item.id),
        adaptiveText: item,
        onDel: () => _onDel(item),
        onTap: () => _moveItemToTop(item.id),
        operateState: _operateState,
      );
    } else {
      child = ItemCase(
          onDel: () => _onDel(item),
          onTap: () => _moveItemToTop(item.id),
          caseStyle: item.caseStyle,
          operateState: _operateState,
          key: _getKey(item.id),
          child: item.child);
      if (widget.customBuilder != null) {
        final Widget? customWidget = widget.customBuilder!.call(item);
        if (customWidget != null) return child = customWidget;
      }
    }

    return child;
  }
}

/// Controller
class StackBoardController {
  _StackBoardState? _stackBoardState;

  /// Check if loaded
  void _check() {
    if (_stackBoardState == null) throw '_stackboard is empty';
  }

  /// add one
  void add<T extends StackBoardItem>(T item) {
    _check();
    _stackBoardState?._add<T>(item);
  }

  // remove
  void remove(int? id) {
    _check();
    _stackBoardState?._remove(id);
  }

  void moveItemToTop(int? id) {
    _stackBoardState?._moveItemToTop(id);
  }

  // clear all
  void clear() {
    _check();
    _stackBoardState?._clear();
  }

  // refresh
  void refresh() {
    _stackBoardState?.safeSetState(() {});
  }

// destroy
  void dispose() {
    _stackBoardState = null;
  }
}
