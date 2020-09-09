import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver/game.dart';
import 'boardui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      
      runApp(MyApp());
    });
  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        
        primarySwatch: Colors.indigo,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameInitialize(),
    );
  }
}
