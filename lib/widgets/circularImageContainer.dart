import 'package:flutter/material.dart';

class Circularimagecontainer extends StatelessWidget {
  const Circularimagecontainer({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return circularContainer(image);
  }
}

Widget circularContainer(String image) {
  bool isNetwork = image.startsWith('http');

  return Container(
    width: 220,
    height: 220,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: const Color(0xffFFA927),
        width: 5,
      ),
    ),
    child: ClipOval(
      child: isNetwork
          ? Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 60,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffFFA927),
                  ),
                );
              },
            )
          : Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 60,
                  ),
                );
              },
            ),
    ),
  );
}
