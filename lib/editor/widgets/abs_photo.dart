// Abs Photo for Editor
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

// class AbsPhoto extends StatelessWidget {
//   const AbsPhoto({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DottedBorder(
//       padding: EdgeInsets.zero,
//       dashPattern: const [5, 3],
//       radius: const Radius.circular(18),
//       color: Colors.red.withOpacity(0.9),
//       child: Container(
//         height: 200,
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
//         decoration: BoxDecoration(
//           color: Colors.deepOrange.shade700.withOpacity(0.2),
//         ),
//         child: Center(child: Image.asset('assets/bg.jpg')),
//       ),
//     );
//   }
// }

class AbsPhoto extends StatefulWidget {
  const AbsPhoto({
    Key? key,
  }) : super(key: key);

  @override
  State<AbsPhoto> createState() => _AbsPhotoState();
}

class _AbsPhotoState extends State<AbsPhoto> {
  Offset _offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
          // _offset=Offset(_offset.dx+details.delta.dx, _offset.dy+details.delta.dy);
        });
      },
      child: DottedBorder(
        padding: EdgeInsets.zero,
        dashPattern: const [5, 3],
        radius: const Radius.circular(18),
        color: Colors.red.withOpacity(0.9),
        child: Container(
          height: 300,
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.deepOrange.shade700.withOpacity(0.2),
          ),
          child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_offset.dy * pi / 180)
                ..rotateY(_offset.dx * pi / 180),
              child: Center(child: const Cube())),
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  const Cube({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          //this is

          transform: Matrix4.identity()..translate(0.0, 0.0, -75.0),
          // ..rotateY(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.green,
            child: const FlutterLogo(
              size: 150,
            ),
          ),
        ),
        // Transform(
        //   //this is opposite

        //   transform: Matrix4.identity()
        //     ..translate(150.0, 0.0, -75.0)
        //     ..rotateZ(pi / 2),
        //   // alignment: Alignment.center,
        //   child: Container(
        //     color: Colors.red,
        //     child: const FlutterLogo(
        //       size: 150,
        //     ),
        //   ),
        // ),
        Transform(
          //this is right font
          transform: Matrix4.identity()
            ..translate(75.0, 0.0, 0.0)
            ..rotateY(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.orange,
            child: const FlutterLogo(
              size: 150,
            ),
          ),
        ),
        Transform(
          //this is right opposite back
          transform: Matrix4.identity()
            ..translate(-75.0, 0.0, 0.0)
            ..rotateY(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.pink,
            child: const FlutterLogo(
              size: 150,
            ),
          ),
        ),
        Transform(
          // this is bottom
          transform: Matrix4.identity()
            ..translate(0.0, 75.0, 0.0)
            ..rotateX(pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.blue,
            child: const FlutterLogo(
              size: 150,
            ),
          ),
        ),
        Transform(
          // this is bottom opposite top
          transform: Matrix4.identity()
            ..translate(0.0, -75.0, 0.0)
            ..rotateX(-pi / 2),
          alignment: Alignment.center,
          child: Container(
            color: Colors.purple,
            child: const FlutterLogo(
              size: 150,
            ),
          ),
        ),
      ],
    );
  }
}
