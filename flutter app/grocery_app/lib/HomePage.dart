import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery_app/HomePageSideBar.dart';
import 'package:grocery_app/Login_Page.dart';
import 'package:grocery_app/database/sql_helper.dart';
import 'package:grocery_app/create_new_meal.dart';
import 'package:grocery_app/main.dart';
import 'package:grocery_app/meal_model.dart';
import 'package:grocery_app/meal_page.dart';
import 'package:grocery_app/shopping_list.dart';

import 'package:grocery_app/select_meals_for_shopping.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class homePage2 extends StatefulWidget {
  final Function callback1;
  final List callback2;

  final Function refreshShoppingLists;
  final List getSavedShoppingLists;

  final Function refreshDeleteMealWaitingRoom;
  final List getDeleteMealWaitingRoom;

  final Function refreshShoppingListsWaitingRoom;
  final List getDeleteShoppingListWaitingRoom;
  
   const homePage2({super.key, 
    required this.callback1, 
    required this.callback2, 
    required this.getSavedShoppingLists, 
    required this.refreshShoppingLists, 
    required this.getDeleteMealWaitingRoom, 
    required this.refreshDeleteMealWaitingRoom, 
    required this.getDeleteShoppingListWaitingRoom, 
    required this.refreshShoppingListsWaitingRoom});

  @override
  State<homePage2> createState() => _meal_pageState();
}

class _meal_pageState extends State<homePage2> {

    
   

datatoAcessebleData(int index) async {
  list2 = [];
  List<Map> item =  await _getOneSavedShoppingList(widget.getSavedShoppingLists[index]["id"]);
  List bla2 = json.decode(item[0]["savedShoppingListsJson"]);
  
  

  list2.addAll(bla2.map((instance) {
  return shoppingIngredient(
  Ingridient_name: instance["Ingridient_name"], 
  Ingridient_mass: (instance["Ingridient_mass"]),
  Ingridient_mass_unit: instance["Ingridient_mass_unit"],
  crossedOff: false,
  );
  }).toList());

 

  spicesList = [];
  List bla3 = json.decode(item[0]["spicesOFShoppingListJson"]);

  spicesList.addAll(bla3.map((instance) {
    return spices(
      spices_title: instance["spices_title"]
      );
    }
  ).toList());
  

 
 
}

Future<List<Map<String, dynamic>>> _getOneSavedShoppingList(int id) async {
  final data = await SQLHelper.getOneSavedShoppingList(id);
  return data;

  }

  UpdateShoppingList(int id, String name, List<shoppingIngredient> ingredients, List<selectedMeal> originalMealListFromShoppingList, List<spices> spicesList) {

     var objectsOfIngredients = ingredients.map((instance) {
      return {
        "Ingridient_name": instance.Ingridient_name,
        "Ingridient_mass": instance.Ingridient_mass, 
        "Ingridient_mass_unit": instance.Ingridient_mass_unit,
        "coressedOff": instance.crossedOff
        

      };
    }).toList();

    var list3 = originalMealListFromShoppingList.map((e) {
      return {
        "meal_id": e.meal_id,
        "meal_size": e.meal_size,
        "meal_title": e.meal_title
      }
;
    }).toList();

    var objectsOfSpices = spicesList.map((e) {
      return {
        "spices_title": e.spices_title
      };
    }).toList();

  // Objects of Ingredients to String 
  String stringList = json.encode(objectsOfIngredients);
  String strMealList = json.encode(list3);
  String strSpices = json.encode(objectsOfSpices);
  print(strMealList);

  _updateShoppingList(id, name, stringList, strMealList, strSpices);
  
    
  

  }

  
  
  _addSavedShoppingListtoLists(name, List<shoppingIngredient> ingredients, List<selectedMeal> originalMealListFromShoppingList, List<spices> spicesList) {

    var objectsOfIngredients = ingredients.map((instance) {
      return {
        "Ingridient_name": instance.Ingridient_name,
        "Ingridient_mass": instance.Ingridient_mass, 
        "Ingridient_mass_unit": instance.Ingridient_mass_unit,
        "coressedOff": instance.crossedOff
        

      };
    }).toList();

    var list3 = originalMealListFromShoppingList.map((e) {
      return {
        "meal_id": e.meal_id,
        "meal_size": e.meal_size,
        "meal_title": e.meal_title
      };
    }).toList();

     var objectsOfSpices = spicesList.map((e) {
      return {
        "spices_title": e.spices_title
      };
    }).toList();

  // Objects of Ingredients to String 
  String stringList = json.encode(objectsOfIngredients);
  String strMealList = json.encode(list3);
  String strSpices = json.encode(objectsOfSpices);
  

  addSavedShoppingListtoLists(name, stringList, strMealList, strSpices); 



  }
  addSavedShoppingListtoLists(String name, String savedShoppingListsJson, String originalMealListFromShoppingListJson, String spicesOFShoppingListJson) async {
    await SQLHelper.createSavesShppongList(name, savedShoppingListsJson, originalMealListFromShoppingListJson, spicesOFShoppingListJson);
    widget.refreshShoppingLists();
  } 

  _deleteShoppingList(int id ) async {
    await SQLHelper.deleteSavedShoppingList(id);

    widget.refreshShoppingLists();
    widget.refreshShoppingListsWaitingRoom();
  }
   
  PlaceholderFunction() {

  }
  

  Future<void> _updateShoppingList(int id, String name, String savedShoppingListsJson, String originalMealListFromShoppingListJson, String spicesOFShoppingListJson ) async {
    await SQLHelper.updateSavedShoppingList(id, name, savedShoppingListsJson, originalMealListFromShoppingListJson, spicesOFShoppingListJson);
    widget.refreshShoppingLists();
  }


  Future<void> _updateMeal(int id, String title_name, String ingridientsJson, String spicesJson) async {
    await SQLHelper.updateMeal(id, title_name, ingridientsJson, spicesJson);
    widget.callback1();
  }

  
  

  // delete item from database 
  void _deleteMeal(int id) async {
    await SQLHelper.deleteMeal(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("succesfully deleted")));
    widget.callback1();
    widget.refreshDeleteMealWaitingRoom();
  }
     
  
   
  
  // add meal to sql database 
  Future<void> _addMeal(String meal_title, String ingridientsJson, String spicesJson) async {
     
      
      await SQLHelper.createMeal(meal_title, ingridientsJson, spicesJson);
      widget.callback1();
  }

   _getAllMeals() async {
    final data = await SQLHelper.getAllMeals();
    print(data);
    return data;
    }

    _savedShoppingLists() async {
      final data = await SQLHelper.getAllsavedShoppingLists();
      return data;
    }

  Future<List<Map<String, dynamic>>> _getOneMeal(int id) async {
    final data = await SQLHelper.getOneMeal(id);
    print(data);
    return data;
  }

  
    
  

  
  Future<List<Map<String, dynamic>>> _future_list() {
    return Future.value([]);
  }

   double checkContaierHeight() {
    containerHeight = widget.getSavedShoppingLists.length * (MediaQuery.of(context).size.height / 16.2);
    if (containerHeight > 5 * (MediaQuery.of(context).size.height / 16.2)) {
      containerHeight = 5 * (MediaQuery.of(context).size.height / 16.2);
    }
    return containerHeight;
  }
  

  syncAllMeals() async {
    bool isConnected = false;

    try {
      await supabase.from("meals").select().eq("user_id", supabase.auth.currentUser!.id); 
      isConnected = true;
      } catch (err) {
      isConnected  = false;

    }

    if (isConnected) {

    // ignore: non_constant_identifier_names
    final response_meal = await supabase.from("meals").select().eq("user_id", supabase.auth.currentUser!.id);
    // ignore: non_constant_identifier_names
    final response_shoppingLists = await supabase.from("shoppingsLists").select().eq("user_id", supabase.auth.currentUser!.id);
    //meals 
    var local_meals = widget.callback2;
    //savedShoppingLists
    // ignore: non_constant_identifier_names
    var local_ShoppingLists = widget.getSavedShoppingLists;

    

    final deleteMeals = widget.getDeleteMealWaitingRoom;
    final deleteShoppingList = widget.getDeleteShoppingListWaitingRoom;
    // temporary delete meal local list -> delete in cloud 
    //meals 
    for (final meal in deleteMeals) {
      int id = meal["meal_id"];
      final values = {
        "user_id": supabase.auth.currentUser!.id,
        "local_id": id
      };
      await supabase.from("meals").delete().match(values);
    }

    // shoppingLists
    for (final shoppingList in deleteShoppingList) {
      int id = shoppingList["list_id"];
      final values = {
        "user_id": supabase.auth.currentUser!.id,
        "local_id": id
      };
      await supabase.from("shoppingsLists").delete().match(values);
    }


   

    
    // Sync Meals 
    // update or insert in Database
    for (var localMeal in local_meals) {
      // ignore: non_constant_identifier_names
      int local__meal_id = localMeal["id"];
      int b = 1;
       if (response_meal.isEmpty) { insertMealToCloud(local__meal_id);}
       for (var meal in response_meal) {
         
       if (local__meal_id == meal["local_id"]) {
        // update Row in cloud
        updateMealtoCloud(local__meal_id);
        
       } else if (b == response_meal.length) {
        // insert meal in cloud 
        insertMealToCloud(local__meal_id); 
       } 
       b = b+1;
    }
    
  }
  
  // if meals emmpty -> get all meals from the cloud 
  if (local_meals.isEmpty) { 
        late int integer;
        final meals = await supabase.from("meals").select().eq("user_id", supabase.auth.currentUser!.id);
        for (var b in meals) {
          int cloudId = b["local_id"];
          await _addMeal(b["name"], json.encode(b["ingredientsJson"]), json.encode(b["spicesJson"]));
          final allMeals = await _getAllMeals(); 
          integer =  allMeals.last["id"];
          
          final values = {
            "local_id": integer
          };
          await supabase.from("meals").update(values).match({"user_id": supabase.auth.currentUser!.id, "local_id": cloudId });

        }
      } 

      
    
  if (local_ShoppingLists.isEmpty) {
    final cloudLists = await supabase.from("shoppingsLists").select().eq("user_id", supabase.auth.currentUser!.id);
        for (var b in cloudLists) {
          int cloudId = b["local_id"];
          await addSavedShoppingListtoLists(b["name"], json.encode(b["ingredientsShoppingList"]) , json.encode(b["originalMealListsJson"]) , json.encode(b["spicesOfShoppingListJson"]));
          final allShoppingLists = await _savedShoppingLists(); 
          int integer =  allShoppingLists.last["id"];
          
          final values = {
            "local_id": integer
          };
          await supabase.from("shoppingsLists").update(values).match({"user_id": supabase.auth.currentUser!.id, "local_id": cloudId});
        }
  }
     



    // Sync ShoppingLists 
    
    for (var localShoppingList in local_ShoppingLists) {
      // ignore: non_constant_identifier_names
      int local_shoppingList_id = localShoppingList["id"];
      int c = 1; 
      if (response_shoppingLists.isEmpty) { insertShoppingListToCloud(local_shoppingList_id);}
      for (var shoppingListCloud in response_shoppingLists) {
        
        // check for already existings rows
        if (local_shoppingList_id == shoppingListCloud["local_id"]) {
          updateShoppingListInCloud(local_shoppingList_id);
          break;
        }
        // insert a new shopping List
        else if(c == response_shoppingLists.length) {
          insertShoppingListToCloud(local_shoppingList_id);
        }

        c = c +1;
      }
    }


      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sync")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Keine Verbindung")));
    }
    
   

  


   
  }
  

  insertMealToCloud(int id) async {
    final meal = _getOneMeal(id);
    List<Map> list = await meal;
    final values = {
      "name": list[0]["title"],
      "ingredientsJson": toJson(list[0]["ingridientsJson"]),
      "spicesJson": toJson(list[0]["spicesJson"]),
      "local_id": id
    };
    await supabase.from("meals").insert(values);
    print("inserted");
  }

  updateMealtoCloud(int id) async {
    final meal = _getOneMeal(id);
    List<Map> list = await meal;
    final values = {
      "name": list[0]["title"],
      "ingredientsJson": toJson(list[0]["ingridientsJson"]),
      "spicesJson": toJson(list[0]["spicesJson"])
    };
    await supabase.from("meals").update(values).eq("local_id", id);
    print("updated meals");
  }

  insertShoppingListToCloud(int id) async {
    final shoppingList = _getOneSavedShoppingList(id);
    List<Map> list = await shoppingList;
    final values = {
      "name": list[0]["name"],
      "ingredientsShoppingList": toJson(list[0]["savedShoppingListsJson"]),
      "originalMealListsJson": toJson(list[0]["originalMealListFromShoppingListJson"]),
      "spicesOfShoppingListJson": toJson( list[0]["spicesOFShoppingListJson"]),
      "local_id": id
    };
    await supabase.from("shoppingsLists").insert(values);
  }

  updateShoppingListInCloud(int id) async {
    final shoppingList = _getOneSavedShoppingList(id);
    List<Map> list = await shoppingList;
    final values = {
      "name": list[0]["name"],
      "ingredientsShoppingList": toJson(list[0]["savedShoppingListsJson"]),
      "originalMealListsJson": toJson(list[0]["originalMealListFromShoppingListJson"]),
      "spicesOfShoppingListJson": toJson(list[0]["spicesOFShoppingListJson"])
    };
    await supabase.from("shoppingsLists").update(values).eq("local_id", id);
  }

  


   List<shoppingIngredient> list2 = [];
   List<spices> spicesList = [];
   // ignore: non_constant_identifier_names
   int selected_Index_Nav = 0; 
   // ignore: non_constant_identifier_names
   bool HomePage = true;
   // ignore: prefer_typing_uninitialized_variables
   var data;
   // ignore: non_constant_identifier_names
   late bool gespeicherte_liste = false;
   bool first = true;
   

  
  final PageController _pageController2 = PageController();


   //Future<List<Map<String, dynamic>>> await placeholder =  [{}]; 
  int myIndex =  0; 

  // shopping list variables: 
  double containerHeight = 0; 
  List<bool> selected = [];
  late bool isAlreadyLoggedIn; 

  @override
  Widget build(BuildContext context) {

    if (selected_Index_Nav == 1) {containerHeight = checkContaierHeight();}
    
    return Scaffold(
      drawer: const SideBar(),
      appBar:AppBar(
      backgroundColor: HexColor("#31473A"),
      title: Text("Mahlzeit", style: TextStyle(color: Colors.white)),
      centerTitle: true,
      
      leading: Builder( builder: (context) => IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.menu, color: HexColor("#EDF4F2"),),
      ),
      ),
      actions: <Widget> [
        IconButton(
          icon: Icon(Icons.sync, color: HexColor("#EDF4F2")), 
          onPressed: () async {
            
            await Future.delayed(Duration.zero);
            final session = supabase.auth.currentSession;
            print(session);
            if (!mounted) return;
            
            if (session != null) {    
              syncAllMeals(); 
            } else {
              print("keine session");
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(SignedIn: session == null ? false: true, sideBar: false, )));
            }
          },
          ), 
        
      ],
    ),
    bottomNavigationBar:Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        
      ),
      child: BottomNavigationBar(
       landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        onTap: (index) {

          setState(() {
            _pageController2.animateToPage(index, duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
            
          });
           
        
         
          
        },
      
        currentIndex: selected_Index_Nav,
        enableFeedback: false,
      
        backgroundColor: HexColor("#3c634c"),
        showSelectedLabels: false ,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.black,
        selectedItemColor: HexColor("#EDF4F2"),
        type: BottomNavigationBarType.fixed,
        
      
      
        items: [
          BottomNavigationBarItem( 
            label: "1",
            backgroundColor: HexColor("#31473A"),
            icon: Container(
              height: 35,
              width: 70,
            
              decoration: BoxDecoration(
                color: HexColor("#3c634c"), 
                border:  selected_Index_Nav == 0 ? Border.all(width: 1.5) : null,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(Icons.home, size: 35,),

            )
          ),
          BottomNavigationBarItem( 
            label: "----",
          
            icon: Container(
              height: 35,
              width: 70,
              decoration: BoxDecoration(
                color: HexColor("#3c634c"),
                border: selected_Index_Nav == 1 ? Border.all(width: 1.5) : null,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Center(child: Icon(Icons.shopping_basket, size: 35,)),

            )
          )
         
        ],
         )
    ),
      
      backgroundColor: HexColor("31473A"),

      body: PageView(
        pageSnapping: true,
        controller: _pageController2,
        onPageChanged: (value) {
          setState(() {
            selected_Index_Nav = value;
          });
          
        },
      //selected_Index_Nav == 0 ?Column(
        children: [
          // Seite 1 
          Column(
            children: [ 
                Expanded(
                flex: 5,
                child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: widget.callback2.length,
                itemBuilder: (context, index) => Padding(   
                  padding: EdgeInsets.all(10),
                  child: Container( 
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 13,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                      color: HexColor("#d6e2de"),
                     ),                       
                    child: Center(
                      child: ListTile(
                        onTap:() {
                          data =_getOneMeal(widget.callback2[index]["id"]);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => meal_page(db_ingridents_List: data,)));
                        },
                      titleAlignment: ListTileTitleAlignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                      title: Text(widget.callback2[index]["title"], style: TextStyle(color: Colors.black,),),
                      trailing: SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.black,),
                              onPressed: () {
                            
                              data =_getOneMeal(widget.callback2[index]["id"]);
                               
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => create_new_meal(callback: _addMeal, callback2: _updateMeal, ItemValues: data, update: true,  )));
                               
                            },    
                           ),  
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black),
                              onPressed: () => _deleteMeal(widget.callback2[index]["id"])
                         )
                        ],
                      ),
                    ),
                     ),
                  ),
                  )
                ) 
              )
            ),
             
               Padding(
                 padding: const EdgeInsets.only(bottom: 15.0),
                 child: FloatingActionButton(
                  
                  onPressed:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => create_new_meal(callback: _addMeal, callback2: _updateMeal, ItemValues: _future_list(), update: false,  )));
                  }, 
                  autofocus: true,
                  heroTag: "btn3",
                  backgroundColor: HexColor("#d6e2de"),
                  highlightElevation: 10,
                  shape: RoundedRectangleBorder(
                   side: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(16)
                   ),
                   child: const Icon(Icons.add, color: Colors.black,),
                 
                  ),
               )
              ],
            ),
             


            // Seite 2 Shopoing List Page:  
            Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left:13.0),
                      child: Text("Gespeicherte Einkaufslisten", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    )),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: containerHeight,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.getSavedShoppingLists.length,
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(),
                            color: HexColor("#d6e2de")
                          ),
                          child: Center(
                            child: ListTile(
                              onTap: () {  
                                datatoAcessebleData(index);
                                Navigator.push(context, MaterialPageRoute(builder: ((context) => shoppingcard(oldSpicesList: spicesList, new_: false, selectesMealList: [], oldShoppingList: list2, getItem: PlaceholderFunction, saveShoppingListToSavedLists: _addSavedShoppingListtoLists,))));
                              },
                              //shape: Border.all(),
                              visualDensity: VisualDensity(vertical: -1),
                              //tileColor: Colors.amber,
                              title: Text(widget.getSavedShoppingLists[index]["name"], style: TextStyle(color: Colors.black,),),
                              trailing: SizedBox(
                    
                                width: MediaQuery.of(context).size.width / 4,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.black,),
                                      onPressed: () {
                                        data =_getOneSavedShoppingList(widget.getSavedShoppingLists[index]["id"]);
                                        
                                        Navigator.push(
                                context,
                                    MaterialPageRoute(builder: (context) => select_meals_for_shopping(update2: true, savedShoppingList: _addSavedShoppingListtoLists , ShoppingListData: data, getItem: _getOneMeal ,callback: widget.callback2, spontaneous: false , update: true, updateShoppingList: UpdateShoppingList,   )));
                               
                              
                                        
                               
                                      },    
                                     ),  
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.black),
                                      onPressed: () {
                                      _deleteShoppingList(widget.getSavedShoppingLists[index]["id"]);
                                      checkContaierHeight();
                                      }
                                    )
                                  ],
                                ),
                              ), 
                            ),
                          ),
                        )),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40,),
                  FloatingActionButton(
                    backgroundColor: HexColor("#d6e2de"),
                    onPressed:() {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => select_meals_for_shopping(update2: false, ShoppingListData: _future_list()  ,updateShoppingList: UpdateShoppingList, update: false, callback: widget.callback2, spontaneous: false, getItem: _getOneMeal , savedShoppingList: _addSavedShoppingListtoLists)));
                    },
                    child:Icon(Icons.add)
                    ),
                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => select_meals_for_shopping(update2: false, ShoppingListData: _future_list(), updateShoppingList: UpdateShoppingList, update: false, callback: widget.callback2, spontaneous: true, getItem: _getOneMeal, savedShoppingList: _addSavedShoppingListtoLists))));
                      
                    },
                    child: Align(
                      alignment: Alignment.center,
                      
                      child: Padding(padding: EdgeInsets.all(12),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: HexColor("#d6e2de"),
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)
                            ),
                          child: Icon(Icons.shopping_basket, size: 50,)
                        ),
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text("Einkauf Starten!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ) 
                ],
            ),
           ]
         )
  );
 }
}

