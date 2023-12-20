bool isWhite(int index) {
  int x = index ~/ 8; // integer of division
  int y = index % 8; // remainder of division

  // determine colors for each square
  bool isWhite = (x + y) % 2 == 0;
  return isWhite;

  /*
            // for line H
          if (index <= 7 && index >= 0) {
            if(index % 2 == 0){
              return const Square(isWhite: false);
            }
            else {
              return const Square(isWhite: true);
            }
          }
          // for line G
          if ( index >= 8 && index <= 15){
            if(index % 2 == 0){
              return const Square(isWhite: true);
            }
            else {
              return const Square(isWhite: false);
            }
          }
          // for line F
          if (index >=16 && index <= 23) {
            if(index % 2 == 0){
              return const Square(isWhite: false);
            }
            else {
              return const Square(isWhite: true);
            }
          }
          // for line E
          if ( index >= 24 && index <= 31){
            if(index % 2 == 0){
              return const Square(isWhite: true);
            }
            else {
              return const Square(isWhite: false);
            }
          }
          // for line D
          // for line F
          if (index >=32 && index <= 39) {
            if(index % 2 == 0){
              return const Square(isWhite: false);
            }
            else {
              return const Square(isWhite: true);
            }
          }
          // for line C
          if ( index >= 40 && index <= 47){
            if(index % 2 == 0){
              return const Square(isWhite: true);
            }
            else {
              return const Square(isWhite: false);
            }
          }
          // for line B
          if (index >=48 && index <= 55) {
            if(index % 2 == 0){
              return const Square(isWhite: false);
            }
            else {
              return const Square(isWhite: true);
            }
          }
          // for line A
          if ( index >= 56 && index <= 63){
            if(index % 2 == 0){
              return const Square(isWhite: true);
            }
            else {
              return const Square(isWhite: false);
            }
          }

            */
}

// check, if the square is in board, which we want to go
bool isInBoard(int row, int column) {
  return row >= 0 && row < 8 && column >= 0 && column < 8;
}

// check if en passant possible
// bool isEnPassantPossible(Piece pawn, int row, int column){
//   for (int i = 0; i<8; i++ ){
//     if(pawn.isBlack && !board[4][i].isBlack) {
//       return true;
//     }
//   }
//   return true;
// }
