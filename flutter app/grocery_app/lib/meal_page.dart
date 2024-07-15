import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/meal_model.dart';
import 'package:hexcolor/hexcolor.dart';

class meal_page extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> db_ingridents_List; 
  const meal_page({super.key, required this.db_ingridents_List});

  @override
  State<meal_page> createState() => _meal_pageState();
}

class _meal_pageState extends State<meal_page> {

   Get_ingridients_List() async {
    
      List<Map> list = await widget.db_ingridents_List;
      print(list);
      print(list.runtimeType);
      //txtcon_name_neuer_Mahlzeit.text = list[0]["title"];

  
      List ingridientsList = json.decode(list[0]["ingridientsJson"]);
       //ingridients_list = json.decode(ingridients_list);
      ingridients_list_from_meal = ingridientsList.map((instance) {
        return add_ingridients_list(
          Ingridient_name: instance["Ingridient_name"],
          Ingridient_mass: instance["Ingridient_mass"],
          Ingridient_mass_unit: instance["Ingridient_mass_unit"]
        );
       }).toList();
       print(ingridients_list_from_meal);
       print(ingridients_list_from_meal.runtimeType);
       name = list[0]["title"];
      

        List spices_List2 = json.decode(list[0]["spicesJson"]);
        spices_list_from_meal = spices_List2.map((instance) {
          return spices(spices_title: instance["spices_title"]);
        }).toList();
       
      second = second +1;
       
      setState(() {
      });
      
    
      return ingridients_list_from_meal;
    
  }

  double DetermineContainerSize_ingredients() {
    double containerHeight = (MediaQuery.of(context).size.height / 15) * ingridients_list_from_meal.length;
    return containerHeight;
  }
   double DetermineContainerSize_spices() {
    double containerHeight = (MediaQuery.of(context).size.height / 15) * spices_list_from_meal.length;
    return containerHeight;
   }
  String name = "name";
  late double containerHeight;
  // ignore: non_constant_identifier_names
  late double containerHeight_spcices;
  int second = 0; 
  // ignore: non_constant_identifier_names
  List<add_ingridients_list> ingridients_list_from_meal = [];
  List<spices> spices_list_from_meal = [];
  bool first = true; 
  @override
  Widget build(BuildContext context) {
    
    if (first == true) {
      containerHeight = 2;
      containerHeight_spcices =2;
      Get_ingridients_List();
      
      
      first = false; 
      
    }
    if (second == 1) {
      containerHeight = DetermineContainerSize_ingredients() + (MediaQuery.of(context).size.height / (MediaQuery.of(context).size.height / 13));
      containerHeight_spcices = DetermineContainerSize_spices() + (MediaQuery.of(context).size.height / (MediaQuery.of(context).size.height / 13));
    }

    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("31473A") ,
        centerTitle: true,
        title: Text(name, style: TextStyle(color: Colors.white),),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed:() => Navigator.pop(context))),
      backgroundColor: HexColor("31473A"),
      body: ListView( 
        children: [
          
            SizedBox(height: MediaQuery.of(context).size.height / 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text("Zutaten", style: TextStyle(color: Colors.white), ),
              ),
            ),
          
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  //color: HexColor("#3c634c"),
                  border: Border.all(width: 1.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: ListView.builder(
                 
                  padding: EdgeInsets.all(5),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  
                  
                  itemCount: ingridients_list_from_meal.length,
                  itemBuilder: (context, index) => Container(
                    height: MediaQuery.of(context).size.height / 15,
                    decoration: BoxDecoration( 
                      //color: HexColor("#588a7a"),
                      //border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: ListTile(
                        
                  
                        title:Row( children: [
                          Expanded(
                            flex:1, 
                            child: Container(
                            
                            child: Text(ingridients_list_from_meal[index].Ingridient_name, style: TextStyle(color: Colors.white),)
                            )),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Text("${ingridients_list_from_meal[index].Ingridient_mass} ${ingridients_list_from_meal[index].Ingridient_mass_unit}", style: TextStyle(color: Colors.white), )
                                ),
                            ),
                            
                        ] ),
                        
                                            
                       ),
                  )
                  ) ,
              ),
            )
         ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          if (spices_list_from_meal.isNotEmpty) const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Text("Gewürze", style: TextStyle(color: Colors.white), ),
              ),
            ),
            if (spices_list_from_meal.isNotEmpty) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: containerHeight_spcices,
                decoration: BoxDecoration(
                  //color: HexColor("#3c634c"),
                  border: Border.all(width: 1.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: ListView.builder(
                 
                  padding: EdgeInsets.all(5),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  
                  
                  itemCount: spices_list_from_meal.length,
                  itemBuilder: (context, index) => Container(
                    height: MediaQuery.of(context).size.height / 15,
                    decoration: BoxDecoration( 
                      //color: HexColor("#588a7a"),
                      //border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(12)),
                    
                      
                        child: ListTile(
                          
                          title:Text(spices_list_from_meal[index].spices_title, style: TextStyle(color: Colors.white), textAlign: TextAlign.center, ),),
                          
                         
                   
                  
                  ) ,
              ),
            )
         ),
        ],
      ),
    );
  }
}