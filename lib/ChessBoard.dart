import 'package:chess/components/piece.dart';
import 'package:flutter/material.dart';
import 'components/dead_piece.dart';
import 'components/square.dart';
import 'other/functions.dart';

class ChessBoard extends StatefulWidget {
  ChessBoard({Key? key}) : super(key: key);

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}


class _ChessBoardState extends State<ChessBoard> {
  // 2-dimensional List to represent the board
  late List<List<Piece?>> board;

  // we should have a variable for selected piece
  Piece? selectedPiece;

  // the row index of the selected piece
  // negative means no piece is currently selected
  int selectedRow = -1;

  // the column index of the selected piece
  // negative means no piece is currently selected
  int selectedColumn = -1;

  // a list of valid moves for selected piece
  // each move is represented as a list with 2 elements: row & column
  List<List<int>> validMoves = [];

  // a list of white pieces which has been taken by black player
  List<Piece> takenWhite = [];

  // a list of black pieces which has been taken by white player
  List<Piece> takenBlack = [];

  @override
  void initState(){
    super.initState();
    _initializeBoard();
  }

  // initialize the board
  void _initializeBoard(){
    // initialize the board with no pieces in those position
    List<List<Piece?>> newBoard = List.generate(8, (index) => List.generate(8, (index) => null));

    // TEST: place any random piece to middle of the board
    /*newBoard[2][4] = Piece(type: ChessPieceTypes.knight, isBlack: false, imagePath: 'pieces/wKnight.png');
    newBoard[3][3] = Piece(type: ChessPieceTypes.rook, isBlack: false, imagePath: 'pieces/bRook.png');
    newBoard[3][4] = Piece(type: ChessPieceTypes.bishop, isBlack: true, imagePath: 'pieces/wBishop.png');
    newBoard[4][3] = Piece(type: ChessPieceTypes.queen, isBlack: false, imagePath: 'pieces/wQueen.png');
*/
    //PLACING ALL THE PIECES
    // placing pawns
    for(int i = 0; i < 8; i++){
      newBoard[6][i] = Piece(type: ChessPieceTypes.pawn, isBlack: false, imagePath: 'pieces/bPawn.png');
      newBoard[1][i] = Piece(type: ChessPieceTypes.pawn, isBlack: true, imagePath: 'pieces/wPawn.png');
    }
    // placing knights
    newBoard[0][1] = Piece(type: ChessPieceTypes.knight, isBlack: true, imagePath: 'pieces/bKnight.png');
    newBoard[0][6] = Piece(type: ChessPieceTypes.knight, isBlack: true, imagePath: 'pieces/bKnight.png');
    newBoard[7][1] = Piece(type: ChessPieceTypes.knight, isBlack: false, imagePath: 'pieces/bKnight.png');
    newBoard[7][6] = Piece(type: ChessPieceTypes.knight, isBlack: false, imagePath: 'pieces/bKnight.png');

    // placing bishops
    newBoard[0][2] = Piece(type: ChessPieceTypes.bishop, isBlack: true, imagePath: 'pieces/bBishop.png');
    newBoard[0][5] = Piece(type: ChessPieceTypes.bishop, isBlack: true, imagePath: 'pieces/bBishop.png');
    newBoard[7][2] = Piece(type: ChessPieceTypes.bishop, isBlack: false, imagePath: 'pieces/bBishop.png');
    newBoard[7][5] = Piece(type: ChessPieceTypes.bishop, isBlack: false, imagePath: 'pieces/bBishop.png');

    // placing rooks
    newBoard[0][0] = Piece(type: ChessPieceTypes.rook, isBlack: true, imagePath: 'pieces/bRook.png');
    newBoard[0][7] = Piece(type: ChessPieceTypes.rook, isBlack: true, imagePath: 'pieces/bRook.png');
    newBoard[7][0] = Piece(type: ChessPieceTypes.rook, isBlack: false, imagePath: 'pieces/wRook.png');
    newBoard[7][7] = Piece(type: ChessPieceTypes.rook, isBlack: false, imagePath: 'pieces/wRook.png');

    // placing queens
    newBoard[0][3] = Piece(type: ChessPieceTypes.queen, isBlack: true, imagePath: 'pieces/bQueen.png');
    newBoard[7][3] = Piece(type: ChessPieceTypes.queen, isBlack: false , imagePath: 'pieces/wQueen.png');

    // placing kings
    newBoard[0][4] = Piece(type: ChessPieceTypes.king, isBlack: true, imagePath: 'pieces/bKing.png');
    newBoard[7][4] = Piece(type: ChessPieceTypes.king, isBlack: false, imagePath: 'pieces/wKing.png');

    board = newBoard;
  }

  // User selected a piece
  void pieceSelected(int row, int column) {
    setState(() {
      // if there is a piece in that position, select
      // if(board[row][column] != null){
      //     selectedPiece = board[row][column];
      //     selectedRow = row;
      //     selectedColumn = column;
      // }

      // no piece has been selected yet, this is the first selection
      if(selectedPiece == null && board[row][column] != null){
        selectedPiece = board[row][column];
        selectedRow = row;
        selectedColumn = column;
      }
      // there is a piece already selected, but user can select another one of their pieces
      else if (board[row][column] != null &&
          board[row][column]!.isBlack == selectedPiece!.isBlack){
        selectedPiece = board[row][column];
        selectedRow = row;
        selectedColumn = column;
      }
      // also for white pieces
      else if (board[row][column] != null &&
          !board[row][column]!.isBlack == !selectedPiece!.isBlack){
        selectedPiece = board[row][column];
        selectedRow = row;
        selectedColumn = column;
      }

      // if there is a piece selected AND
      // if user taps the square which is valid THEN
      else if (selectedPiece != null && 
          validMoves.any((element) => element[0] == row && element[1] == column)){
         // call the function to move there
        movePiece(row, column);
      }
      // DO move there

      // calculate pieces valid moves
      validMoves = calculateRawValidMoves(selectedRow, selectedColumn, selectedPiece);
    });
  }

  //Calculate raw valid moves
  List<List<int>> calculateRawValidMoves(int row, int column, Piece? piece){

    List<List<int>> candidateMoves = [];

    if (piece == null){
       return [];
    }

    // different directions based on their color
    int direction = piece.isBlack ? 1 : -1;

    switch (piece.type){
      case ChessPieceTypes.pawn:
        // if the square is free, it can move forward
      if(isInBoard(row + direction, column) && // check if desirable square is in board
          board[row+direction][column] == null ){ // means the square is free
          candidateMoves.add([row + direction, column]);
      }

      // can move 2 square if it is still its starts position
      // for black
      if ((row == 1) && piece.isBlack || (row == 6) && !piece.isBlack ){
          if(isInBoard(row+2*direction, column) && // makes not so sense to check this.
              board[row +2 * direction][column] == null &&
              board[row + direction][column] == null) {
            candidateMoves.add([row + 2 * direction, column]);
          }
      }
      // for white
      if ((row == 1) && !piece.isBlack || (row == 6) && piece.isBlack ){
        if(isInBoard(row+2*direction, column) && // makes not so sense to check this.
            board[row +2 * direction][column] == null &&
            board[row + direction][column] == null) {
          candidateMoves.add([row + 2 * direction, column]);
        }
      }
        // can be kill diagonally
      if(isInBoard(row+direction, column -1 ) &&
          board[row+direction][column-1] != null &&
          !board[row+direction][column-1]!.isBlack) {
        candidateMoves.add([row + direction, column - 1]);
      }
      if(isInBoard(row+direction, column +1 ) &&
          board[row+direction][column+1] != null &&
          !board[row+direction][column+1]!.isBlack) {
        candidateMoves.add([row + direction, column + 1]);
      }

      if(isInBoard(row+direction, column + 1 ) &&
          board[row+direction][column+1] != null &&
          board[row+direction][column+1]!.isBlack) {
        candidateMoves.add([row + direction, column + 1]);
      }
      if(isInBoard(row+direction, column -1 ) &&
          board[row+direction][column-1] != null &&
          board[row+direction][column-1]!.isBlack) {
        candidateMoves.add([row + direction, column - 1]);
      }


      // DO NOT FORGET EN PASSANT !!!!

        break;
      case ChessPieceTypes.knight:
        // it has 8 possible L moves
      var knightMoves = [
        [-2,-1], // 2 up, 1 left
        [-2, 1], // 2 up, 1 right
        [-1,-2], // 1 up, 2 left
        [-1,2], // 1 up, 2 right
        [1,-2], // 1 down, 2 left
        [1,2], // 1 down, 2 right
        [2,-1], // 2 down, 1 left
        [2,1], // 2 down, 1 right
      ];

      // move is a variable that represents the temporary
      // value of an element in the knightMoves list at each iteration.
      for(var move in knightMoves){
        var newRow = row + move[0];
        var newColumn = column + move[1];

        // check if the square that we trying to go is in square
        if(!isInBoard(newRow, newColumn)){
          continue;
        }
        if(board[newRow][newColumn] != null){
          // check we may hit
          //black can hit
          if(!board[newRow][newColumn]!.isBlack && piece.isBlack){
            candidateMoves.add([newRow, newColumn]); // hit
          }
          // white can hit
          if(board[newRow][newColumn]!.isBlack && !piece.isBlack){
            candidateMoves.add([newRow, newColumn]); // hit
          }
          continue; // if its the same color with us
        }
        candidateMoves.add([newRow, newColumn]);
      }
        break;

      case ChessPieceTypes.bishop:
        // diagonal
      var directions = [
        [-1,-1], // up left
        [-1,1], // up right
        [1,-1], // down left
        [1,1], // up right
      ];

      for( var direction in directions){
        var i = 1 ;
        while(true){
          // so we can get every square until we get blocked
          var newRow = row+i*direction[0];
          var newColumn = column+i*direction[1];

          // check if the square is in board, that we want to bring the piece
          if(!isInBoard(newRow, newColumn)){
            break;
          }

          // check, if position we are trying to go is not null
          // if there is a piece
          if(board[newRow][newColumn] != null){
            // check if we can hit the piece
            if(!board[newRow][newColumn]!.isBlack && piece.isBlack){
              candidateMoves.add([newRow, newColumn]); // kill
            }
            if(board[newRow][newColumn]!.isBlack && !piece.isBlack){
              candidateMoves.add([newRow, newColumn]); // kill
            }
            break;
          }
          candidateMoves.add([newRow,newColumn]);
          i++;

        }
      }
        break;
      case ChessPieceTypes.rook:
        // horizontal or vertical
      var directions = [
        [-1,0], // up
        [1,0], // down
        [0,-1], // left
        [0,1] // right
      ];

      for(var direction in directions){
        var i = 1;
        while(true){
          // so we can get every square until we get blocked
          var newRow = row+i*direction[0];
          var newColumn = column+i*direction[1];

          // check if the square is in board, that we want to bring the piece
          if(!isInBoard(newRow, newColumn)){
            break;
          }

          // check, if position we are trying to go is not null
          // if there is a piece
          if(board[newRow][newColumn] != null){
            // check if we can hit the piece
            if(!board[newRow][newColumn]!.isBlack && piece.isBlack){
              candidateMoves.add([newRow, newColumn]);
            }
            if(board[newRow][newColumn]!.isBlack && !piece.isBlack){
              candidateMoves.add([newRow, newColumn]);
            }
            break;
          }
          candidateMoves.add([newRow,newColumn]);
          i++;
        }
      }
        break;
      case ChessPieceTypes.queen:
        // has 8 different directions
      // left, right, up, down and 4 diagonals
      var directions = [
        [0,-1], // left
        [0,1], // right
        [-1,0], // up
        [1,0], // down
        [-1,-1], // up left
        [-1,1], // up right
        [1,-1], // down left
        [1,1] // down right
      ];

      for(var direction in directions) {
        var i = 1;
        while(true){
          // so we can get every square until we get blocked
          var newRow = row+i*direction[0];
          var newColumn = column+i*direction[1];

          // check if the square is in board, that we want to bring the piece
          if(!isInBoard(newRow, newColumn)){
            break;
          }

          // check, if position we are trying to go is not null
          // if there is a piece
          if(board[newRow][newColumn] != null){
            // check if we can hit the piece
            if(!board[newRow][newColumn]!.isBlack && piece.isBlack){
              candidateMoves.add([newRow, newColumn]);
            }
            if(board[newRow][newColumn]!.isBlack && !piece.isBlack){
              candidateMoves.add([newRow, newColumn]);
            }
            break;
          }
          candidateMoves.add([newRow,newColumn]);
          i++;
        }
      }

        break;
      case ChessPieceTypes.king:
        // all 8 moves like queen
        var directions = [
          [0,-1], // left
          [0,1], // right
          [-1,0], // up
          [1,0], // down
          [-1,-1], // up left
          [-1,1], // up right
          [1,-1], // down left
          [1,1] // down right
        ];

        for(var direction in directions) {

            // so we can get every square until we get blocked
            var newRow = row+direction[0];
            var newColumn = column+direction[1];

            // check if the square is in board, that we want to bring the piece
            // if(!isInBoard(newRow, newColumn)){
            //   break;
            // }
            //
            // // check, if position we are trying to go is not null
            // // if there is a piece
            // if(board[newRow][newColumn] != null){
            //   // check if we can hit the piece
            //   if(!board[newRow][newColumn]!.isBlack && piece.isBlack){
            //     candidateMoves.add([newRow, newColumn]);
            //   }
            //   if(board[newRow][newColumn]!.isBlack && !piece.isBlack){
            //     candidateMoves.add([newRow, newColumn]);
            //   }
            //   break;
            // }
            // candidateMoves.add([newRow,newColumn]);

            //for black king
            if(piece.isBlack){
              if(isInBoard(newRow, newColumn) ){
                  if(board[newRow][newColumn] == null) {
                    // if new square is empty just go there
                    candidateMoves.add([newRow, newColumn]);
                  }
                  else if(board[newRow][newColumn] != null){
                    // check if we can hit
                    if(!board[newRow][newColumn]!.isBlack){
                      candidateMoves.add([newRow, newColumn]);
                    }
                  }
              }
            }

            //for white king
            if(!piece.isBlack){
              if(isInBoard(newRow, newColumn) ){
                if(board[newRow][newColumn] == null) {
                  // if new square is empty just go there
                  candidateMoves.add([newRow, newColumn]);
                }
                else if(board[newRow][newColumn] != null){
                  // check if we can hit
                  if(board[newRow][newColumn]!.isBlack){
                    candidateMoves.add([newRow, newColumn]);
                  }
                }
              }
            }



        }


        // for(var direction in directions){
        //   var newRow = row + direction[0];
        //   var newColumn = column + direction[1];
        //
        //   // check if the square is in board, that we want to bring the piece
        //   if(!isInBoard(newRow, newColumn)){
        //     break;
        //   }
        //
        //   // check, if position we are trying to go is not null
        //   // if there is a piece
        //   if(board[newRow][newColumn] != null){
        //     // check if we can hit the piece
        //     if(!board[newRow][newColumn]!.isBlack && piece.isBlack){
        //       candidateMoves.add([newRow, newColumn]);
        //     }
        //     if(board[newRow][newColumn]!.isBlack && !piece.isBlack){
        //       candidateMoves.add([newRow, newColumn]);
        //     }
        //     break;
        //   }
        //   candidateMoves.add([newRow,newColumn]);
        // }

        break;
      default:
    }
    return candidateMoves;
  }

  // move pieces
  void movePiece(int newRow, int newColumn){

    // if the new spot has any piece
    if (board[newRow][newColumn] != null){
      // add captured piece to captured list
      var capturedPiece = board[newRow][newColumn];

      if(!capturedPiece!.isBlack){
        takenWhite.add(capturedPiece);
      }
      else if(capturedPiece.isBlack){
        takenBlack.add(capturedPiece);
      }
    }

    // move the piece
    board[newRow][newColumn] = selectedPiece;
    board[selectedRow][selectedColumn] = null;
    // clear the old spot
    // clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedColumn = -1;
      validMoves = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5,11,5,20),
        child: Column(
          children: [
            // show the white pieces which are taken
            Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemCount:  takenWhite.length,
              itemBuilder: (context, index) => DeadPiece(
                imagePath: takenWhite[index].imagePath,
                isBlack: false,
              ),
            ),
            ),
            
            // chess board
            Expanded(
              flex: 3,
              child: GridView.builder(
                // determine the size of game board
                itemCount: 8 * 8,
                // make it not scrollable
                  physics: const NeverScrollableScrollPhysics(),
                // divide the screen in parts which has 8 index per horizontal line
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8 ),

                  itemBuilder: (context, index) {

                  // get the row and column position of this square
                    int row = index ~/8;
                    int column = index % 8;

                    // check if the square is selected
                    bool isSelected = selectedRow == row && selectedColumn == column;

                    // check if this square is valid move
                    bool isValidMove = false;
                    for( var position in validMoves) {
                      // compare row and column
                      if(position[0] == row && position[1] == column) {
                        isValidMove = true;
                      }
                    }

                    return Square(
                        isWhite: isWhite(index),
                      piece: board[row][column],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap:  () => pieceSelected(row, column),
                    );
                  } // item builder
              ),
            ),
            // show the black pieces which are taken
            Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemCount:  takenBlack.length,
              itemBuilder: (context, index) => DeadPiece(
                imagePath: takenBlack[index].imagePath,
                isBlack: true,
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
