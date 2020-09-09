import 'dart:core';
import 'package:flutter/services.dart';

import 'game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';


List<bool> badTile = new List();

class Sudoku extends StatefulWidget {

  const Sudoku();

  @override
  _Sudoku createState() => _Sudoku();
}

class _Sudoku extends State<Sudoku> {
  bool _solve = false;
  bool _check = false;

  

  Widget tableElement(BuildContext context, int index) {
  
    return Container(
      color: badTile[index] ? Colors.blueAccent : Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
        
        child: GestureDetector(
          onTap: () {
            
            FocusScope.of(context).requestFocus(nodes[index]);
          },
            child: Column(
              children: [
                TextFormField(
                controller: controllers[index],
                
                onTap: () {
                  if (FocusScope.of(context) != nodes[index]) 
                    FocusScope.of(context).requestFocus(nodes[index]);
                },
                onChanged: (text) {
                  
                  
                },

                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  
                },
                readOnly: readOnly[index],
                //maxLength: 1,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(1),
                  //BlacklistingTextInputFormatter('0'),
                  FilteringTextInputFormatter.deny('0'),
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                focusNode: nodes[index],
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
              
              ]
            ),
            
          ),
      ),
       
    );
  }

  
  //this is now the row, not the subtable, it was easier to 
  //backtrack this way
  Widget subTable(BuildContext context, int number) {

    int start = number * 9;

    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            tableElement(context, start + 0),
            tableElement(context, start + 1),
            tableElement(context, start + 2),
          
            tableElement(context, start + 3),
            tableElement(context, start + 4),
            tableElement(context, start + 5),
         
            tableElement(context, start + 6),
            tableElement(context, start + 7),
            tableElement(context, start + 8),
          ],
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    String title = "Sandbox Mode";
    for (int i = 0; i < gameDataList.length; i++) {
      if (gameDataList[i].selected == true) {
        title = "${gameDataList[i].difficulty} Mode";
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text("$title")),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: (MediaQuery.of(context).size.height)*2),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
          child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            
            children: [
              subTable(context, 0),
              
            ],
          ),
          TableRow(
            children: [
              subTable(context, 1),
              
            ]
          ),
          TableRow(
            children: [
              subTable(context, 2),
             
            ]
          ),
          TableRow(
            children: [
          
              subTable(context, 3),
             
            ]
          ),
          TableRow(

            children: [
              subTable(context, 4),
              
            ]
          ),
          TableRow(
            children: [
          
              subTable(context, 5),
              
            ]
          ),
          TableRow(
            children: [
              subTable(context, 6),
             
            ]
          ),
          TableRow(

            children: [
              subTable(context, 7),
              
            ]
          ),
          TableRow(
            children: [
              subTable(context, 8),
              
            ],
          ),
        ],
      )
      )
      ),
      Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: InkWell(
            splashColor: Colors.yellowAccent,
            child: Center(
              child: Text("Check the board?"),
            ),
            onTap: () async {
              resetBadTile();
              int firstUnAssigned = findFirstUnassignedLocation();
              if (firstUnAssigned < 81) {
                
                await showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "There are still unfinished tiles!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                }
                              );
              }
              else {
                bool stillGood = true;
                int i = 0;
                for (i = 0; i < 81; i++) {
                  if (!checkRow(i)) {
                    stillGood = false;
                    
                    break;
                  }
                  else if (!checkColumn(i)) {
                    stillGood = false;
                    
                    break;
                  }
                  else if (!checkSubTable(i)) {
                    stillGood = false;
                    
                    break;
                  }
                }
                stillGood ? 
                await showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "You're all done, congrats!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        
                                        onPressed: () {
                                          Navigator.popUntil(context, (route) => route.isFirst);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                }
                              )
                :
                await showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Found an error :/",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                }
                              );
                
              }
            },
          ),
        ),
      ),
      SizedBox(width: 10, height: 10),
      Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width,
        child: Material(
          child: InkWell(
            splashColor: Colors.yellowAccent,
            child: Center(
              child: Text("Solve the board?"),
            ),
            onTap: () async {
              
              setState(() {
                _solve = true;
              });
              
              solveBoard();
              
              
              setState(() {
                _solve = false;
              });
            },
          ),
        ),
      ),
      
          ]
        ),
      )
      )
    );
  }

 
}

bool solveBoard() {
  int startingSpot = findFirstUnassignedLocation();
  if (startingSpot == 81) return true; 
  
  for (int i = 1; i <= 9; i++) {
    
    
    //print(boxNum);
    controllers[startingSpot].text = "$i";
    if (checkRow(startingSpot) &&
        checkColumn(startingSpot) &&
        checkSubTable(startingSpot)) {
        


        if (solveBoard()) {
          return true;
        }

        
        
      
    }
     
    controllers[startingSpot].text = "";
    
    
  }
  //controllers[startingSpot].text = "";
  return false;  

}

int findFirstUnassignedLocation() {
  for (int i = 0; i < 81; i++) {
    if (controllers[i].text == "" && !readOnly[i]) return i;
    
  }

  return 81; //out of bounds if everything is filled
}

//when the board is full we find the first
//location to overwrite


void resetBadTile() {
  for (int i = 0; i < 81; i++) {
    badTile[i] = false;
  }
}

//check if row is valid under current conditions
bool checkRow(int index) {

  resetRowMap();
  int rowNumber = (index ~/ 9);
  int lim = rowNumber *9;
  for (int i = lim; i < lim + 9; i++) {
    if (controllers[i].text != "") {
      if (rowMap[controllers[i].text] == 1) {
        rowMap[(controllers[i].text)]++;
        return false;
      }
      rowMap[(controllers[i].text)]++;
    }
    
  }
  return true;

}

bool checkColumn(int index) {

  resetColumnMap();
  int columnNumber = index % 9;
  //print(columnNumber);
  for (int i = columnNumber; i < 81; i += 9) {
    //print(i);
    if (controllers[i].text != "") {
      //print(columnMap[controllers[i]]);
      if (columnMap[controllers[i].text] == 1) {
        columnMap[controllers[i].text]++;
        return false;
      }
      columnMap[controllers[i].text]++;
      //print(columnMap[controllers[i]]);
    }
    
    
  }
  return true;

}

//row number = total index / 9 (automatically rounded down because int)
//col number = total index % 9
//box number = (row num / 3) * 3 + col num / 3

bool checkSubTable(int index) {
  
  int rowNumber = index ~/ 9;
  //print("rowNumber = $rowNumber");
  int colNumber = index % 9;
  //print("colNumber = $colNumber");

  int boxNum = (rowNumber ~/ 3) * 3 + (colNumber ~/ 3);
  resetSubTableMap();

  int startRow = (rowNumber ~/ 3) * 3;
  int startCol = (colNumber ~/ 3) * 3;
  

  for (int i = startRow; i < startRow + 3; i++) {
    for (int j = startCol; j < startCol + 3; j++) {
      
      if (subTableMap[controllers[i * 9 + j].text] == 1) {
        subTableMap[controllers[i * 9 + j].text]++;
        return false;
      }
      else if (subTableMap[controllers[i * 9 + j].text] != null)
        subTableMap[controllers[i * 9 + j].text]++;
    }
    
    
  }
  return true;
}

void resetSubTableMap() {
  subTableMap.clear();
  for (int i = 1; i <= 9; i++) {
    subTableMap['$i'] = 0;
  }
}

void resetColumnMap() {
  columnMap.clear();
  for (int i = 1; i <= 9; i++) {
    columnMap['$i'] = 0;
  }
}

void resetRowMap() {
  rowMap.clear();
  for (int i = 1; i <= 9; i++) {
    rowMap['$i'] = 0;
  }
}

Map<String, int> subTableMap = {
  '1': 0,
  '2': 0,
  '3': 0,
  '4': 0,
  '5': 0,
  '6': 0,
  '7': 0,
  '8': 0,
  '9': 0
};

Map<String, int> columnMap = {
  '1': 0,
  '2': 0,
  '3': 0,
  '4': 0,
  '5': 0,
  '6': 0,
  '7': 0,
  '8': 0,
  '9': 0
};

Map<String, int> rowMap = {
  '1': 0,
  '2': 0,
  '3': 0,
  '4': 0,
  '5': 0,
  '6': 0,
  '7': 0,
  '8': 0,
  '9': 0
};

