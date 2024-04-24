import 'package:flutter/material.dart';

const scaffoldColor = Color(0xFF1A1A1A);
const secondaryColor = Color(0xFFFFC107);
const textColor = Color(0xFFFFFFFF);
const itemColor = Color(0xFF2A2A2A);
const smallText = TextStyle(fontSize: 10);
const mediumSmallText = TextStyle(fontSize: 15);
const mediumText = TextStyle(fontSize: 20);
const mediumLargeText = TextStyle(fontSize: 25);
const largeText = TextStyle(fontSize: 30);
const hugeText = TextStyle(fontSize: 40);

// Used in details page for left space
SizedBox configWidth(double valW, double width, double height) {
  return SizedBox(
    width: valW * width,
    height: valW * height,
  );
}

// Used in details page for episodes, seasons and air date, runtime etc
Column detailColumn(String name, String request) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$name: ",
        style: mediumSmallText,
      ),
      const SizedBox(height: 5),
      Text(
        request,
        style: mediumText.copyWith(fontSize: 18),
      ),
    ],
  );
}
