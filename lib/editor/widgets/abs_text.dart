import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_editor/editor/editor_controller.dart';


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

// Style bottom sheet to update data on text
class TextStyleSheet extends StatefulWidget {
  final AppValueNotifier appValueNotifier;
  const TextStyleSheet({Key? key, required this.appValueNotifier})
      : super(key: key);

  @override
  State<TextStyleSheet> createState() => _TextStyleSheetState();
}

class _TextStyleSheetState extends State<TextStyleSheet>
    with SingleTickerProviderStateMixin {
  late TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 4,
        vsync: this,
        initialIndex: widget.appValueNotifier.tabIndexV.value);

    setState(() {
      //set size when you luanch bottomSheet
      _selectedSizeIndex = int.parse(
          widget.appValueNotifier.sizeV.value.toString().split('.').first);
      _selectedSizeIndex = _selectedSizeIndex! - 1;
      //set Color when you luanch bottomSheet
      _selectedColorIndex =
          colorsList.indexOf(widget.appValueNotifier.colorV.value);
      _selectedFontIndex = _selectedColorIndex! - 1;
      //set Fonts when you luanch bottomSheet
      _selectedFontIndex =
          fontsList.indexOf(widget.appValueNotifier.fontFmailyV.value);
      _selectedFontIndex = _selectedFontIndex! - 1;
      //for weight when you luanch bottomSheet
      // _selectedWeightIndex =
      //     weightList.map((e) => e.textWeight.index);
      // _selectedWeightIndex = _selectedWeightIndex! - 1;
    });
  }

//for sizes
  int? _selectedSizeIndex = 0;

  _onSelectedSizeItem(int index) {
    setState(() {
      _selectedSizeIndex = index;
    });
  }

//for colors
  int? _selectedColorIndex = 0;

  _onSelectedColorItem(int index) {
    setState(() {
      _selectedColorIndex = index;
    });
  }

  //for fonts
  int? _selectedFontIndex = 0;

  _onSelectedFontItem(int index) {
    setState(() {
      _selectedFontIndex = index;
    });
  }

  //for Weight
  int? _selectedWeightIndex = 0;
  _onSelectedWeightItem(int index) {
    setState(() {
      _selectedWeightIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Text Styles',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).backgroundColor),
          ),
          const SizedBox(
            height: 5,
          ),
          TabBar(
              onTap: (value) {
                widget.appValueNotifier.tabIndexV.value = value;
              },
              controller: tabController,
              tabs: const [
                Text('Size'),
                Text('Colors'),
                Text('Fonts'),
                Text('Weight'),
              ]),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              sizeSelector(),
              colorSelector(),
              fontSelector(),
              weightSelector(),
            ]),
          )
        ],
      ),
    );
  }

  Widget sizeSelector() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
                sizesList.length,
                (index) => GestureDetector(
                      onTap: () {
                        _onSelectedSizeItem(index);
                        widget.appValueNotifier.sizeV.value =
                            sizesList[index].toDouble();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 30),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: _selectedSizeIndex != null &&
                                          _selectedSizeIndex == index
                                      ? 2
                                      : 0),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17)),
                          child: Text(sizesList[index].toString())),
                    ))));
  }

  Widget colorSelector() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
                colorsList.length,
                (index) => GestureDetector(
                      onTap: () {
                        _onSelectedColorItem(index);
                        widget.appValueNotifier.colorV.value =
                            colorsList[index];
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 30),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: _selectedColorIndex != null &&
                                        _selectedColorIndex == index
                                    ? 2
                                    : 0),
                            color: colorsList[index],
                            borderRadius: BorderRadius.circular(17)),
                      ),
                    ))));
  }

  //fonts list
  Widget fontSelector() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
                fontsList.length,
                (index) => GestureDetector(
                      onTap: () {
                        _onSelectedFontItem(index);
                        widget.appValueNotifier.fontFmailyV.value =
                            fontsList[index];
                      },
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 30),
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: _selectedFontIndex != null &&
                                          _selectedFontIndex == index
                                      ? 2
                                      : 0),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17)),
                          child: Text(
                            'Aabid Syeed',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: fontsList[index]),
                          )),
                    ))));
  }

  //Weight widget
  Widget weightSelector() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(
                weightList.length,
                (index) => GestureDetector(
                      onTap: () {
                        _onSelectedWeightItem(index);
                        widget.appValueNotifier
                            .setWeight(weightList[index].textWeight);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 30),
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: _selectedWeightIndex != null &&
                                          _selectedWeightIndex == index
                                      ? 2
                                      : 0),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17)),
                          child: Text(
                            weightList[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: index == 0 || index == 3
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontStyle: index == 3 || index == 2
                                    ? FontStyle.italic
                                    : FontStyle.normal),
                          )),
                    ))));
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


