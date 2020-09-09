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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Material(
                child: InkWell(
                  splashColor: Colors.yellowAccent,
                  onTap: () {
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
                  child: Row(
                    children: [
                      SizedBox(width: 10, height: 10),
                      Expanded(child: Text("Easy")),
                      Icon(
                        gameDataList[0].selected ? (Icons.check) : (Icons.check_box_outline_blank),
                  
                      ),
                      SizedBox(height: 10, width: 10),
                    ],
                  ),
                ),
              ),
            ),
            //Spacer(flex: 3),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Material(
                child: InkWell(
                  splashColor: Colors.yellowAccent,
                  onTap: () {
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
                  child: Row(
                    children: [
                      SizedBox(width: 10, height: 10),
                      Expanded(child: Text("Medium")),
                      Icon(
                        gameDataList[1].selected ? (Icons.check) : (Icons.check_box_outline_blank),
                  
                      ),
                      SizedBox(height: 10, width: 10),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Material(
                child: InkWell(
                  splashColor: Colors.yellowAccent,
                  onTap: () {
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
                  child: Row(
                    children: [
                      SizedBox(width: 10, height: 10),
                      Expanded(child: Text("Hard")),
                      Icon(
                        gameDataList[2].selected ? (Icons.check) : (Icons.check_box_outline_blank),
                  
                      ),
                      SizedBox(height: 10, width: 10),
                    ],
                  ),
                ),
              ),
            ),
            
            
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Material(
                child: InkWell(
                  splashColor: Colors.yellowAccent,
                  onTap: () {
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
                  child: Row(
                    children: [
                      SizedBox(width: 10, height: 10),
                      Expanded(child: Text("Sandbox")),
                      Icon(
                        gameDataList[3].selected ? (Icons.check) : (Icons.check_box_outline_blank),
                  
                      ),
                      SizedBox(height: 10, width: 10),
                    ],
                  ),
                ),
              ),
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


      PuzzleOptions puzzleOptions = new PuzzleOptions(difficulty: 1);
      Puzzle puzzle = new Puzzle(puzzleOptions);
      puzzle.generate().then((value) {
        
        List<List<Cell>> myboard = puzzle.board().matrix();
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            
            if (myboard[i][j].getValue() != 0) {
              controllers[i * 9 + j].text = myboard[i][j].getValue().toString();
              readOnly[i * 9 + j] = true;
            }
          }
        }
        
      });
      
      
    }


    else if (gameDataList[index].difficulty == "Medium") {
      PuzzleOptions puzzleOptions = new PuzzleOptions(difficulty: 2);
      Puzzle puzzle = new Puzzle(puzzleOptions);
      puzzle.generate().then((value) {

        List<List<Cell>> myboard = puzzle.board().matrix();
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {

            if (myboard[i][j].getValue() != 0) {
              controllers[i * 9 + j].text = myboard[i][j].getValue().toString();
              readOnly[i * 9 + j] = true;
            }
          }
        }

      });
      
      
    }
    else if (gameDataList[index].difficulty == "Hard") {
      PuzzleOptions puzzleOptions = new PuzzleOptions(difficulty: 3);
      Puzzle puzzle = new Puzzle(puzzleOptions);
      puzzle.generate().then((value) {

        List<List<Cell>> myboard = puzzle.board().matrix();
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
  
            if (myboard[i][j].getValue() != 0) {
              controllers[i * 9 + j].text = myboard[i][j].getValue().toString();
              readOnly[i * 9 + j] = true;
            }
          }
        }

      });
      

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