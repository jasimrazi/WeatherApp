import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final double? size;
  const HeaderText({super.key, required this.text, this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: size ?? 18, 
      ),
    );
  }
}
