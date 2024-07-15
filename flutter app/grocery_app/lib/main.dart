


// ignore_for_file: unused_field

import "package:flutter/material.dart";
import "package:grocery_app/database/sql_helper.dart";
import "package:grocery_app/HomePage.dart";
import 'package:supabase_flutter/supabase_flutter.dart';







void main() async {
  await Supabase.initialize(
    url: "https://ejdvmkusfhrksgpucedy.supabase.co", 
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqZHZta3VzZmhya3NncHVjZWR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA4MjY4MzAsImV4cCI6MjAzNjQwMjgzMH0.jSvT4GEurjNI5nhJ-Ay8M6hvoibhJDvwWtcGtgfDD0M", 
    
  
 );
  runApp(const MyApp());
}
final supabase = Supabase.instance.client;
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
  List<Map<String, dynamic>> _deleteMealWaitingRoom = [];
  List<Map<String, dynamic>> _deleteShoppingListWaitingRoom = [];
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

  void _refreshDeleteMealWaitingRoom() async {
    final data = await SQLHelper.getAllDeleteMealWaitingRoom();
    _deleteMealWaitingRoom = data;
    _isLoading = false;
  }

  void _refreshDeleteShoppingListWaitingRoom() async {
    final data = await SQLHelper.getAllDeleteShoppingListsWaitingRoom();
    _deleteShoppingListWaitingRoom = data;
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _refreshMeals();
    _refreshSavedShoppingLists();
    print("number of items: ${_meals.length}");
  }

  Widget build(BuildContext context) {
    
    return homePage2(
      callback1: _refreshMeals, 
      callback2: _meals, 
      getSavedShoppingLists: _savedShoppingLists,
      refreshShoppingLists: _refreshSavedShoppingLists,
      getDeleteMealWaitingRoom: _deleteMealWaitingRoom ,
      refreshDeleteMealWaitingRoom: _refreshDeleteMealWaitingRoom,
      getDeleteShoppingListWaitingRoom: _deleteShoppingListWaitingRoom,
      refreshShoppingListsWaitingRoom: _refreshDeleteShoppingListWaitingRoom,
      );
  }
 }

