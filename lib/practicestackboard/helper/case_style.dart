//Manipulating Shell Styles

import 'package:flutter/material.dart';

class CaseStyle {
  const CaseStyle({
    this.borderColor = Colors.white,
    this.borderWidth = 1,
    this.iconColor,
    this.iconSize = 24,
    this.boxAspectRatio,
    this.initOffset = Offset.zero,
  });

  ///* Border (including handle) color
  final Color borderColor;

  ///* border thickness
  final double borderWidth;

  ///* icon color
  final Color? iconColor;

  ///* icon size
  final double iconSize;

  // * border ratio /// * if(boxAspectRatio!=null) The zoom transformation will be fixed ratio
  final double? boxAspectRatio;

  ///* The initial position of the frame
  final Offset initOffset;
}
