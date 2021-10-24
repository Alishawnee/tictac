import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  bool isPlayerTurn = true;
  final tiles = List.generate(9, (_) => '');

  final winningTiles = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  String? winner;
  void checkWinner({bool isOpponent = false}) {
    for (final answerIndexes in winningTiles) {
      final first = tiles.elementAt(answerIndexes.first);
      final middle = tiles.elementAt(answerIndexes[1]);
      final last = tiles.elementAt(answerIndexes.last);
      if (first == middle && middle == last && first.isNotEmpty) {
        setState(() {
          winner = isOpponent ? 'O' : 'X';
        });
      }
    }
  }
  void opponentPlays() {
    if (winner != null) return;
    final index = Random().nextInt(9);
    if (tiles[index].isEmpty) {
      setState(() {
        tiles[index] = '0';
        isPlayerTurn = !isPlayerTurn;
      });
    } else {
      opponentPlays();
    }
    checkWinner(isOpponent: true);
  }

  @override
  Widget build(BuildContext context) {
    final haveWinner = winner != null;
    final haveStarted = !tiles.every((element) => element.isEmpty);
    final isDraw = tiles.every((element) => element.isNotEmpty);

    String playButtonText() {
      if (!haveStarted) {
        return startText;
      } else if (isDraw && !haveWinner) {
        return noWinnerText;
      } else if (haveWinner) {
        return gameOverText(winner!);
      } else {
        return isPlayerTurn ? playerTurnText : opponentTurnText;
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tic - Tac - Toe',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                    fontFamily: franchiseFont,
                  ),
            ),
            SizedBox(height: 20),
            GridView.count(
              padding: EdgeInsets.all(15),
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                tiles.length,
                (index) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.primaries[index],
                    side: BorderSide(width: 2, color: Colors.black),
                    shape: BeveledRectangleBorder(),
                  ),
                  onPressed: () {
                    if (tiles[index].isNotEmpty || haveWinner || isDraw) return;
                    setState(() {
                      tiles[index] = 'X';
                      checkWinner();
                      isPlayerTurn = !isPlayerTurn;
                    });
                    opponentPlays();
                  },
                  child: Text(
                    tiles[index],
                    style: TextStyle(
                      fontSize: 110,
                      fontFamily: franchiseFont,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (haveWinner || isDraw) {
                  setState(() {
                    tiles.setAll(0, List.generate(tiles.length, (_) => ''));
                    winner = null;
                    isPlayerTurn = true;
                  });
                }
              },
              child: Text(
                playButtonText().toUpperCase(),
                textAlign: TextAlign.center,
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(
                  fontFamily: 'PressStart',
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const startText = "Press any box to start";
const franchiseFont = 'Franchise';
const playerTurnText = "Your turn";
const opponentTurnText = "Opponent's turn";
const noWinnerText = "It's a draw. \n \n Press here to play again";
String gameOverText(String winner) {
  return "Winner is $winner. \n \n Press here to play again";
}
