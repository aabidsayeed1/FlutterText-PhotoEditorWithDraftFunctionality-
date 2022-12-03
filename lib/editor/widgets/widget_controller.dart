import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_editor/editor/editor_controller.dart';
import 'abs_photo.dart';
import 'abs_sticker.dart';
import 'abs_text.dart';

typedef OnListChanged = void Function(List<Widget> editorList);

class WidgetConroller extends StatefulWidget {
  final String type;
  final String text;
  const WidgetConroller({super.key, required this.type, required this.text});

  @override
  State<WidgetConroller> createState() => _WidgetConrollerState();
}

class _WidgetConrollerState extends State<WidgetConroller> {
  AppValueNotifier appValueNotifier = AppValueNotifier();
  final controller = Get.put(EditorController());
  Widget getWidget(String storyBoardType, String text) {
    Widget? widget;
    switch (storyBoardType) {
      case 'Text':
        {
          widget = AbsText(
            text: text,
            onPressed: () {
              //  isMoveItem?   _moveItemToTop(_key):null;
              //       isMoveItem = false;
            },
            onTextChanged: (String text) {},
          );
        }
        break;
      case 'Photo':
        {
          widget = const AbsPhoto();
        }
        break;
      case 'Sticker':
        {
          widget = const AbsSticker();
        }
        break;
    }
    return widget!;
  }

  @override
  Widget build(BuildContext context) {
    return getWidget(widget.type, widget.text);
  }
}
