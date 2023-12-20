import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final String imagePath;
  final bool isBlack;
  const DeadPiece({Key? key,
    required this.imagePath,
    required this.isBlack
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        imagePath
    );
  }
}
