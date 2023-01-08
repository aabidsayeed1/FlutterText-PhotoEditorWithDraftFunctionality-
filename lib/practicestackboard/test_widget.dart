// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:photo_editor/practicestackboard/casegroup/adaptive_text_case.dart';
import 'package:photo_editor/practicestackboard/casegroup/item_case.dart';
import 'package:photo_editor/practicestackboard/itemgroup/adaptive_text.dart';
import 'package:photo_editor/practicestackboard/stackboard.dart';
import 'helper/case_style.dart';
import 'itemgroup/stack_board_item.dart';

class TestWidgetForStackboard extends StatefulWidget {
  const TestWidgetForStackboard({super.key});

  @override
  State<TestWidgetForStackboard> createState() =>
      _TestWidgetForStackboardState();
}

class _TestWidgetForStackboardState extends State<TestWidgetForStackboard> {
  late StackBoardController _boardController;
  @override
  void initState() {
    super.initState();
    _boardController = StackBoardController();
  }

  @override
  void dispose() {
    _boardController.dispose();
    super.dispose();
  }

  double _textFieldWidth = 100;

  /// 文本样式
  TextStyle get _style => TextStyle(fontSize: 50);
  late String _text = 'heelo yaara';

  /// 计算文本大小
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StackBoard(
        controller: _boardController,
        tapToCancelAllItem: true,
        tapItemToMoveTop: true,
        caseStyle: const CaseStyle(
          borderColor: Colors.grey,
          iconColor: Colors.white,
        ),
        background: ColoredBox(color: Colors.red[100]!),
        // customBuilder: (StackBoardItem item) {
        //   if (item is CustomItem) {
        //     return ItemCase(
        //       // canEdit: true,
        //       onSizeChanged: (Size size) {
        //         print(size);
        //         size = _textSize(_text, _style);
        //         _textFieldWidth = size.width + 8;

        //         return;
        //       },
        //       onAngleChanged: (double offset) {
        //         print(offset);
        //         return true;
        //       },

        //       key: Key('StackBoardItem${item.id}'), // <==== must
        //       isCenter: true,
        //       onDel: () async => _boardController.remove(item.id),
        //       onTap: () => _boardController.moveItemToTop(item.id),
        //       caseStyle: const CaseStyle(
        //         borderColor: Colors.grey,
        //         iconColor: Colors.white,
        //       ),
        //       child: Container(
        //         width: 200,
        //         height: 500,
        //         color: item.color,
        //         alignment: Alignment.center,
        //         child: const Text(
        //           'Custom item',
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       ),
        //     );
        //   }

        //   return null;
        // },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _boardController.add(
            const AdaptiveText(
              'Aabid Bin Sayeed',
              tapToEdit: false,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
            ),
          );
        },
        child: const Icon(Icons.border_color),
      ),
    );
  }
}

///自定义类型 Custom item type
class CustomItem extends StackBoardItem {
  const CustomItem({
    required this.color,
    Future<bool> Function()? onDel,
    int? id, // <==== must
  }) : super(
          child: const Text('CustomItem'),
          onDel: onDel,
          id: id, // <==== must
        );

  final Color? color;

  @override // <==== must
  CustomItem copyWith({
    CaseStyle? caseStyle,
    Widget? child,
    int? id,
    Future<bool> Function()? onDel,
    dynamic Function(bool)? onEdit,
    bool? tapToEdit,
    Color? color,
  }) =>
      CustomItem(
        onDel: onDel,
        id: id,
        color: color ?? this.color,
      );
}
