import 'package:flutter/material.dart';

class Basiccontainer extends StatelessWidget {
  const Basiccontainer({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return regularContainer(text);
  }
}

Widget regularContainer(String text) {
  return Container(
    height: 35,
    width: double.infinity,
    color: const Color(0xFF3B970C),
    child: Text(
      text,
      style: const TextStyle(fontSize: 20 , color: Colors.white,fontWeight: FontWeight.bold,),
      textAlign: TextAlign.center,
    ),
  );
}
