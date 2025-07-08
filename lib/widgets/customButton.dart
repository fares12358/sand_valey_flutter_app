import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.icon, this.routeName});

  final Widget icon; // Can be Icon or Image
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 35,
      decoration: BoxDecoration(
        color: const Color(0xffF7941D),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: IconButton(
        onPressed: () {
          if (routeName != null) {
            Navigator.pushNamed(context, routeName!);
          }
        },
        icon: icon,
      ),
    );
  }
}
