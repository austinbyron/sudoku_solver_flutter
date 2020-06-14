import 'package:flutter/material.dart';

import 'boardui.dart';
import 'dart:core';
import 'main.dart';
import 'dart:math';
import 'package:sudoku_api/sudoku_api.dart';

List<TextEditingController> controllers = new List();
List<FocusNode> nodes = new List();
List<bool> readOnly = new List();

 List<GameData> gameDataList = [
    new GameData(difficulty: "Easy", selected: false),
    new GameData(difficulty: "Medium", selected: false),
    new GameData(difficulty: "Hard", selected: false),
    new GameData(difficulty: "Sandbox", selected: false),

  ];

class GameInitialize extends StatefulWidget {

  const GameInitialize();

  @override
  _GameInitialize createState() => _GameInitialize();

}

class _GameInitialize extends State<GameInitialize> {

  @override
  void initState() {
    for (int i = 0; i < 81; i++) {
      controllers.add(new TextEditingController());
      nodes.add(new FocusNode());
      badTile.add(false);
      readOnly.add(false);
    }
    super.initState();
  }

  @override
  void dispose() {
    
    for (int i = 0; i < 81; i++) {
      controllers[i].dispose();
      nodes[i].dispose();
    }
    controllers.clear();
    nodes.clear();
    super.dispose();
  }

  //int _index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select difficulty")),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 10, height: 10),
                Expanded(child: Text("Easy")),
                IconButton(
                  icon: gameDataList[0].selected ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    for (int i = 0; i < gameDataList.length; i++) {
                      if (i == 0) {
                        setState(() {
                          gameDataList[i].selected = !gameDataList[i].selected;
                        });
                      }
                      else {
                        setState(() {
                          gameDataList[i].selected = false;
                        });
                      }
                    }
                  },
                )
              ],
            ),
            //Spacer(flex: 3),
            Row(
              children: [
                SizedBox(width: 10, height: 10),
                Expanded(child: Text("Medium")),
                IconButton(
                  icon: gameDataList[1].selected ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    for (int i = 0; i < gameDataList.length; i++) {
                      if (i == 1) {
                        setState(() {
                          gameDataList[i].selected = !gameDataList[i].selected;
                        });
                      }
                      else {
                        setState(() {
                          gameDataList[i].selected = false;
                        });
                      }
                    }
                  },
                )
              ],
            ),
            //Spacer(flex: 3),
            Row(
              children: [
                SizedBox(width: 10, height: 10),
                Expanded(child: Text("Hard")),
                IconButton(
                  icon: gameDataList[2].selected ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    for (int i = 0; i < gameDataList.length; i++) {
                      if (i == 2) {
                        setState(() {
                          gameDataList[i].selected = !gameDataList[i].selected;
                        });
                      }
                      else {
                        setState(() {
                          gameDataList[i].selected = false;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
            //Spacer(flex: 3),
            Row(
              children: [
                SizedBox(width: 10, height: 10),
                Expanded(child: Text("Sandbox")),
                IconButton(
                  icon: gameDataList[3].selected ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    for (int i = 0; i < gameDataList.length; i++) {
                      if (i == 3) {
                        setState(() {
                          gameDataList[i].selected = !gameDataList[i].selected;
                        });
                      }
                      else {
                        setState(() {
                          gameDataList[i].selected = false;
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          for (int i = 0; i < gameDataList.length; i++) {
            if (gameDataList[i].selected == true) {

              await initGame(i);

              break;
            }
          }
          Navigator.push(context, MaterialPageRoute(builder: (context) => Sudoku())).then((value) {
            for (int i = 0; i < 81; i++) {
              controllers[i].text = "";
              badTile[i] = false;
              readOnly[i] = false;
            }
          });
        },
        
      ),
    );

  }

  Future<void> initGame(int index) async {

    if (gameDataList[index].difficulty == "Easy") {
      var rng = new Random();
      var randomNum = new Random();
      int random = 0;
      int filledWith = 0;
      int count = 0;

      PuzzleOptions puzzleOptions = new PuzzleOptions(difficulty: 1);
      Puzzle puzzle = new Puzzle(puzzleOptions);
      puzzle.generate().then((value) {
        printGrid(puzzle.board());
        List<List<Cell>> myboard = puzzle.board().matrix();
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            //print(myboard[i][j].getValue());
            if (myboard[i][j].getValue() != 0) {
              controllers[i * 9 + j].text = myboard[i][j].getValue().toString();
              readOnly[i * 9 + j] = true;
            }
          }
        }
        printGrid(puzzle.solvedBoard());
      });
      
      print(puzzle);
      
      print(count);
    }


    else if (gameDataList[index].difficulty == "Medium") {
      PuzzleOptions puzzleOptions = new PuzzleOptions(difficulty: 2);
      Puzzle puzzle = new Puzzle(puzzleOptions);
      puzzle.generate().then((value) {
        printGrid(puzzle.board());
        List<List<Cell>> myboard = puzzle.board().matrix();
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            //print(myboard[i][j].getValue());
            if (myboard[i][j].getValue() != 0) {
              controllers[i * 9 + j].text = myboard[i][j].getValue().toString();
              readOnly[i * 9 + j] = true;
            }
          }
        }
        printGrid(puzzle.solvedBoard());
      });
      
      print(puzzle);
      
      
    }
    else if (gameDataList[index].difficulty == "Hard") {
      PuzzleOptions puzzleOptions = new PuzzleOptions(difficulty: 3);
      Puzzle puzzle = new Puzzle(puzzleOptions);
      puzzle.generate().then((value) {
        printGrid(puzzle.board());
        List<List<Cell>> myboard = puzzle.board().matrix();
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            //print(myboard[i][j].getValue());
            if (myboard[i][j].getValue() != 0) {
              controllers[i * 9 + j].text = myboard[i][j].getValue().toString();
              readOnly[i * 9 + j] = true;
            }
          }
        }
        printGrid(puzzle.solvedBoard());
      });
      
      print(puzzle);
      
      
      //print(count);
    }
    else {
      for (int i = 0; i < 81; i++) {
        controllers[i].text = "";
        badTile[i] = false;
        readOnly[i] = false;
      }
    }
  }
}

class GameData {
  String difficulty;
  bool selected;

  GameData({@required String difficulty, @required bool selected}) {
    this.difficulty = difficulty;
    this.selected = selected;
  }
}





bool isAlreadyInBox(int index, int number) {
  int boxNum = getBoxNum(index);
  int start = boxNum * 9;

  for (int i = start; i < start + 9; i++) {
    if (number.toString() == controllers[i].text) return true;
  }

  return false;

}




int getBoxNum(int index) {
  return (index / 9).floor();
}