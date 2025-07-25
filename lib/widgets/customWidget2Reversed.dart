import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomWidget2Reversed extends StatelessWidget {
  final String text;
  final String image; // Can be a URL or asset path
  final String routeName;
  final Color customColor;
  final Color customBorderColor;
  final Map<String, dynamic>? arguments;

  const CustomWidget2Reversed({
    super.key,
    required this.text,
    required this.image,
    required this.routeName,
    required this.arguments,
    required this.customColor,
    required this.customBorderColor,
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
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, routeName, arguments: arguments);
              },
              child: Container(
                width: deviceWidth * 0.8,
                child: Stack(
                  children: [
                    Positioned(
                      right: 55,
                      top: 55,
                      child: roundedRectangle(text, context),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: customBorderColor,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  color: Color(0xFF3B970C),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 110),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              decoration: BoxDecoration(
                color: customColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: AutoSizeText(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 17),
                maxLines: 3,
                stepGranularity: 1,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        );
      },
    );
  }
}
