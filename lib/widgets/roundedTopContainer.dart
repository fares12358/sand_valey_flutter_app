import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Roundedtopcontainer extends StatelessWidget {
  const Roundedtopcontainer({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return roundedTopContainerWidget(text, color);
  }
}

Widget roundedTopContainerWidget(String text, Color color) {
  return ClipPath(
    clipper: ArcClipper(),
    child: Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 140, maxHeight: 140),
      decoration: BoxDecoration(
        color: color.withOpacity(0.69),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: AutoSizeText(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          minFontSize: 15,
          stepGranularity: 1,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
    ),
  );
}


class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 70); // Go down from top-left

    path.quadraticBezierTo(
      size.width / 2, size.height + 5, // Control point for arc
      size.width, size.height - 70,     // End point at bottom-right
    );

    path.lineTo(size.width, 0); // Up to top-right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
