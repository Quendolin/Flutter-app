import 'dart:convert';
import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:grocery_app/meal_model.dart';
import 'package:grocery_app/shopping_list.dart';
import 'package:hexcolor/hexcolor.dart';

class select_meals_for_shopping extends StatefulWidget {
  final List callback; 
  final Function getItem;
  const select_meals_for_shopping({super.key, required this.callback, required this.getItem});

  @override
  State<select_meals_for_shopping> createState() => _select_meals_for_shoppingState();
}

class _select_meals_for_shoppingState extends State<select_meals_for_shopping> {



  generateShoppinglist() async {
    for (var i in selected_meals_list ) {
         int id = i.meal_id;
         int size = i.meal_size;

         
         List<Map> list = await widget.getItem(id);
         print(list);

          // Zutaten Liste 
         List tempIngredientList = json.decode(list[0]["ingridientsJson"]);
         temporaryIngriedientlist.addAll(tempIngredientList.map((instance) {
          return add_ingridients_list(
            Ingridient_name: instance["Ingridient_name"],
            Ingridient_mass: (double.parse(instance["Ingridient_mass"]) * size).toString(),
            Ingridient_mass_unit: instance["Ingridient_mass_unit"]
          );
         }).toList());

         //Gewürze Liste 

         List tempSpicesList = json.decode(list[0]["spicesJson"]);
          temporarySpicesList = tempSpicesList.map((instance) {
          return spices(spices_title: instance["spices_title"]);
        }).toList();
    }
    ingredientsShoppingListDone(temporaryIngriedientlist,); 
  }

  ingredientsShoppingListDone(List<add_ingridients_list> Ingredients) {
    

    Map<String, add_ingridients_list> finalIngredientMap ={};

    for (var ingredients in Ingredients) {
      // Wenn Zutat doppelt ist 
      if (finalIngredientMap.containsKey(ingredients.Ingridient_name)) {
        double existingMass = double.parse(finalIngredientMap[ingredients.Ingridient_name]!.Ingridient_mass!);
        double additionalMass = double.parse(ingredients.Ingridient_mass!);
        double combinedMass = (existingMass + additionalMass);
        var newCombinedMass;
        try {
          newCombinedMass = combinedMass.round();
          
        } catch (e) {
          newCombinedMass = double.parse(newCombinedMass);
          
        } 

        finalIngredientMap[ingredients.Ingridient_name]!.Ingridient_mass = (newCombinedMass).toString();
      } else {
        // wenn Zuatat noch nicht Existiert 
        finalIngredientMap[ingredients.Ingridient_name!] = ingredients;
      }
      
    }
      finalIngredientList = finalIngredientMap.values.toList();
      print(finalIngredientList);

  }
  select_meal(var data) async {
    List<Map> list = await data;
    
    var dbItem = list.first;
    
   // list = json.decode(list[0]["title"]);
    //selected_meals_list = list.map((instance) {String id = list["id"] }).toList();
    int id = dbItem["id"];
    String name = dbItem["title"];

    selectedMeal instance = selectedMeal(meal_title: name, meal_id: id, meal_size: 1);
    selected_meals_list.add(instance); 
    setState(() {});
  }
  List<add_ingridients_list> finalIngredientList = [];
  List<spices> temporarySpicesList = [];
  List<add_ingridients_list> temporaryIngriedientlist = [];
  int mealSize = 1;
  List selected_meals_list = []; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#31473A"),
      appBar:AppBar(
      backgroundColor: HexColor("#31473A"),
      title: Text("Mahlzeiten", style: TextStyle(color: HexColor("#EDF4F2"))),
      centerTitle: true,
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
          Align(
            alignment: Alignment.center,
            child: Text("Gespeicherte Gerichte", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
          Padding(padding: EdgeInsets.all(8),
          child: Container(
            height: MediaQuery.of(context).size.height /2.5,
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
                        setState(() {
                          
                        });
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
                      title: Text(selected_meals_list[index].meal_title!, style: TextStyle( color: Colors.black),),
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
                                      initialItem: selected_meals_list[index].meal_size! -1 
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
              child: InkWell(
                onTap: () {
                  generateShoppinglist();
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => shoppingcard(new_: false, finalIngredientList: finalIngredientList,))));
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
                          child: Text("Fertig", style: TextStyle(fontWeight: FontWeight.bold,))
                         ),
                        )
                       )
              ),
            ),
          )
        ],
      ),
    );
  }
}