import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_app/add_ingridients_to_meal.dart';
import 'package:grocery_app/meal_model.dart';
import 'package:hexcolor/hexcolor.dart';

// ignore: must_be_immutable, camel_case_types
class shoppingcard extends StatefulWidget {
  shoppingcard({super.key, required this.new_, required this.getItem,  required this.selectesMealList, required this.saveShoppingListToSavedLists, required this.oldShoppingList, required this.oldSpicesList,});
  bool new_;
  
  Function saveShoppingListToSavedLists;
  final List<shoppingIngredient> oldShoppingList;
  final List <spices> oldSpicesList;

  Function getItem;
  final List selectesMealList; 
  @override
  State<shoppingcard> createState() => shoppingcardState();
}

class shoppingcardState extends State<shoppingcard> {

  //late bool existing_shopping_list;
  bool first = true; 
  bool button1 = true;
  int currentPage = 0;
  final PageController _pageController = PageController( initialPage: 0);





  checkCrossedOutIngredient(int index) {
        setState(() {
          finalIngredientList[index].crossedOff = !finalIngredientList[index].crossedOff;
        });
  }

   generateShoppinglist() async {
    for (var i in widget.selectesMealList ) {
         int id = i.meal_id;
         int size = i.meal_size;

         
         List<Map> list = await widget.getItem(id);
         print(list);

          // Zutaten Liste 
         List tempIngredientList = json.decode(list[0]["ingridientsJson"]);
         temporaryIngriedientlist.addAll(tempIngredientList.map((instance) {
          return shoppingIngredient(
            Ingridient_name: instance["Ingridient_name"],
            Ingridient_mass: (double.parse(instance["Ingridient_mass"]) * size).toString(),
            Ingridient_mass_unit: instance["Ingridient_mass_unit"],
            crossedOff: false,
          );
         }).toList());

         //Gewürze Liste 

         List tempSpicesList = json.decode(list[0]["spicesJson"]);
          temporarySpicesList.addAll(tempSpicesList.map((instance) {
          return spices(spices_title: instance["spices_title"]);
        }).toList());
        
    }
    ingredientsShoppingListDone(temporaryIngriedientlist, temporarySpicesList);
    
    setState(() {
      
    });
  }
  ingredientsShoppingListDone(List<shoppingIngredient> Ingredients, List<spices> spicesList) {
    

    Map<String, shoppingIngredient> finalIngredientMap ={};
    Map<String, spices> finalSpicesMap = {};

    for (var ingredients in Ingredients) {
      // Wenn Zutat doppelt ist 
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
      
    }
      finalIngredientList = finalIngredientMap.values.toList();
      


    for (var i in spicesList) {

      if (finalSpicesMap.containsKey(i.spices_title)) {

      } else {
        finalSpicesMap[i.spices_title] = i;
      }
      

    }

    finalSpicesList = finalSpicesMap.values.toList();

  }

  List<shoppingIngredient> finalIngredientList = [];
  List<spices> temporarySpicesList = [];
  List<spices> finalSpicesList = [];
  List<shoppingIngredient> temporaryIngriedientlist = [];
  bool generated = false;

  TextEditingController _controller = TextEditingController();
  FocusNode textfield = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
       if (widget.new_) {
      generateShoppinglist();
    }
    if (!widget.new_) {
      finalIngredientList = List.from(widget.oldShoppingList);
      finalSpicesList = List.from(widget.oldSpicesList);
    }
    });
   
  }

  

  


  

  @override
  Widget build(BuildContext context)  {

    return PopScope(
      canPop: false,
      child: Scaffold(  
          appBar: AppBar(
            backgroundColor: HexColor("#31473A"),
            title: Text("Mahlzeiten", style: TextStyle(color: HexColor("#EDF4F2"))),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                if (widget.new_) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  
                  } else {
                    
                    Navigator.pop(context);
                  }
              }, 
            icon: Icon(Icons.arrow_back, color: Colors.white,)) ,
            actions: <Widget> [
              
             
               ],
           ),
          backgroundColor: HexColor("31473A"),
          body: Column( children: [
            
             Container(
                alignment: Alignment.centerLeft,
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(right:40.0),
                      child: GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(0, duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height /18,
                          width: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: currentPage  ==  0 ? HexColor("#d6e2de") : HexColor("#3c634c") ,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text("Zutaten", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:40.0),
                      child: GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
                          
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height /18,
                          width: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: currentPage == 0 ? HexColor("#3c634c") : HexColor("#d6e2de")  ,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text("Gewürze", style: TextStyle(fontWeight: FontWeight.bold, color:  Colors.black))),
                      ),
                    ),
                  ],
                )
              ),
             
             
            
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                    decoration: BoxDecoration(
                      color: HexColor("#3c634c"),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()
                      ),
                    child: PageView(
                      pageSnapping: true,
                      onPageChanged:(value) {
                        setState(() {
                          currentPage = value; 
                        });
                      }, 
                      controller: _pageController,
                      children:  [
                        ListView.builder(
                          itemCount: finalIngredientList.length,
                          itemBuilder: (context, index) =>  
                            
                            ListTile(
                              onTap: () => checkCrossedOutIngredient(index),
                              title: Row( 
                                children: [
                                  Expanded(
                                  flex:3, 
                                    child: Container(
                                      child: Text(finalIngredientList[index].Ingridient_name, style: TextStyle(color: Colors.white, decoration: finalIngredientList[index].crossedOff == false ? null : TextDecoration.lineThrough, decorationThickness: finalIngredientList[index].crossedOff == false ? null : 3 ),)
                                )),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    child: Text("${finalIngredientList[index].Ingridient_mass} ${finalIngredientList[index].Ingridient_mass_unit}", style: TextStyle(color: Colors.white, decoration: finalIngredientList[index].crossedOff == false ? null : TextDecoration.lineThrough, decorationThickness: finalIngredientList[index].crossedOff == false ? null : 3  ),  )
                                    ),
                                ),
                                
                            ] ),
                              
                              
                              
                            ),
                          ),
                      
                        ListView.builder(
                          itemCount: finalSpicesList.length,
                          itemBuilder: (context, index) => ListTile(
                            
                            title: Center(child: Text(finalSpicesList[index].spices_title, style: TextStyle(color: Colors.white),)),
                          ) 
                        )
                      ],
                     
                      ),
                    
                      
                     
                      ),
                  )
                  ),
              
             
             Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all()
                  ),
                  child:  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: InkWell(
                                onTap: () {
                                    if (widget.new_)  {
                                      showModalBottomSheet(
                                    context: context, 
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height / 2.5,
                                        decoration: BoxDecoration(
                                          color: HexColor("#d6e2de"),
                                          borderRadius: BorderRadius.circular(15)
                                        ),
                                        child:  Center(
                                          child: Row(
                                            
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        
                                                        
                                                      
                                                      
                                                      
                                                      
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(context).size.height / 7,
                                                      width: MediaQuery.of(context).size.width / 10,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Text("Liste verwerfen", style: TextStyle(fontWeight: FontWeight.bold),),
                                                    )
                                                  ),
                                                )
                                                 ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: InkWell(
                                                    onTap: () { 
                                                    textfield.requestFocus();
                                                    showDialog(
                                                      context: context, 
                                                      builder: (context) =>  AlertDialog(
                                                        title: Center(child: Text("Name", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                                                        content: TextField(
                                                          onSubmitted: (name) {
                                                            name = name.capitalize();
                                                            widget.saveShoppingListToSavedLists(name, finalIngredientList, widget.selectesMealList, finalSpicesList);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                          },
                                                          controller: _controller,
                                                          focusNode: textfield,
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                          decoration: InputDecoration(
                                                          
                                                          
                                                          filled: false,
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black, width: 1), 
                                                            borderRadius: BorderRadius.circular(12)
                                                            ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                            borderSide: BorderSide(color: Colors.black, width: 2)
                                                            )
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:() {
                                                              String name = _controller.text;
                                                              name = name.capitalize();
                                                              widget.saveShoppingListToSavedLists(name, finalIngredientList, widget.selectesMealList, finalSpicesList);
                                                              
                                                              
                                                              // Funktion für Speicherung der Liste 
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              Navigator.pop(context);
                                                              
                                                            },
                                                            child: Text("Ok", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                                                            )
                                                        ],
                                                      ));
                                                      },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      height: MediaQuery.of(context).size.height / 7,
                                                      width: MediaQuery.of(context).size.width / 10,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      child: Text("Liste speichern", style: TextStyle(fontWeight: FontWeight.bold),),
                                                    )
                                                  ),
                                                )
                                                 )
                                            ],
                                          ),
                                        ),
                                      );
                                    } 
                                    );
                                    } else {
                                      Navigator.pop(context);
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
                                        child: Text("Fertig", style: TextStyle(fontWeight: FontWeight.bold,))
                                        ),
                                  )),
                              ),
                            ),
                          ),
                          
                          
                      ],
                    ),
                  ),
                ),
              )
              )
            
          ],
        
          ) ,
        
       ),
    );
  }
}

