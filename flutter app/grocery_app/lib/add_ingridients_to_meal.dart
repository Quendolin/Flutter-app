
import 'package:flutter/material.dart';
import 'package:grocery_app/meal_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

// ignore: must_be_immutable
class add_ingridients_to_meal extends StatefulWidget {
  final Function callback;
  double containerHeight;
  final Function containerHeight4;
  add_ingridients_to_meal({super.key, required this.callback, required this.containerHeight, required this.containerHeight4});
  

 

  @override
  State<add_ingridients_to_meal> createState() => _add_ingridients_to_mealState();
}

class _add_ingridients_to_mealState extends State<add_ingridients_to_meal> {



List<String> ValidChars = ["1","2","3","4","5","6","7","8","9","0",".",","];

List<Ingridients> displayed_add_ingridients_to_meal = List.from(Ingridients_name_list);




 List  amount_list = [ 
  "Gramm",
  "Stück",
  "Milliliter",
  "Esslöffel",
  "Liter",
  "Kilo",


];


  double add_ingridients_to_meal_with_all(double containerHeight) {
     String array = _controller2.text;
     String name = _controller1.text;
     textfield2.unfocus();

    error = false; 
    right = false;

    
    for (int a = 0; a <= array.length -1; a++) 
                  {

                    for (int u=0; u <= ValidChars.length; u++) 
                    {

                      if (array[a] == ValidChars[u])
                      {
                        if (a == array.length - 1) 
                        {
                         
                          
                            widget.callback(name, ingredients_amount, array.replaceAll(",", "."));
                            containerHeight = containerHeight + MediaQuery.of(context).size.height / 20;
                            widget.containerHeight4(containerHeight, 0.000);
                          right = true;
                    
                          Navigator.pop(context);
                          break;
                        } 
                          else {
                            print("richtige EIngabe aber nicht letzer Char");  
                          break;
                        } 
                        
                      } 
                      else {
                        if( u == 10) {
                          error = true;
                          print(error);
                          break;
                        } 
                        else 
                        { 
                        print("match");
                          }
                       }
                       }
                       if (error == true) {
                        textfield2.requestFocus();
                        print("lul");
                        break;
                       }
                  }
                  if (array.length == 0) {textfield2.requestFocus();}
                  return containerHeight;
  }

  Ingredient_amount_change(String value) {

        setState(() {
           
            if (i < 6) {
              ingredients_amount = amount_list[i];
              i++;
            } else {
              i = i -6;
              ingredients_amount = amount_list[i];
              i++;
              
            }
            
                        
                       print(ingredients_amount);
                       print(i);
                        
        });
        return i; 
         
  }





  



  void updateList(String value) {
    setState(() {
      displayed_add_ingridients_to_meal = Ingridients_name_list.where((element) => element.Ingridient_title!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  Ingridients_Selected_x(String ingredient_string) {


    setState(() {
      
      _controller1.text = ingredient_string;
      ingridients_selceted == false;
    });
    ingridients_selceted = false; 
    print(ingredient_string);
    return _controller1.text; 
  }


  Ingridients_Selected_y() {


    setState(() {
      
      ingridients_selceted == true;
    });
    ingridients_selceted = true; 
    
    return ingridients_selceted; 


  }

  
    
  

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  FocusNode textfield2 = FocusNode();
  

  
  bool  ingridients_selceted = true;  
  int i = 1;
  int dunno = 0;
  bool error = false; 
  bool right = false;

  String ingredients_amount = "Gramm"; 

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: HexColor("31473A"),
        body: 
        Column(
        
        children: [ 
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 14,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
          padding: EdgeInsets.only(left: 13),
          child: Text( "Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
         )
         ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
          onSubmitted: (value) {
            
              Ingridients_Selected_x(_controller1.text);
              print(_controller1.text);
            },
          onTap: () {
              Ingridients_Selected_y();
            },
          onChanged: (value) => updateList(value),

          autofocus: true,
          controller: _controller1, 
            
            
          decoration: InputDecoration(
            fillColor: HexColor("#d6e2de"),
            filled: true,
            
              
              enabledBorder: OutlineInputBorder(
                
                borderSide: BorderSide(color: Colors.black, width: 1), 
                borderRadius: BorderRadius.circular(8)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black, width: 2)
              )
              
            )
           
           
           ),
         ),

        if(ingridients_selceted == false) 
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
            padding: EdgeInsets.only(left: 13),
            child: Text( "Menge", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
         )
         ) ,  
          
        

         

        ingridients_selceted == true? 
        
        // condition true 
        Expanded(
        child: ListView.builder(
          itemCount: displayed_add_ingridients_to_meal.length,
          itemBuilder: (context, index) => ListTile(
            
            onTap: () {Ingridients_Selected_x(displayed_add_ingridients_to_meal[index].Ingridient_title!, );
                      FocusScope.of(context).unfocus();
             } ,
            title: Text(displayed_add_ingridients_to_meal[index].Ingridient_title!, style: TextStyle(color: Colors.white),),
          )
         )
         )

         //condition false 
        : Padding(
          
          padding: const EdgeInsets.all(8.0),
          child:Container(   
            child: Row( 
              children: [ 
            Expanded(
              flex: 3,
              child:TextField(
                keyboardType: TextInputType.number,
                controller: _controller2,
                focusNode: textfield2,
                decoration: InputDecoration(
                fillColor: HexColor("#d6e2de"),
                filled: true,
                
                
              
              enabledBorder: OutlineInputBorder(
                
                borderSide: BorderSide(color: Colors.black, width: 1), 
                borderRadius: BorderRadius.circular(8)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.black, width: 2)
              )
              
            )
             
             
              ),
               ),
               Expanded(
                flex: 1,
                child: Container(
                   width: MediaQuery.of(context).size.width, 
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration( color:HexColor("#d6e2de"),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
                  ), 
                child:TextButton(
                  
                  onPressed: () {
                  
                  Ingredient_amount_change(ingredients_amount);
                  
                    
                    
                  },
                  child: Text(ingredients_amount, style:TextStyle(color: Colors.black))
                  )
                  )
                ) 
                
               ]
               )
           )
        ),

       
        if (ingridients_selceted == false)  
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector( 
          onTap: () {
                  
                      
                       widget.containerHeight =  add_ingridients_to_meal_with_all(widget.containerHeight);
                       
                       
                     
                       
                  
                    
                
              },
          child: Container(
            width: MediaQuery.of(context).size.width, 
            height: MediaQuery.of(context).size.height / 9,
            decoration: BoxDecoration( color: HexColor("#d6e2de"),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              
                  ), 
            child: Icon(Icons.add),
              
            ),
          ),
           )
        
        
        
        

    
         
         
       ]

       

      ),
      )

    );
  }
}

