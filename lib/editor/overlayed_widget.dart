import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef PointMoveCallback = void Function(Offset? offset, Key? key,
    [Matrix4? matrix4]);

class OverlayedWidget extends StatelessWidget {
  final Widget child;
  final Matrix4? matrix4;
  final VoidCallback onDragStart;
  final PointMoveCallback onDragEnd;
  final PointMoveCallback onDragUpdate;
  const OverlayedWidget({
    super.key,
    required this.child,
    this.matrix4,
    required this.onDragStart,
    required this.onDragEnd,
    required this.onDragUpdate,
  });

  saveMatrix(String key, List<String> matrixList) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList(key, matrixList);
    //matrixList
  }

  getSavedMatrix(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<double> spMatrixlist = [];
    List<String>? result = sp.getStringList(key);
    for (String value in result!) {
      spMatrixlist.add(double.parse(value));
    }
    print(spMatrixlist);
    return spMatrixlist;
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    notifier.value = matrix4!;
    Offset offset = const Offset(0.0, 0.0);
    return Listener(
      onPointerMove: (event) {
        offset = event.position;
        onDragUpdate(offset, key);
      },
      child: MatrixGestureDetector(
          setMatrix: matrix4,
          onMatrixUpdate: (m, tm, sm, rm) {
            notifier.value = m;
          },
          child: AnimatedBuilder(
            animation: notifier,
            builder: (ctx, childWidget) {
              return Transform(
                transform: notifier.value,
                child: Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            child,
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Transform.scale(
                              scale: 1.1 /
                                  MatrixGestureDetector.decomposeToValues(
                                          notifier.value)
                                      .scale,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                icon: Icon(Icons.move_down),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          onScaleStart: () {
            onDragStart();
          },
          onScaleEnd: () {
            onDragEnd(offset, key, notifier.value);

            // List<String> matrixList = [];
            // for (int i = 0; i < notifier.value.storage.length; i++) {
            //   matrixList.add(notifier.value[i].toString());
            //   saveMatrix(key.toString(), matrixList);
            // }
            // getSavedMatrix(key.toString());
          }),
    );
  }
}
