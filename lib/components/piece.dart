enum ChessPieceTypes {pawn, knight, bishop, rook, queen, king}

class Piece{
  // every piece has a type, color and image
  final ChessPieceTypes type;
  final bool isBlack;
  final String imagePath;

  Piece({
    required this.type,
    required this.isBlack,
    required this.imagePath
  });

}