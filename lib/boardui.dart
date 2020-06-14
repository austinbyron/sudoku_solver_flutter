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
    //TextEditingController number = new TextEditingController();
    //FocusScope.of(context).requestFocus(FocusNode());
    //bool _editing = false;
    return Container(
      color: badTile[index] ? Colors.blueAccent : Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(4.0, 8.0, 0.0, 8.0),
        
        child: GestureDetector(
          onTap: () {
            //FocusScope.of(context).unfocus();
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
                  //nodes[index].requestFocus();
                  
                },

                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  //nodes[index].unfocus();
                },
                readOnly: readOnly[index],
                //maxLength: 1,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(1),
                  BlacklistingTextInputFormatter('0'),
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
              Text("${index}")
              ]
            ),
            
          ),
      ),
       
    );
  }

  

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

    return Scaffold(
      appBar: AppBar(title: Text("Sudoku Solver")),
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
            //decoration: Decoration.,
            children: [
              subTable(context, 0),
              //Text("0"),
            ],
          ),
          TableRow(
            children: [
              subTable(context, 1),
              //Text("1"),
            ]
          ),
          TableRow(
            children: [
              subTable(context, 2),
              //Text("2"),
            ]
          ),
          TableRow(
            children: [
          
              subTable(context, 3),
              //Text("3"),
            ]
          ),
          TableRow(

            children: [
              subTable(context, 4),
              //Text("4"),
            ]
          ),
          TableRow(
            children: [
          
              subTable(context, 5),
              //Text("5"), 
            ]
          ),
          TableRow(
            children: [
              subTable(context, 6),
              //Text("6"),
            ]
          ),
          TableRow(

            children: [
              subTable(context, 7),
              //Text("7"),
            ]
          ),
          TableRow(
            children: [
              subTable(context, 8),
              //Text("8"),
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
            splashColor: Colors.lightBlue,
            child: Center(
              child: Text("Check the board?"),
            ),
            onTap: () {
              resetBadTile();
              int firstUnAssigned = findFirstUnassignedLocation();
              if (firstUnAssigned < 81) {
                print(firstUnAssigned);
                print(checkRow(firstUnAssigned));
                print(checkColumn(firstUnAssigned));
                print(checkSubTable(firstUnAssigned));
              }
              else print("done!");
            },
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [Flexible(fit: FlexFit.loose, child: Text("Check the board?")),
          Spacer(),
          IconButton(
            icon: _check ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                _check = !_check;
              });
              
              resetBadTile();
              for (int i = 0; i < 9; i++) {
                if (checkRow(i) != true) {
                  //badTile[checkRow(i)] = true;
                }
                
                print(checkRow(i));
                print(checkColumn(i));
                print(checkSubTable(i));
              }
            },
          ),
          ]
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: _solve ? CircularProgressIndicator() : Row(
          children: [Flexible(fit: FlexFit.loose, child: Text("Solve the board?")),
          Spacer(),
          IconButton(
            icon: _solve ? Icon(Icons.check) : Icon(Icons.check_box_outline_blank),
            onPressed: () {
              setState(() {
                _solve = true;
              });
              
              bool tests = solveBoard();
              print(tests);
              
              setState(() {
                _solve = false;
              });
              
              
            },
          ),
          ]
        ),
      )
          ]
        ),
      )
      )
    );
  }

 
}

bool solveBoard() {
  int startingSpot = findFirstUnassignedLocation();
  if (startingSpot == 81) return true; //startingSpot = findFirstWritableAssigned();
  //print(startingSpot);
  int rowNum, colNum, boxNum;
  for (int i = 1; i <= 9; i++) {
    
    
    //print(boxNum);
    controllers[startingSpot].text = "$i";
    if (checkRow(startingSpot) &&
        checkColumn(startingSpot) &&
        checkSubTable(startingSpot)) {
        
        //print(checkRow(rowNum));
        //print(checkColumn(colNum));
        //print(checkSubTable(boxNum));
        //print(checkRow(rowNum) && checkColumn(colNum) && checkSubTable(boxNum));

        return solveBoard();

        
        
      
    }
     
    controllers[startingSpot].text = "";
    /*
    if (!isAlreadyInRow(startingSpot, i) && 
        !isAlreadyInCol(startingSpot, i) &&
        !isAlreadyInBox(startingSpot, i)) {
      solveBoard();
    }*/
    
  }
  //controllers[startingSpot].text = "";
  return false;  

}

int findFirstUnassignedLocation() {
  for (int i = 0; i < 81; i++) {
    if (controllers[i].text == "" && !readOnly[i]) return i;
    /*for (int j = 0; j < 9; j++) {
      if (controllers[(i*9) + j].text == "" && !readOnly[(i*9) + j]) {
        return (i*9) + j;
      }
    }*/
  }

  return 81; //out of bounds if everything is filled
}

//when the board is full we find the first
//location to overwrite
int findFirstWritableAssigned() {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (!readOnly[rowInd[i][j]]) return rowInd[i][j];
    }
  }

  //shouldn't get here but return 81 out of bounds just in case
  return 81;
}

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
      if (rowMap[controllers[i].text] == 1) return false;
      rowMap[(controllers[i].text)]++;
    }
    
  }
  return true;
  //rowMap.forEach((key, value) {
    //print("$key -> $value");
    //if (value != null && value > 1) return false;
  //});

/*
  for (int i = lim; i < lim + 9; i++) {
    if (rowMap[controllers[i].text]== null) {
      //do nothing
    }
    else if (rowMap[controllers[i].text] > 1) {
      //print(rowInd[rowNumber][i]);
      //rowMap.forEach((key, value) {
        //print("$key -> $value");
      //});
      return false;
    }
    //print(controllers[rowInd[rowNumber][i]].text);
  }

  return true;
*/
}

bool checkColumn(int index) {

  resetColumnMap();
  int columnNumber = index % 9;
  //print(columnNumber);
  for (int i = columnNumber; i < 81; i += 9) {
    //print(i);
    if (controllers[i].text != "") {
      //print(columnMap[controllers[i]]);
      if (columnMap[controllers[i].text] == 1) return false;
      columnMap[controllers[i].text]++;
      //print(columnMap[controllers[i]]);
    }
    
    
  }
  return true;
/*
  columnMap.forEach((key, value) {
    print(key);
    print(value);
    if (value > 1) return false;
  });
  return true;
  */
/*
  for (int i = columnNumber; i < 81; i+= 9) {
    if (columnMap[controllers[i].text] == null) {
      //do nothing
    }
    else if (columnMap[controllers[i].text] > 1) return false;
    //print(controllers[colInd[columnNumber][i]].text);
  }
  return true;
  */
}

//row number = total index / 9 (automatically rounded down because int)
//col number = total index % 9
//box number = (row num / 3) * 3 + col num / 3

bool checkSubTable(int index) {
  //int start = subTableNumber * 9;
  //print("Index = $index");
  
  int rowNumber = index ~/ 9;
  //print("rowNumber = $rowNumber");
  int colNumber = index % 9;
  //print("colNumber = $colNumber");

  int boxNum = (rowNumber ~/ 3) * 3 + (colNumber ~/ 3);
  resetSubTableMap();

  int startRow = (rowNumber ~/ 3) * 3;
  int startCol = (colNumber ~/ 3) * 3;
  //print("boxNum = $boxNum");
  //print("startRow = $startRow");
  //print("startCol = $startCol");

  for (int i = startRow; i < startRow + 3; i++) {
    for (int j = startCol; j < startCol + 3; j++) {
      //print(i*9 + j);
      if (subTableMap[controllers[i * 9 + j].text] == 1) {
        return false;
      }
      else if (subTableMap[controllers[i * 9 + j].text] != null)
      subTableMap[controllers[i * 9 + j].text]++;
    }
    
    
  }
/*
  for (int i = 1; i <= 9; i++) {
    print(subTableMap["$i"]);
    if (subTableMap["$i"] == null) {
      //do nothing
    }
    else if (subTableMap["$i"] > 1) return false;
    
  }
*/
  //should be able to iterate through all values in the subtable map
/*
  for (int i = startRow; i < startRow + 3; i++) {
    for (int j = startCol; j < startCol + 3; j++) {
      if (subTableMap[controllers[i*9 + j].text] == null) {
      //do nothing
    }
      else if (subTableMap[controllers[i * 9 + j].text] > 1) return false;
    }
    
  }
  */
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

List<List<int>> rowInd = [
  [0,1,2,9,10,11,18,19,20],
  [3,4,5,12,13,14,21,22,23],
  [6,7,8,15,16,17,24,25,26],
  [27,28,29,36,37,38,45,46,47],
  [30,31,32,39,40,41,48,49,50],
  [33,34,35,42,43,44,51,52,53],
  [54,55,56,63,64,65,72,73,74],
  [57,58,59,66,67,68,75,76,77],
  [60,61,62,69,70,71,78,79,80]
];

List<List<int>> colInd = [
  [0,3,6,27,30,33,54,57,60],
  [1,4,7,28,31,34,55,58,61],
  [2,5,8,29,32,35,56,59,62],
  [9,12,15,36,39,42,63,66,69],
  [10,13,16,37,40,43,64,67,70],
  [11,14,17,38,41,44,65,68,71],
  [18,21,24,45,48,51,72,75,78],
  [19,22,25,46,49,52,73,76,79],
  [20,23,26,47,50,53,74,77,80]
];