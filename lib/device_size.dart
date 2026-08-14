import 'package:flutter/material.dart';

enum ScreenSize { Compact, Medium, Expanded, Large }
ScreenSize getSize(BuildContext context) {
  double deviceWidth = MediaQuery.sizeOf(context).width;
  if (deviceWidth >= 1200) return ScreenSize.Large;
  if (deviceWidth >= 840) return ScreenSize.Expanded;
  if (deviceWidth >= 600) return ScreenSize.Medium;
  return ScreenSize.Compact;
}