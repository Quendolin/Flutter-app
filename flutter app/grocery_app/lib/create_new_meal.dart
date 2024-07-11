import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_app/add_ingridients_to_meal.dart';
import 'package:grocery_app/add_spices.dart';
import 'package:grocery_app/meal_model.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable, camel_case_types
class create_new_meal extends StatefulWidget {
  final Function callback; // _addItem
  final Function callback2; // _updateItem 
  final Future<List<Map<String, dynamic>>> ItemValues; 
  bool update;
  

  
  // ignore: non_constant_identifier_names
   create_new_meal({super.key, required this.callback, required this.callback2, required this.ItemValues, required this.update, });

  @override
  State<create_new_meal> createState() => _create_new_mealState();
}

class _create_new_mealState extends State<create_new_meal> {


  List add_spcies_to_meal(String name) {
    setState(() {
      spices instance = spices(spices_title: name);

      spices_list.add(instance);
      containerHeight_spices = containerHeight_spices + MediaQuery.of(context).size.height / 20;
      _containerHeight(0.000, containerHeight_spices);

      
    });
    return spices_list;
  }

  double delete_spices(int i) {
    spices_list.removeAt(i);
    if (spices_list.length < 3 ) {containerHeight_spices = containerHeight_spices - (MediaQuery.of(context)).size.height / 20;}
    return containerHeight_spices;
  }


   double delete_ingredient_from_meal(int i) {
    // i is the index of the ListModel i want to delete 
    added_ingridients_list.removeAt(i);
    if (added_ingridients_list.length < 5) {containerHeight = containerHeight - (MediaQuery.of(context)).size.height / 20;}
    
   

    return containerHeight;
  }



   List<add_ingridients_list>add_inngredient_to_meal_list(String name, String mass_unit, String mass) {
    setState(() {
      add_ingridients_list instance = add_ingridients_list(
      Ingridient_name: name,
      Ingridient_mass: mass,
      Ingridient_mass_unit: mass_unit);
      added_ingridients_list.add(instance);
      //counterHeight = counterHeight + MediaQuery.of(context).size.height / 15;
      
    });
    return added_ingridients_list;
  } 

  // ignore: non_constant_identifier_names
    Future_list_tolist() async {
    
      List<Map> list = await widget.ItemValues;
      txtcon_name_neuer_Mahlzeit.text = list[0]["title"];
      
      
      List ingridientsList = json.decode(list[0]["ingridientsJson"]);
       //ingridients_list = json.decode(ingridients_list);
      added_ingridients_list = ingridientsList.map((instance) {
        return add_ingridients_list(
          Ingridient_name: instance["Ingridient_name"],
          Ingridient_mass: instance["Ingridient_mass"],
          Ingridient_mass_unit: instance["Ingridient_mass_unit"]
        );
       }).toList();
       
       List spicesList = json.decode(list[0]["spicesJson"]);
       spices_list = spicesList.map((instance) {
         return spices(
          spices_title: instance["spices_title"]);
       },).toList();
      
       
      setState(() {
      });
      
      second = true;
      return added_ingridients_list;
    
  }

   

  void AddorUpdateMeal() async {
      List<Map> list = await widget.ItemValues;

      var ingridients_map = added_ingridients_list.map((e){
      return {
        "Ingridient_name": e.Ingridient_name,
        "Ingridient_mass": e.Ingridient_mass,
        "Ingridient_mass_unit": e.Ingridient_mass_unit
      };
      }).toList();

      String strings_map = json.encode(ingridients_map);
      print(strings_map);
      
      var spices_map = spices_list.map((e) {
        return {"spices_title": e.spices_title};
      }).toList();

      String spices_String = json.encode(spices_map);
      

      if (list.isEmpty) {

        widget.callback(txtcon_name_neuer_Mahlzeit.text, strings_map, spices_String);
      } else {
        widget.callback2(list[0]["id"], txtcon_name_neuer_Mahlzeit.text, strings_map, spices_String);
      }
     
      

    } 

    double _containerHeight(double containerHeight2, double containerHeight_spices2)  {
      

      setState(() {
        if (widget.update == true && second == true && boo == true ) {
          containerHeight = containerHeight + (MediaQuery.of(context).size.height / 20 * added_ingridients_list.length);
          containerHeight_spices = containerHeight_spices + (MediaQuery.of(context).size.height / 20 * spices_list.length);
          if (containerHeight > (MediaQuery.of(context)).size.height / 10.5 + ((MediaQuery.of(context)).size.height / 20 * 5)) {
            containerHeight = (MediaQuery.of(context)).size.height / 10.5 + ((MediaQuery.of(context)).size.height / 20 * 5); 
          }
          if (containerHeight_spices > (MediaQuery.of(context)).size.height / 10.5 + ((MediaQuery.of(context)).size.height / 20 * 3)) {
            containerHeight_spices = (MediaQuery.of(context)).size.height / 10.5 + ((MediaQuery.of(context)).size.height / 20 * 3);
          }
          widget.update = false;
          boo = false; 
        }


        if (added_ingridients_list.length < 5 && widget.update == false && containerHeight2 != 0.000) {
          if (containerHeight2 < containerHeight) { int i = 1;} 
          else {containerHeight = containerHeight2;}
        }
        if (spices_list.length < 3 && widget.update == false && containerHeight_spices2 != 0.000) { 
          if (containerHeight_spices2 < (MediaQuery.of(context).size.height / 20 * 3) + MediaQuery.of(context).size.height /10.5) {int i = 1;}
           if (containerHeight_spices2 > (MediaQuery.of(context).size.height / 20 * 3) + MediaQuery.of(context).size.height /10.5) {
            containerHeight_spices = containerHeight_spices - MediaQuery.of(context).size.height / 20;
          }
          }
        if (spices_list.length > 3 && widget.update == false && containerHeight_spices2 != 0.000) {
          containerHeight_spices = containerHeight_spices - MediaQuery.of(context).size.height / 20;
        }

        
        
      });
      
      return containerHeight ;
    }
      


  
  TextEditingController txtcon_name_neuer_Mahlzeit = TextEditingController();
  

  List spices_list = [];
  List<add_ingridients_list> added_ingridients_list = [];
  
  
  bool second = false;
  bool place = true;
  bool boo = true; 

  late double containerHeight;
  late double containerHeight_spices;

  @override
  Widget build(BuildContext context)   { 
    
    if (added_ingridients_list.length == 0 && spices_list.length == 0) {containerHeight  = MediaQuery.of(context).size.height / 10.5 ; containerHeight_spices = MediaQuery.of(context).size.height / 10.5;}
   
    
    //counterHeight = MediaQuery.of(context).size.height / 5;
    // hier alle txt controller values geben 
    
    if (widget.update == true && second == false)   {
         print("hallo");
        Future_list_tolist();
        
         print("dingdong");
    }
    if (widget.update == true && second ==true && boo == true) { 
      _containerHeight(containerHeight, containerHeight_spices);
      
      }
    
      
    

    
    return  GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      
      child: Scaffold(
        backgroundColor:  HexColor("31473A"),
        
            body:ListView(
              primary: true,
            
      
               
              children: [ 
                Column( 
                   children: [
              Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                
                width: MediaQuery.of(context).size.width, 
                height: MediaQuery.of(context).size.height / 10,
                decoration: BoxDecoration(
                  color: HexColor("#d6e2de"),
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: Text("Neue Mahlzeit!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), ),
                ),
            ),
      
              Align(
              alignment: Alignment.centerLeft,
              child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Text( "Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
            )
           ),
      
           Padding(
             padding: EdgeInsets.all(10),
             child: TextField(
              controller: txtcon_name_neuer_Mahlzeit,
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
                )
                
              )
             
             
             ),
           ),
      
           
      
           
      
           Align(
              alignment: Alignment.centerLeft,
              child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Text( "Zutaten", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
           )
           ),
      
           Padding(
            padding: EdgeInsets.all(10),
      
              child:Container(
                decoration: BoxDecoration(
                  color: HexColor("#3c634c"),
                  border: Border.all(width: 1.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(12)
                ),
             
                
                width: MediaQuery.of(context).size.width, 
                height: containerHeight,
                child: 
                  ListView(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.all(5),
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: added_ingridients_list.length,
                        itemBuilder: (context, index) =>Container(
                          height: MediaQuery.of(context).size.height / 15,
                          decoration: BoxDecoration( 
                            color: HexColor("#d6e2de"),
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                            child: Center(
                              child: ListTile(
                              contentPadding: EdgeInsets.only(left: 12),
                            
                              title:Row( children: [
                                Expanded(
                                  flex:3, 
                                  child: Container(
                                  
                                  child: Text(added_ingridients_list[index].Ingridient_name!, style: TextStyle(color: Colors.black),)
                                  )),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      child: Text("${added_ingridients_list[index].Ingridient_mass!} ${added_ingridients_list[index].Ingridient_mass_unit!}", style: TextStyle(color: Colors.black), )
                                      ),
                                  ),
                                  
                              ] ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.black,),
                                onPressed: () {
                              
                                  setState(() {
                                   containerHeight = delete_ingredient_from_meal(index);
                                  });
                                },
                              ),
                                                  
                                                  ),
                            ),
                        )
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FloatingActionButton.small(
                          heroTag: "btn1",
                          
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onPressed:() {
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => add_ingridients_to_meal(callback: add_inngredient_to_meal_list, containerHeight: containerHeight, containerHeight4: _containerHeight, )));
                            },
                                      child: Icon(Icons.add),
                                      ),
                      ),
                    ],
                  )
                  
                
              ),
             ),
      
              const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
              padding: EdgeInsets.only(left: 13),
              child: Text( "Gewürze", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
              )
              ),
      
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:  HexColor("#3c634c"),
                    border: Border.all(width: 1.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  height: containerHeight_spices,
                  child: ListView( 
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.all(5),
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: spices_list.length,
                        itemBuilder: (context, index) =>Container(
                          height: MediaQuery.of(context).size.height / 15,
                          decoration: BoxDecoration( 
                            color: HexColor("#d6e2de"),
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: ListTile(
                              contentPadding: EdgeInsets.only(left: 12),
                              title: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:155),
                                          child: Container(
                                                                          
                                            child: Text(spices_list[index].spices_title!, style: TextStyle(color: Colors.black),)
                                            ),
                                        
                                                                        
                                                                        
                                                                     ),
                                      ],
                                    ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.black,),
                                onPressed: () {
                              
                                  setState(() {
                                   containerHeight_spices = delete_spices(index);
                                  });
                                },
                              ),
                                                  
                                                  ),
                            ),
                        )
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FloatingActionButton.small( 
                          heroTag: "btn2",
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onPressed:() {
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => add_spcies(add: add_spcies_to_meal )));
                            },
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  
                ),
              ),
            
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: GestureDetector( 
                onTap: () {
                    //print(list[0]["id"]);
                    AddorUpdateMeal();
                  Navigator.pop(context);
                },
               child: Container(
                width: MediaQuery.of(context).size.width, 
                height: MediaQuery.of(context).size.height / 9,
                color: HexColor("#d6e2de"),
                child: Center(
                  child: Icon(Icons.done, color: Colors.black),
                   
                    ),
                    )
                   )
               ),
             
             
             
            ]
            
           )
           ]
        ),
      
      
      ),
    );
  }
}



