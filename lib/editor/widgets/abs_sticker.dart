
// Abs Sticker for Editor
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AbsSticker extends StatelessWidget {
  const AbsSticker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      padding: EdgeInsets.zero,
      dashPattern: const [5, 3],
      radius: const Radius.circular(18),
      color: Colors.red.withOpacity(0.9),
      child: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade700.withOpacity(0.2),
        ),
        child: Center(child: Image.asset('assets/sticker.jpg')),
      ),
    );
  }
}