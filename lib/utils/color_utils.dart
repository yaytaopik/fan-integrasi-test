import 'package:flutter/material.dart';
import 'package:fantest/utils/color_utils.dart';
import 'package:lottie/lottie.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}
