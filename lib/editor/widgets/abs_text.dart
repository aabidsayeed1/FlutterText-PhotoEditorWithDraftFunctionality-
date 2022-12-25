import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_editor/editor/editor_controller.dart';
import 'package:photo_editor/editor/widgets/text_style_sheet.dart';

typedef StringCallback = void Function(String text);

// Abs Text for Editor
class AbsText extends StatelessWidget {
  final String text;
  final StringCallback onTextChanged;
  final VoidCallback onPressed;
  const AbsText(
      {Key? key,
      required this.onPressed,
      required this.onTextChanged,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textC = TextEditingController();

    AppValueNotifier appValueNotifier = AppValueNotifier();
    final controller = Get.put(EditorController());
    textC.text = text;
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        // GestureDetector(
        //   child: const Icon(
        //     Icons.move_up,
        //     color: Colors.white,
        //     size: 20,
        //   ),
        // ),
        Listener(
          onPointerMove: (event) {
            onTextChanged(textC.text);
            // appValueNotifier.textVN.value = text;
            controller.text.value = textC.text;
          },
          child: GestureDetector(
            //  onHorizontalDragStart: (details) {
            //     textChanged(textC.text);
            //  },
            //  onVerticalDragStart: (details) {
            //     textChanged(textC.text);
            //  },
            onTap: () {
              onTextChanged(textC.text);
              showBottomSheet(
                  context: context,
                  builder: ((context) {
                    return TextStyleSheet(
                      appValueNotifier: appValueNotifier,
                    );
                  }));
            },
            onDoubleTap: () {
              controller.istext.value = false;
              showBottomSheet(
                  context: context,
                  builder: ((context) {
                    return Container(
                      height: 150,
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: [
                          Container(
                            height: 56,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              controller: textC,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                appValueNotifier.textVN.value =
                                    value.toString();
                                // appValueNotifier.textVN.value = text;
                                controller.text.value = value.toString();
                              },
                              // ignore: prefer_const_constructors
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[600],
                                hintStyle: const TextStyle(color: Colors.white),
                                hintText: 'Add Text',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),

                              // initialValue: 'Add Text',
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            clipBehavior: Clip.antiAlias,
                            color: Theme.of(context).bottomAppBarColor,
                            onPressed: () {
                              onTextChanged(textC.text);
                              Navigator.pop(context);
                            },
                            child: const Text('Add Text'),
                          )
                        ],
                      ),
                    );
                  }));
            },
            child: DottedBorder(
              padding: EdgeInsets.zero,
              dashPattern: const [5, 3],
              radius: const Radius.circular(18),
              color: Colors.red.withOpacity(0.9),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.shade700.withOpacity(0.2),
                ),
                child: Center(
                  child:
                      //  controller.istext.value ?

                      //   Obx(()=>
                      //   Text(
                      //       controller.text.value,
                      //       style: const TextStyle(
                      //           fontSize: 10, fontWeight: FontWeight.bold),
                      //     ),)
                      //  :
                      ValueListenableBuilder(
                    valueListenable: appValueNotifier.textVN,
                    builder: (context, value, child) => ValueListenableBuilder(
                      valueListenable: appValueNotifier.sizeV,
                      builder: (context, size, child) => ValueListenableBuilder(
                        valueListenable: appValueNotifier.colorV,
                        builder: (context, color, child) =>
                            ValueListenableBuilder(
                          valueListenable: appValueNotifier.fontFmailyV,
                          builder: (context, fontFamily, child) =>
                              ValueListenableBuilder(
                            valueListenable: appValueNotifier.boldV,
                            builder: (context, bold, child) =>
                                ValueListenableBuilder(
                              valueListenable: appValueNotifier.italianV,
                              builder: (context, italian, child) => Text(
                                controller.istext.value ? text : value,
                                style: TextStyle(
                                    fontSize: size,
                                    fontFamily: fontFamily,
                                    fontWeight: bold
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontStyle: italian
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    color: color),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

List<int> sizesList = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20
];

List<Color> colorsList = [
  const Color(0xff23EF34),
  const Color(0xffffffff),
  const Color(0xfff9e6ff),
  const Color(0xffff66ff),
  const Color(0xffff4d4d),
  const Color(0xffff9933),
  const Color(0xffcc6600),
  const Color(0xffe63900),
  const Color(0xff993300),
  const Color(0xff333300),
  const Color(0xff00cc00),
  const Color(0xff000099),
  const Color(0xffff66ff),
  const Color(0xff666699),
  const Color(0xff000066),
  const Color(0xff00ffcc),
  const Color(0xff00ffff),
  const Color(0xffff1a66),
  const Color(0xffff66cc),
  const Color(0xff003399),
];

final List<String> fontsList = [
  "Lato",
  "PoiretOne",
  "Monoton",
  "BungeeInline",
  "ConcertOne",
  "FrederickatheGreat",
  "Martel",
  "Vidaloka",
  'OpenSans',
  'Billabong',
  'GrandHotel',
  'Oswald',
  'Quicksand',
  'BeautifulPeople',
  'BeautyMountains',
  'BiteChocolate',
  'BlackberryJam',
  'BunchBlossoms',
  'CinderelaRegular',
  'Countryside',
  'Halimun',
  'LemonJelly',
  'QuiteMagicalRegular',
  'Tomatoes',
  'TropicalAsianDemoRegular',
  'VeganStyle',
];

List<WeightObject> weightList = [
  WeightObject(title: 'Bold', textWeight: TextWeight.bold),
  WeightObject(title: 'Normal', textWeight: TextWeight.normal),
  WeightObject(title: 'Italian', textWeight: TextWeight.italian),
  WeightObject(title: 'BoldItalian', textWeight: TextWeight.boldItalian),
];
