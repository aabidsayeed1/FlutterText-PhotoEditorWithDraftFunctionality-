import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditorController extends GetxController {
  var text = 'double tab to edit'.obs;
  var istext = false.obs;
}

//  State Management class
enum TextWeight { normal, bold, italian, boldItalian }

class AppValueNotifier {
  ValueNotifier colorV = ValueNotifier(const Color(0xffffffff));
  ValueNotifier fontFmailyV = ValueNotifier('Lato');
  ValueNotifier boldV = ValueNotifier(false);
  ValueNotifier italianV = ValueNotifier(false);
  ValueNotifier normalV = ValueNotifier(true);
  ValueNotifier sizeV = ValueNotifier(15.0);
  ValueNotifier<int> tabIndexV = ValueNotifier(0);
  ValueNotifier<String> textVN = ValueNotifier("double tab to edit");

  void setCOlor(String color) {
    colorV.value = color;
  }

  void setFontFamily(String family) {
    fontFmailyV.value = family;
  }

  void setSize(double size) {
    sizeV.value = size;
  }

  void setText(String text) {
    textVN.value = text;
  }

  void set(String color) {
    colorV.value = color;
  }

  setWeight(TextWeight weight) {
    switch (weight) {
      case TextWeight.bold:
        {
          boldV.value = true;
          italianV.value = false;
          normalV.value = false;
        }
        break;
      case TextWeight.normal:
        {
          boldV.value = false;
          italianV.value = false;
        }
        break;
      case TextWeight.italian:
        {
          boldV.value = false;
          italianV.value = true;
        }
        break;
      case TextWeight.boldItalian:
        {
          boldV.value = true;
          italianV.value = true;
          normalV.value = false;
        }
        break;
    }
  }
}

class WeightObject {
  final String title;
  final TextWeight textWeight;
  WeightObject({required this.title, required this.textWeight});
}

// story board data store
class StoryBoardWidget {
  final String key;
  final Matrix4 matrix4;
  final Widget widget;
  StoryBoardWidget(
      {required this.key, required this.matrix4, required this.widget});
}

final Set<String> setList = {};
