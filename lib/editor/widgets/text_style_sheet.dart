// Style bottom sheet to update data on text
import 'package:flutter/material.dart';
import 'package:photo_editor/editor/editor_controller.dart';
import 'package:photo_editor/editor/widgets/abs_text.dart';

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
  List<Widget> sizeWidgetList = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
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
      // _selectedWeightIndex = weightList.indexOf();

      // _selectedWeightIndex = _selectedWeightIndex! - 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addSizesBox();
      isAnimated = false;
    });
  }

  Future ft = Future(() {});
  // add sizes widgets to list of widgets
  void _addSizesBox() {
    List.generate(sizesList.length, (index) {
      ft = ft.then((_) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          sizeWidgetList.add(animatedSizeWidget(index));
          if (_listKey.currentState != null) {
            _listKey.currentState!.insertItem(sizeWidgetList.length - 1);
          }
        });
      });
    });
  }

  bool isAnimated = true;
  final Tween<Offset> _offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0.10));
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
                if (value == value) {
                  setState(() {
                    isAnimated = false;
                  });
                  // _addSizesBox();
                }
                // else if (value == 1) {
                //   sizeWidgetList.clear();

                // }
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
              isAnimated ? animatedSizeSelector() : sizeSelector(),
              colorSelector(),
              fontSelector(),
              weightSelector(),
            ]),
          )
        ],
      ),
    );
  }

  Widget animatedSizeSelector() {
    return AnimatedList(
        primary: true,
        scrollDirection: Axis.horizontal,
        key: _listKey,
        initialItemCount: sizeWidgetList.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(_offset),
            child: sizeWidgetList[index],
          );
          //  animatedSizeWidget(index);
        });
  }

  GestureDetector animatedSizeWidget(int index) {
    return GestureDetector(
      onTap: () {
        _onSelectedSizeItem(index);
        widget.appValueNotifier.sizeV.value = sizesList[index].toDouble();
      },
      child: Container(
          alignment: Alignment.center,
          margin:
              const EdgeInsets.only(left: 10, right: 10, bottom: 72, top: 41),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              border: Border.all(
                  width:
                      _selectedSizeIndex != null && _selectedSizeIndex == index
                          ? 2
                          : 0),
              color: Colors.white,
              borderRadius: BorderRadius.circular(17)),
          child: Text(sizesList[index].toString())),
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
