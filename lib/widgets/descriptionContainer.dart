import 'package:flutter/material.dart';

class Descriptioncontainer extends StatelessWidget {
  const Descriptioncontainer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double targetWidth;

        if (width < 375) {
          targetWidth = 250;
        } else if (width < 425) {
          targetWidth = 300;
        } else if (width < 700) {
          targetWidth = 350;
        } else if (width < 900) {
          targetWidth = 600;
        } else if (width < 1300) {
          targetWidth = 700;
        } else {
          targetWidth = 800;
        }

        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: targetWidth,
            height: 350, // Fixed height to enable scroll
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF3B970C), width: 2),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // Optional smooth scroll
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        );
      },
    );
  }
}
