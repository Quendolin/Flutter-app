import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  
   const homePage2({super.key, required this.callback1, required this.callback2, required this.getSavedShoppingLists, required this.refreshShoppingLists});

  @override
  State<homePage2> createState() => _meal_pageState();
}

class _meal_pageState extends State<homePage2> {

    
   

datatoAcessebleData(int index) async {
  list2 = [];
  List<Map> item =  await _getOneSavedShoppingList(widget.getSavedShoppingLists[index]["id"]);
  List bla2 = json.decode(item[0]["savedShoppingListsJson"]);
  
  setState(() {
  list2.addAll(bla2.map((instance) {
  return shoppingIngredient(
  Ingridient_name: instance["Ingridient_name"], 
  Ingridient_mass: (instance["Ingridient_mass"]),
  Ingridient_mass_unit: instance["Ingridient_mass_unit"],
  crossedOff: false,
  );
  }).toList());

  });
  
  huan = true;
 
 
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
  

  addSavedShoppingListtoLists(name, stringList, strMealList, strSpices); 



  }
  addSavedShoppingListtoLists(String name, String savedShoppingListsJson, String originalMealListFromShoppingListJson, String spicesOFShoppingListJson) async {
    await SQLHelper.createSavesShppongList(name, savedShoppingListsJson, originalMealListFromShoppingListJson, spicesOFShoppingListJson);
    widget.refreshShoppingLists();
  } 

  _deleteShoppingList(int id ) async {
    await SQLHelper.deleteSavedShoppingList(id);
    widget.refreshShoppingLists();
  }
   
  PlaceholderFunction() {

  }
  

  Future<void> _updateShoppingList(int id, String name, String savedShoppingListsJson, String originalMealListFromShoppingListJson, String spicesOFShoppingListJson ) async {
    await SQLHelper.updateSavedShoppingList(id, name, savedShoppingListsJson, originalMealListFromShoppingListJson, spicesOFShoppingListJson);
    widget.refreshShoppingLists();
  }


  Future<void> _updateMeal(int id, String title_name, String description, ingridientsJson, String spicesJson) async {
    await SQLHelper.updateMeal(id, title_name, description, ingridientsJson, spicesJson);
    widget.callback1();
  }

  
  

  // delete item from database 
  void _deleteMeal(int id) async {
    await SQLHelper.deleteMeal(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("succesfully deleted")));
    widget.callback1();
  }
     
  
   
  
  // add meal to sql database 
  Future<void> _addMeal(String meal_title, String meal_description, String ingridientsJson, String spicesJson) async {
     
      
      await SQLHelper.createMeal(meal_title, meal_description, ingridientsJson, spicesJson);
      widget.callback1();
      
      
      print("modell wurde erstellt");
      
      displayed_meal_list = List.from(main_meal_list); 

  }

  Future<void> _getAllMeals() async {
    final data = await SQLHelper.getAllMeals();
    print(data);
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
  

  syncAllMeals(final user, final id) async {
    
      for (var meal in widget.callback2) {
        String name = meal["title"];
        int meal_id = int.parse(meal["id"]);
        final ingridientsJson = toJson(meal["ingridientsJson"]);
        final spicesJson = toJson(meal["spicesJson"]); 
        await supabase.from("meals").insert({
          "name": name, 
          "ingredientsJson": ingridientsJson, 
          "spicesJson": spicesJson,
          "local_id": meal_id
          });
      }

    }

  syncAllShoppingLists(final user, final id) async {
    for (var shoppingList in widget.getSavedShoppingLists) {
      String name = shoppingList["name"];
      final shoppingListIngredient = toJson(shoppingList["savedShoppingListsJson"]);
      final originalMealListFromShoppingListJson = toJson(shoppingList["originalMealListFromShoppingListJson"]);
      final spicesOfShoppingListJson = toJson(shoppingList["spicesOFShoppingListJson"]);
      await supabase.from("shoppingsLists").insert({
        
        "name": name, 
        "ingredientsShoppingList": shoppingListIngredient, 
        "originalMealListsJson": originalMealListFromShoppingListJson,
        "spicesOfShoppingListJson": spicesOfShoppingListJson
        });
    }

  }


  
  List<MealModel> displayed_meal_list = List.from(main_meal_list);

   List<shoppingIngredient> list2 = [];
   int selected_Index_Nav = 0; 
   bool HomePage = true;
   var data;
   late bool gespeicherte_liste = false;
   bool first = true;
   

  bool huan = false; 
  final PageController _pageController2 = PageController();


   //Future<List<Map<String, dynamic>>> await placeholder =  [{}]; 
  int myIndex =  0; 

  // shopping list variables: 
  List saved_shoppings_lists = ["asda", "sdadad","sdadada"];
  double containerHeight = 0; 
  List<bool> selected = [];
  late bool isAlreadyLoggedIn; 

  @override
  Widget build(BuildContext context) {

    

     
    if (selected_Index_Nav == 1) {containerHeight = checkContaierHeight();}
    
    return Scaffold(
      drawer: SideBar(),
      appBar:AppBar(
      backgroundColor: HexColor("#31473A"),
      title: Text("Mahlzeiten", style: TextStyle(color: HexColor("#EDF4F2"))),
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
              print("already registered");
              
              final json = toJson("sdsdadasdad");
              final user = Supabase.instance.client.auth.currentUser;
              final id = user!.id;
              syncAllMeals(user, id); 
              //await supabase.from("meals").insert({"user_id":  id,  "name": "meal1", "ingredientsJson":json, "spicesJson": json});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("sync")));
              // sync!
            } else {
              print("keine session");
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(SignedIn: session == null ? false: true )));
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
        selectedItemColor: Colors.white,
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
                  backgroundColor: Colors.white,
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
                      
                      showModalBottomSheet(
                        context: context, 
                        builder: (BuildContext context) {
                          
                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                              color: HexColor("#d6e2de"),
                              ),
                              height: MediaQuery.of(context).size.height / 2.5,
                              child: Center(
                               
                                child: Row(
                                  children: [
                                    
                                     Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                      
                                        onTap: () {  
                                          //Navigator.push(context, MaterialPageRoute(builder: ((context) => selecting_shoppingcard())));
                                          showModalBottomSheet(
                                            barrierColor: Colors.transparent,
                                            context: context, 
                                            builder: (BuildContext context) {
                                            
                                              
                                              return StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setState) {
                                                  return Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                  color: HexColor("#d6e2de")),
                                                height: MediaQuery.of(context).size.height / 2.5,
                                                child: Center(
                                                  child: Column(
                                                   children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(width: 2),
                                                            borderRadius: BorderRadius.circular(12)
                                                          ),
                                                          //height: MediaQuery.of(context).size.height / 7,
                                                          width: MediaQuery.of(context).size.width / 1.3 ,
                                                          child: ListView.builder(
                                                            itemCount: widget.getSavedShoppingLists.length,
                                                            itemBuilder:(context, index) => Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: HexColor("#B7FAFF"),
                                                                  border: Border.all(width:1 ),
                                                                  borderRadius: BorderRadius.circular(12)
                                                                ),
                                                                child: ListTile(
                                                                  onTap: () {
                                                                       
                                                                       
                                                                       datatoAcessebleData(index);
                                                                       
                                                                       
                                                                       Navigator.push(context, MaterialPageRoute(builder: ((context) => shoppingcard(new_: false, huan: huan, selectesMealList: [], oldShoppingList: list2, getItem: PlaceholderFunction, new_2: false, saveShoppingListToSavedLists: _addSavedShoppingListtoLists, old: true,))));
                                                                  },
                                                                  contentPadding: EdgeInsets.symmetric(),
                                                                  title: Center(
                                                                    child: Text(widget.getSavedShoppingLists[index]["name"],style: TextStyle(fontWeight: FontWeight.bold),)
                                                                    ),
                                                                ),
                                                              ),
                                                            ),),
                                                        ),
                                                      )
                                                    ),
                                                    
                                                   ],
                                                  ),
                                                ),
                                                 );});
                                             });
                                                
                                               
                                          }, 
                                        child: Container(
                                          color: Colors.transparent,
                                          height: MediaQuery.of(context).size.height / 7,
                                          width: MediaQuery.of(context).size.width / 10,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                               Padding(
                                                 padding: const EdgeInsets.all(8.0),
                                                 child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius: BorderRadius.circular(12)
                                                  ),
                                                   child: Icon(Icons.list, size: 69),
                                                     
                                                                                           
                                                 ),
                                               ),
                                               Text("Gespeicherte Liste", style: TextStyle(fontWeight: FontWeight.bold)),
                                               Text("verwenden", style: TextStyle(fontWeight: FontWeight.bold))
                                            ]
                                           
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: ((context) => select_meals_for_shopping(update2: false, ShoppingListData: _future_list(), updateShoppingList: UpdateShoppingList, update: false, callback: widget.callback2, spontaneous: true, getItem: _getOneMeal, savedShoppingList: _addSavedShoppingListtoLists))));
                                          
                                        }, 
                                        child: Container(
                                          color: Colors.transparent,
                                          height: MediaQuery.of(context).size.height / 7,
                                          width: MediaQuery.of(context).size.width / 10,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Container(
                                                    
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius: BorderRadius.circular(12)
                                                    ),
                                                    child: Icon(Icons.add, size: 69,)
                                                    
                                                  ),
                                                ),
                                              ),
                                              
                                                
                                                Text("Spontane Liste", style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text("erstellen", style: TextStyle(fontWeight: FontWeight.bold),)
                                              
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                             }
                          ); 
                        });
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

