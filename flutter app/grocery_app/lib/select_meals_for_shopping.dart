import 'dart:convert';
import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';

import 'package:grocery_app/meal_model.dart';
import 'package:grocery_app/shopping_list.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable, camel_case_types
class select_meals_for_shopping extends StatefulWidget {
  final List callback; 
  final Function savedShoppingList;
  final Function getItem;
  final bool spontaneous;
  final Function updateShoppingList;
  final Future<List<Map<String, dynamic>>> ShoppingListData;
  bool update; 
  final bool update2;
  select_meals_for_shopping({super.key, required this.update2, required this.ShoppingListData, required this.updateShoppingList, required this.update, required this.callback, required this.getItem, required this.savedShoppingList, required this.spontaneous});

  @override
  State<select_meals_for_shopping> createState() => _select_meals_for_shoppingState();
}

class _select_meals_for_shoppingState extends State<select_meals_for_shopping> {

  List<shoppingIngredient> temporaryIngriedientlist = [];

  ingredientsShoppingListCalculation(List<shoppingIngredient> list, String name, List<spices> spicesList) {
     Map<String, shoppingIngredient> finalIngredientMap ={};
     Map<String, spices> finalSpicesMap = {};
    for (var ingredients in list) {
     

       if (finalIngredientMap.containsKey(ingredients.Ingridient_name)) {
        double existingMass = double.parse(finalIngredientMap[ingredients.Ingridient_name]!.Ingridient_mass);
        double additionalMass = double.parse(ingredients.Ingridient_mass);
        double combinedMass = (existingMass + additionalMass);
        // check ob switch zu int
        if (combinedMass == combinedMass.toInt()) {
           int combinedMassNew = combinedMass.toInt();
           finalIngredientMap[ingredients.Ingridient_name]!.Ingridient_mass = (combinedMassNew).toString();
           } else {
            finalIngredientMap[ingredients.Ingridient_name]!.Ingridient_mass = (combinedMass).toString();
           }
             } else {
        
        double toInt = double.parse(ingredients.Ingridient_mass);
        if (toInt == toInt.toInt()) {
          int Int = toInt.toInt();
          ingredients.Ingridient_mass = Int.toString();
        }
        
        
        // wenn Zuatat noch nicht Existiert 
        finalIngredientMap[ingredients.Ingridient_name] = ingredients;
      
      
    }
      
      finalIngredientList = finalIngredientMap.values.toList();
    }


    // doppelte Gewürze aussortieren 

    for (var i in spicesList) {

      if (finalSpicesMap.containsKey(i.spices_title)) {
        

      } else {
        finalSpicesMap[i.spices_title] = i;
      }
    }
      finalSpicesList = finalSpicesMap.values.toList();
    // check ob eine neue shoppingList erstellt werden soll oder eine geupdated werden soll 
      if (widget.update2) {
        widget.updateShoppingList(old_id, name, finalIngredientList, selected_meals_list, finalSpicesList);
      }  else {
        widget.savedShoppingList(name, finalIngredientList, selected_meals_list, finalSpicesList);
      }
      
  }
  
  shoppingListToSavedList(String name,) async {
    
    for (var i in selected_meals_list) {
      int id = i.meal_id;
      int size = i.meal_size;

      List<Map> list = await widget.getItem(id);

      List tempIngredientList = json.decode(list[0]["ingridientsJson"]);
      
          temporaryIngriedientlist.addAll(tempIngredientList.map((instance) {
          return shoppingIngredient(
            Ingridient_name: instance["Ingridient_name"],
            Ingridient_mass: (double.parse(instance["Ingridient_mass"]) * size).toString(),
            Ingridient_mass_unit: instance["Ingridient_mass_unit"],
            crossedOff: false,
          );
         }).toList());

      List tempSpicesList = json.decode(list[0]["spicesJson"]);
      temporarySpicesList.addAll(tempSpicesList.map((e) {

        return spices(
          spices_title: e["spices_title"]);
      }).toList());
    }

      
      ingredientsShoppingListCalculation(temporaryIngriedientlist, name, temporarySpicesList);
  
  }
  
  select_meal(var data) async {
    List<Map> list = await data;
    
    var dbItem = list.first;
    
   // list = json.decode(list[0]["title"]);
    //selected_meals_list = list.map((instance) {String id = list["id"] }).toList();
    int id = dbItem["id"];
    String name = dbItem["title"];

    //check ob Meal bereits ausgewählt ist

    for (var i in selected_meals_list) {
      if (id == i.meal_id) {
        doNotAdd = true;
        print("acces denied");
        break;
      } 
    }

    if (doNotAdd == false) {
       selectedMeal instance = selectedMeal(meal_title: name, meal_id: id, meal_size: 1);
      selected_meals_list.add(instance); 
      setState(() {});
    }
  }

  loadShoppingListData() async  {
    List<Map> list = await widget.ShoppingListData;
    print(list);
    old_id = list[0]["id"];
    _controller2.text = list[0]["name"];


    List mealList = json.decode(list[0]["originalMealListFromShoppingListJson"]);
    selected_meals_list = mealList.map((instance) {
      return selectedMeal(
        meal_title: instance["meal_title"],
        meal_id: instance["meal_id"],
        meal_size: instance["meal_size"]);
    }).toList();
    setState(() {
      
    });
  }
  
  List<spices> temporarySpicesList = [];
  List<spices> finalSpicesList = [];
  List<shoppingIngredient> finalIngredientList = [];
  TextEditingController _controller2 = TextEditingController();
  int mealSize = 1;
  List<selectedMeal> selected_meals_list = []; 
  bool genrated = false; 
  bool doNotAdd = false;  
  String old_name = "";
  late int old_id;

  FocusNode textfield = FocusNode();
  FocusNode _node = FocusNode();

  @override
  Widget build(BuildContext context) {

    if (widget.update == true) {

      loadShoppingListData();
      widget.update = false; 
    }

    return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: HexColor("#31473A"),
        appBar:AppBar(
        backgroundColor: HexColor("#31473A"),
        title: Text("Mahlzeiten", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (widget.update2) {
              Navigator.pop(context);
            } else if (widget.spontaneous) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
      
          },
          icon: Icon(Icons.arrow_back, 
          color: Colors.white,
          )),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {
            },
            ), 
        ],
      ),
        body: Column(
          
          children: [
            
            widget.spontaneous == false? 
            
              Column(
                children: [
                   const Align(
                    alignment: Alignment.center,
                    
                      
                      child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(
                      controller: _controller2,
                      focusNode: _node,
                      decoration: InputDecoration(
                        fillColor: HexColor("#d6e2de"),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1), 
                          borderRadius: BorderRadius.circular(12)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black, width: 2)
                        ),
                     ),
                   ),
                  )
                      
                ],
              )
            : Container(),
            const Align(
              alignment: Alignment.center,
              child: Text("Gespeicherte Gerichte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            Padding(padding: EdgeInsets.all(8),
            child: Container(
              height:  widget.spontaneous == false ? MediaQuery.of(context).size.height /3.5 : MediaQuery.of(context).size.height /2.5 ,
              decoration: BoxDecoration(
                color: HexColor("#3c634c"),
                border: Border.all(),
                borderRadius: BorderRadius.circular(12)
              ),
              child: ListView.builder(
                  itemCount: widget.callback.length,
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
                          var data = widget.getItem(widget.callback[index]["id"]);
                          select_meal(data);
                          
                        },
                        titleAlignment: ListTileTitleAlignment.center,
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                        title: Text(widget.callback[index]["title"], style: TextStyle(color: Colors.black,), textAlign: TextAlign.center,),
                        
                       ),
                    ),
                    )
                  ) 
                ),
            ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text("Ausgewählte Gereichte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            Padding(padding: EdgeInsets.all(8),
            child: Container(
              height: MediaQuery.of(context).size.height /3.2,
              
              decoration: BoxDecoration(
                 color: HexColor("#3c634c"),
                border: Border.all(),
                borderRadius: BorderRadius.circular(12)
              ),
              child: ListView.builder(
                itemCount: selected_meals_list.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10.0),
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
                        onTap: () {
                          setState(() {
                            selected_meals_list.removeAt(index);
                          });
                          
                        },
                        title: Text(selected_meals_list[index].meal_title, style: TextStyle( color: Colors.black),),
                        trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Anzahl", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),),
                                CupertinoButton(
                                 
                                 onPressed:() => showCupertinoModalPopup(
                                  context: context, 
                                  builder: (_) => SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height / 5,
                                    child: CupertinoPicker(
                                      backgroundColor: HexColor("#d6e2de"),
                                      itemExtent: 30,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: selected_meals_list[index].meal_size -1 
                                      ),
                                      children: const [
                                        Text("1"),
                                        Text("2"),
                                        Text("3"),
                                        Text("4"),
                                        Text("5"),
                                        
                                      ],
                                      onSelectedItemChanged: (int value) {
                                        setState(() {
                                          selected_meals_list[index].meal_size = value + 1; 
                                        });
                                      },
                                    ),
                                  )
                                 ),
                                  
                                child: Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height / 19,
                                  width: MediaQuery.of(context).size.width / 9,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Text(selected_meals_list[index].meal_size.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15) )
                                ),
                                ),
                              ],
                            
                        )
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    
                    if (selected_meals_list.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kein Gericht ausgewählt"), duration: Duration(milliseconds: 300),));
                      return;
                    }
      
                    if (widget.spontaneous == true) {
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => shoppingcard(new_: true, getItem: widget.getItem, selectesMealList: selected_meals_list, saveShoppingListToSavedLists: widget.savedShoppingList, oldShoppingList: [], oldSpicesList: [],))));
                    } else {
                          if (_controller2.text.isEmpty) {
                            _node.requestFocus();
                          } else {
                               shoppingListToSavedList(_controller2.text);
                               Navigator.pop(context);
                          }
                        }
                    },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: HexColor("#d6e2de"),
                      border:Border.all(),
                      borderRadius: BorderRadius.circular(12)
                     ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                        child: Center(
                            child: Text("Fertig", style: TextStyle(fontWeight: FontWeight.bold))
                      ),
                    )
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}