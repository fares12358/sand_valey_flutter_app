import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class customLayout extends StatelessWidget {
  const customLayout({
    super.key,
    required this.text,
    required this.image,
    required this.routeName,
  });

  final String routeName;
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 120,
      width: deviceWidth * 0.9,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: circularBox(image, text, context, routeName),
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
) {
  double deviceWidth = MediaQuery.of(context).size.width;
  final bool isNetworkImage = image.toLowerCase().startsWith('http');

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
            child: roundedRectangle(text, context),
          ),
          Positioned(
            left: 3,
            top: 2,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffFFA927),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: isNetworkImage
                      ? NetworkImage(image)
                      : AssetImage(image) as ImageProvider,
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

Widget roundedRectangle(String text, BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double targetWidth;

      if (screenWidth < 400) {
        targetWidth = screenWidth * 0.65;
      } else if (screenWidth < 600) {
        targetWidth = screenWidth * 0.70;
      } else if (screenWidth >= 700 && screenWidth <= 900) {
        targetWidth = screenWidth * 0.50;
      } else {
        targetWidth = screenWidth * 0.40;
      }

      return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: targetWidth,
          child: Container(
            constraints: const BoxConstraints(minHeight: 50, maxHeight: 120),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3B970C),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: AutoSizeText(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              maxLines: 2,
              minFontSize: 16,
              stepGranularity: 1,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    },
  );
}
