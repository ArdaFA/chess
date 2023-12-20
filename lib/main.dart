import 'package:flutter/material.dart';
import 'ChessBoard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // delete the sign
      debugShowCheckedModeBanner: false,
      home: ChessBoard(),
    );
  }
}
