  // final _keyRed = GlobalKey();

  // _getSizes() {
  //   final RenderBox renderBoxRed =
  //       _keyRed.currentContext!.findRenderObject() as RenderBox;
  //   final sizeRed = renderBoxRed.size;
  //   debugPrint("SIZE of Red: $sizeRed");
  // }

  // _getPositions() {
  //   final RenderBox renderBoxRed =
  //       _keyRed.currentContext!.findRenderObject() as RenderBox;
  //   final positionRed = renderBoxRed.localToGlobal(Offset.zero);
  //   debugPrint("POSITION of Red: $positionRed ");
  // }



// final List<double> spMatrixlist = [];
  // Future<List<double>?> getSavedMatrix(String key) async {
  //   debugPrint('Key :  $key');
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   return sp.getStringList(key)?.map((item) => double.parse(item)).toList();
  // // sp.clear();
  // List<String>? result = sp.getStringList(key);
  // if (result != null) {
  //   spMatrixlist.clear();
  //   for (String value in result) {
  //     spMatrixlist.add(double.parse(value.toString()));
  //   }

  //   debugPrint(spMatrixlist.toString());
  // }

  // return spMatrixlist;
  // }



  // if (storyBoadList.isEmpty) {
    //   storyBoadList.add(storyboardItem);
    // } else {
    //   if (storyboardItem.key == null) return;
    //   final item = storyBoadList
    //       .firstWhere((element) => element.key != storyboardItem.key);
    //   storyBoadList.add(item);
    //   final index = storyBoadList
    //       .indexWhere((element) => element.key == storyboardItem.key);
    //   storyBoadList[index] = storyBoadList[index].copWith(
    //       key: storyboardItem.key,
    //       matrixPosition: storyboardItem.matrixPosition);
    // }
  
    //upddate Json Data items
  // addStoryboardJson(StoryBoardType storyboardItem) {
  //   if (storyboardItem.key == null) return;

  //   // final item = storyBoadList
  //   //     .firstWhere((element) => element.key == storyboardItem.key);
  //   if (storyBoadList.isNotEmpty) {
  //     storyBoadList.removeWhere((element) => element.key == storyboardItem.key);
  //   }

    // updateStoryboardJson(storyboardItem.key!);
    // storyBoadList.add(item);

    // setState(() {});
  // }

