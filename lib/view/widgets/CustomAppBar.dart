import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
          text: const TextSpan(
              text: "Wallpaper",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
              children: [
            TextSpan(text: " App", style: TextStyle(color: Colors.orange)),
          ])),
    );
  }
}
