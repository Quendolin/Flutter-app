


import "package:flutter/material.dart";
import "package:grocery_app/database/sql_helper.dart";
import "package:grocery_app/HomePage.dart";
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_core/firebase_core.dart';






void main() {
  
  


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     


    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
  
      title: 'Flutter Demo',
      
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map<String, dynamic>> _meals = [];
  List<Map<String, dynamic>> _savedShoppingLists = [];
  bool _isLoading = true; 

  void _refreshSavedShoppingLists() async {
    final data = await SQLHelper.getAllsavedShoppingLists();
    setState(() {
      _savedShoppingLists = data;
      _isLoading = false;
    });
    
  }

  void _refreshMeals() async {
    final data = await SQLHelper.getAllMeals();
    setState(() {
      _meals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshMeals();
    _refreshSavedShoppingLists();
    print("number of items: ${_meals.length}");
  }

  Widget build(BuildContext context) {
    
    return homePage2(callback1: _refreshMeals, callback2: _meals, getSavedShoppingLists: _savedShoppingLists, refreshShoppingLists: _refreshSavedShoppingLists,);
  }
 }

