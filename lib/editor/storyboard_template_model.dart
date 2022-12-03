import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

StoryBoardTemplate storyBoardTemplateFromJson(String str) =>
    StoryBoardTemplate.fromJson(json.decode(str));
String storyBoardTemplateToJson(StoryBoardTemplate data) =>
    json.encode(data.toJson());

//// Crete object to store data in json format
class StoryBoardTemplate {
  final List<StoryBoardType> storyboardItems;
  StoryBoardTemplate({required this.storyboardItems});
  factory StoryBoardTemplate.fromJson(Map<String, dynamic> json) {
    final storyboardData = json['storyboardItems'] as List<dynamic>?;
    final storyboard = storyboardData != null
        ? storyboardData
            .map((storyData) => StoryBoardType.fromJson(storyData))
            .toList()
        : <StoryBoardType>[];
    return StoryBoardTemplate(storyboardItems: storyboard);
  }
  Map<String, dynamic> toJson() {
    return {'storyboardItems': storyboardItems.map((e) => e.toJson()).toList()};
  }
}

//StoryBoard widget Type
class StoryBoardType {
  final String? key;
  final String? type; // Text,Photo or it can be Sticker
  final TextWidgetData? textItem;
  final PhotoWidgetData? photoItem;
  final StickerWidgetData? stickerItem;
  final List<dynamic>? matrixPosition;
  StoryBoardType(
      {this.key,
      this.type,
      this.textItem,
      this.photoItem,
      this.stickerItem,
      this.matrixPosition});
  factory StoryBoardType.fromJson(Map<String, dynamic> json) {
    final matrixPositionData = json['matrixPosition'] as List<dynamic>?;
    final matrixPos = matrixPositionData != null
        ? matrixPositionData.map((matrix) => matrix).toList()
        : <StoryBoardType>[];
    return StoryBoardType(
        key: json['key'] as String,
        type: json['type'] as String,
        textItem: TextWidgetData.fromJson(json['textItem']),
        photoItem: PhotoWidgetData.fromJson(json['photoItem']),
        stickerItem: StickerWidgetData.fromJson(json['stickerItem']),
        matrixPosition: matrixPos);
  }
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type,
      if (textItem != null) 'textItem': textItem!.toJson(),
      if (photoItem != null) 'photoItem': photoItem!.toJson(),
      if (stickerItem != null) 'stickerItem': stickerItem!.toJson(),
      'matrixPosition': matrixPosition?.map((e) => e).toList(),
    };
  }

  StoryBoardType copWith({
    final String? key,
    final String? type, // Text,Photo or it can be Sticker
    final TextWidgetData? textItem,
    final PhotoWidgetData? photoItem,
    final StickerWidgetData? stickerItem,
    final List<dynamic>? matrixPosition,
  }) {
    return StoryBoardType(
      key: key ?? this.key,
      type: type ?? this.type,
      textItem: textItem ?? this.textItem,
      photoItem: photoItem ?? this.photoItem,
      stickerItem: stickerItem ?? this.stickerItem,
      matrixPosition: matrixPosition ?? this.matrixPosition,
    );
  }
}

//Text widget data to store in jsonString
class TextWidgetData {
  final String? text;
  final String? color;
  final String? fontFmaily;
  final String? size;
  final bool? bold;
  final bool? italian;
  final bool? normal;
  final String? textSpace;
  final String? key;

  TextWidgetData({
    this.text,
    this.color,
    this.fontFmaily,
    this.size,
    this.bold,
    this.italian,
    this.normal,
    this.textSpace,
    this.key,
  });
  factory TextWidgetData.fromJson(Map<String, dynamic> json) {
    return TextWidgetData(
        text: json['text'] as String,
      color: json['color'] as String,
      fontFmaily: json['fontFamily'] as String,
      size: json['size'] as String,
      bold: json['bold'] as bool,
      italian: json['italian'] as bool,
      normal: json['normal'] as bool,
      textSpace: json['textSpace'] as String,
      key: json['key'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
       'text': text,
      'color': color,
      'fontFamily': fontFmaily,
      'size': size,
      'bold': bold,
      'italian': italian,
      'normal': normal,
      'textSpace': textSpace,
      'key': key,
    };
  }
}

//photo widget data to store in jsonString
class PhotoWidgetData {
  final String? filter;
  final String? imageBase64;
  final String? key;

  PhotoWidgetData({this.filter, this.imageBase64, this.key});
  factory PhotoWidgetData.fromJson(Map<String, dynamic> json) {
    return PhotoWidgetData(
      filter: json['filter'],
      imageBase64: json['imageBase64'],
      key: json['key'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'imageBase64': imageBase64,
      'key': key,
    };
  }
}

//Sticker widget data to store in jsonString
class StickerWidgetData {
  final String? filter;
  final String? imageBase64;
  final String? key;
  StickerWidgetData({this.filter, this.imageBase64, this.key});
  factory StickerWidgetData.fromJson(Map<String, dynamic> json) {
    return StickerWidgetData(
      filter: json['filter'],
      imageBase64: json['imageBase64'],
      key: json['key'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'imageBase64': imageBase64,
      'key': key,
    };
  }
}

//
class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    return json.decode(prefs.getString(key).toString());
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

// loadSharedPrefs() async {

//   try {
//     StoryBoardTemplate story = StoryBoardTemplate.fromJson(await SharedPref.read("user"));
//     // setState(() {
//     //   story = story;
//     // });
//   } catch (Excepetion) {
//     // do something
//   }
// }
