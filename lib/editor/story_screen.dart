// ignore_for_file: unused_element, unrelated_type_equality_checks
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:photo_editor/editor/editor_controller.dart';
import 'package:photo_editor/editor/overlayed_widget.dart';
import 'package:photo_editor/editor/storyboard_template_model.dart';
import 'widgets/widget_controller.dart';

// import 'package:shared_preferences/shared_preferences.dart';
enum WidgetType { text, photo, sticker }

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  Matrix4 _translate(Offset translation) {
    var dx = translation.dx;
    var dy = translation.dy;
    return Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  }

  deleteStoryItem(Offset offset, String key) async {
    if (offset.dy > (MediaQuery.of(context).size.height - 200)) {
      setState(() {
        debugPrint('Deleted $key');
        _addedWidget.removeWhere((element) => element.key.toString() == key);
        // _addedWidget.add(const SizedBox(height: 1, width: 1));
      });
      storyboardMap.remove(key);
      // if (storyboardMap.length == 1) {
      //   print('delete all');
      //   // storyboardMap.clear();
      //   // SharedPref.clearAll();
      // }

    }
  }

// Move Item to Top
  void _moveItemToTop(String? key) {
    debugPrint(key);
    if (key == null) return;
    Widget item =
        _addedWidget.firstWhere((element) => element.key.toString() == key);

    _addedWidget.removeWhere((element) => element.key.toString() == key);
    _addedWidget.add(item);
    setState(() {});
    // storyboardMap
    StoryBoardType jsonItem = storyboardMap.values
        .firstWhere((element) => element.key.toString() == key);
    storyboardMap.removeWhere((k, value) => k == key);
    storyboardMap[key] = jsonItem;
  }

  StoryBoardTemplate? story;
  final List<StoryBoardType> storyBoadList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.istext.value = true;
      setState(() {
        loadSharedPrefs().then((value) {
          story = value;

          for (StoryBoardType values in value.storyboardItems) {
            storyBoadList.add(values);

            storyboardMap[values.key.toString()] = values;
            final matrix = values.matrixPosition!
                .map((item) => double.parse(item.toString()))
                .toList();
            controller.text.value = values.textItem!.text.toString();

            appValueNotifier.setText(values.textItem!.text.toString());
            text = values.textItem!.text.toString();
            editorList.add(WidgetConroller(
              type: values.type!,
              text: text,
            ));

            print(appValueNotifier.textVN.value);

            addWidget(matrix);
          }
        }).onError((error, stackTrace) {});
      });
    });
  }

  Future<StoryBoardTemplate> loadSharedPrefs() async {
    StoryBoardTemplate story =
        storyBoardTemplateFromJson(await SharedPref.read("storyItems"));
    return story;
  }

  String _key = "";
  String _type = '';
  final List<Widget> _addedWidget = [];
  Map<String, StoryBoardType> storyboardMap = {};
  bool isMoveItem = false;
  AppValueNotifier appValueNotifier = AppValueNotifier();
  final controller = Get.put(EditorController());
  String text = "double tab to edit";
  void updateText(String newText) {
    setState(() {
      text = newText;
    });
  }

  StoryBoardType? getDataFromStoryboardMap(String key) {
    return storyboardMap[key];
  }

  //upddate Json Data items
  updateORAddStoryboardJson(StoryBoardType storyboardItem) {
    storyBoadList.clear();
    storyboardMap[storyboardItem.key.toString()] = storyboardItem;
    storyboardMap.forEach((key, value) {
      storyBoadList.add(value);
    });
  }

  // add anywidget and check weather is working or not
  addWidget(List<double> spMatrixlist) {
    debugPrint(spMatrixlist.toString());
    if (_addedWidget.length < editorList.length) {
      setState(() {
        _addedWidget.add(OverlayedWidget(
            key: Key(_addedWidget.length.toString()),
            matrix4: spMatrixlist.isEmpty
                ? _translate(const Offset(0.0, 0.0))
                : Matrix4.fromList(spMatrixlist),
            onDragStart: () {
              // isMoveItem = true;
            },
            onDragEnd: (offset, key, [matrix]) {
              final updatedMatrix = matrix!.storage.toList();

              _key = key.toString();

              if (_type == "") {
                _type = getDataFromStoryboardMap(_key)!.type.toString();
              }

              print('type : $_type');

              //test json data

              var ss = StoryBoardType(
                  key: _key,
                  type: _type,
                  photoItem: PhotoWidgetData(),
                  stickerItem: StickerWidgetData(),
                  textItem: TextWidgetData(
                    text: controller.text.value,
                    color: 'red',
                    fontFmaily: 'googlefonts',
                    bold: true,
                    italian: true,
                    normal: false,
                    textSpace: '2',
                    size: '23',
                    key: _key,
                  ),
                  matrixPosition: updatedMatrix);
              // storyBoadList.clear();
              // addStoryboardJson(ss);

              // storyBoadList.add(ss);
              updateORAddStoryboardJson(ss);
              // for (StoryBoardType values in storyBoadList) {
              // listTest.addAll(storyBoadList
              //     .where((a) => listTest.every((b) => a.key != b.key)));

              // }

              var dd = StoryBoardTemplate(storyboardItems: storyBoadList);

              String test = json.encode(dd.toJson());
              SharedPref.save('storyItems', test.toString());

              // deleteStoryItem(offset!, _key);
              print('jsonData $test');
              _type = "";
              // spMatrixlist.clear();
              // var jsondata = json.decode(test);
              // StoryBoardTemplate dad = StoryBoardTemplate.fromJson(jsondata);

              // print(
              //     'testresult ${dad.storyboardItems.map((e) => e.key)} ');
            },
            onDragUpdate: (offset, key, [matrix]) {
              log(key.toString());
              _key = key.toString();
            },
            child: editorList.elementAt(_addedWidget.length)));

        // getSavedMatrix("[<'${_addedWidget.length}'>]");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Editor')),
        floatingActionButton: buildSpeedDial(),
        body: Container(
          color: Colors.black,
          child: Stack(
            // alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
              // OverlayedWidget(
              //     matrix4: spMatrixlist.isEmpty
              //         ? _translate(const Offset(-2.3, 157.3))
              //         : Matrix4.fromList(
              //             spMatrixlist), //_translate(const Offset(-123.3, 157.3)),
              //     child: Container(
              //       key: _keyRed,
              //       padding: const EdgeInsets.all(8),
              //       color: Colors.black,
              //       child: const Text(
              //         'Hello Abid',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     )),
              for (int i = 0; i < _addedWidget.length; i++) _addedWidget[i],
              // OverlayedWidget(
              //     key: Key((editorList.length - 1).toString()),
              //     matrix4: spMatrixlist.isEmpty
              //         ? _translate(const Offset(-2.3, 157.3))
              //         : Matrix4.fromList(spMatrixlist),
              //     onDragStart: () {},
              //     onDragEnd: (offset, key) {},
              //     onDragUpdate: (offset, key) {
              //       log(key.toString());
              //       if (offset.dy >
              //           (MediaQuery.of(context).size.height - 100)) {}
              //     },
              //     child: editorList.elementAt(editorList.length)),
              // Align(
              //     alignment: Alignment.bottomCenter,
              //     child: MaterialButton(
              //       onPressed: () {
              //         // _getSizes();
              //         // _getPositions();
              //         // getSavedMatrix("[<'${_addedWidget.length}'>]");

              //         setState(() {});
              //       },
              //       child: const Text('reset and delete'),
              //     ))
            ],
          ),
        ));
  }

  //check which widget is needed
  //  getWidget(String storyBoardType) {
  //   switch (storyBoardType) {
  //     case 'Text':
  //       {
  //         editorList.add(AbsText(
  //           onPressed: () {
  //             //  isMoveItem?   _moveItemToTop(_key):null;
  //             //       isMoveItem = false;
  //           },
  //           textChanged: (String text) {},
  //         ));
  //       }
  //       break;
  //     case 'Photo':
  //       {
  //         editorList.add(const AbsPhoto());
  //       }
  //       break;
  //     case 'Sticker':
  //       {
  //         editorList.add(const AbsSticker());
  //       }
  //       break;
  //   }
  // }

  List<Widget> editorList = [];

  //Edit Floating Button
  Widget buildSpeedDial() {
    return SpeedDial(
      overlayOpacity: 0.0,
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: Colors.green[900],
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.create, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            _type = 'Text';
            editorList.add(WidgetConroller(
              type: _type,
              text: 'double tab to edit',
            ));
            // editorList.add(AbsText(
            //   textChanged: (String text) {
            //     updateText(text);
            //   },
            //   onPressed: () {
            //     print('pressseedddd');
            //     _moveItemToTop(_key);
            //   },
            // ));
            addWidget([]);
            // _moveItemToTop(_key);
          },
          label: 'Write',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: const Icon(Icons.photo_camera, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            _type = 'Photo';
            print(_type);
            // spMatrixlist.clear();
            editorList.add(WidgetConroller(
              type: _type,
              text: 'edit',
            ));
            addWidget([]);
          },
          label: 'Photo',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: const Icon(Icons.emoji_flags, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            _type = 'Sticker';
            // spMatrixlist.clear();
            // editorList.add(const AbsSticker());
            editorList.add(WidgetConroller(
              type: _type,
              text: text,
            ));
            addWidget([]);
          },
          label: 'Sticker',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }
}
