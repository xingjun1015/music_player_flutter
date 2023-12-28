import 'package:flutter/material.dart';
import 'package:music_player_flutter/consts/colors.dart';

ourStyle({fontweight = FontWeight.normal, double? size = 14, color = whiteColor}){
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: fontweight
  );
}