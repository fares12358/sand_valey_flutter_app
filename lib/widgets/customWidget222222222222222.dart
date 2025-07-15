import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomWidget2 extends StatelessWidget {
  final String text;
  final String image;
  final String routeName;
  final Color customColor;
  final Color customBorderColor;

  const CustomWidget2({
    super.key,
    required this.text,
    required this.image,
    required this.routeName,
    required this.customColor,
    required this.customBorderColor, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 150,
      width: deviceWidth * 0.9,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: circularBox(
                image,
                text,
                context,
                routeName,
                customColor,
                customBorderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget circularBox(
  String image,
  String text,
  BuildContext context,
  String routeName,
  Color customColor,
  Color customBorderColor,
) {
  double deviceWidth = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, routeName);
    },
    child: Container(
      width: deviceWidth * 0.8,
      child: Stack(
        children: [
          Positioned(
            left: 50,
            top: 55,
            child: roundedRectangle(text, context, customColor),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                border: Border.all(
                  color: customBorderColor,
                  width: 3,
                  style: BorderStyle.solid,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget roundedRectangle(String text, BuildContext context, Color customColor) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double targetWidth;
      if (screenWidth < 400) {
        targetWidth = screenWidth * 0.65; // small phones
      } else if (screenWidth < 600) {
        targetWidth = screenWidth * 0.70; // medium screens like 425
      } else if (screenWidth >= 700 && screenWidth <= 900) {
        targetWidth = screenWidth * 0.50; // large tablets
      } else {
        targetWidth = screenWidth * 0.40; // large tablets
      }

      return Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: targetWidth,
          child: Container(
            constraints: const BoxConstraints(minHeight: 50, maxHeight: 110),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
            decoration: BoxDecoration(
              color: customColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Padding(
              padding:  const EdgeInsets.only(left: 15),
              child: AutoSizeText(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                maxLines: 3,
                minFontSize: 14,
                stepGranularity: 1,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    },
  );
}
