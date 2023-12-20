import 'package:chess/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  // it has just two option: white or black
  final bool isWhite;

  // and square may have a piece
  final Piece? piece;

  // to see if its selected
  final bool isSelected;

  final bool isValidMove;

  // required func for onTap
  final void Function()? onTap;

  // Constructor
  const Square({Key? key, required this.isWhite, this.piece, required this.isSelected, this.onTap, required this.isValidMove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    // if selected blue
    if (isSelected){
      squareColor = Colors.blue[500];
    }
    else if (isValidMove){
      squareColor = Colors.blue[200];
    }
    //otherwise white or black
    else {
      squareColor = isWhite ? Colors.green[300] : Colors.green[900];
    }


    // Gesture Detector for selecting pieces
    return GestureDetector(
      onTap: onTap, // this onTap on right side: we defined it over in this class
      child: Container(
        // color: isWhite ? Colors.amber[50] : Colors.brown,
        //color: isWhite ? Colors.green[300] : Colors.green[900],
        color: squareColor,
        margin: const EdgeInsets.all(1),
        child: piece != null
            ? Image.asset(
            piece!.imagePath,
          // color: piece!.isBlack ? Colors.brown[900] : Colors.brown[200],
          color: piece!.isBlack ? Colors.black : Colors.white,
        )
            : null , // ! for safety
      ),
    );
  }
}
