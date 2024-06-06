import 'package:flutter/material.dart';
import 'package:grocery_app/meal_model.dart';
// ignore: unused_import
import 'package:sizer/sizer.dart';

class search_page_meal extends StatefulWidget {
  const search_page_meal({super.key});

  @override
  State<search_page_meal> createState() => _search_page_meal();
}

class _search_page_meal extends State<search_page_meal> {

  

  List<MealModel> displayed_search_meal_list = List.from(main_meal_list);

  void updateList(String value) {

    setState(() {
      displayed_search_meal_list = main_meal_list.where((element) => element.title!.toLowerCase().contains(value.toLowerCase())).toList();
    },
   );
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       
  



    
    body:Column(  
    children: [

    
    SizedBox(
      
      width: MediaQuery.of(context).size.width ,
      height: MediaQuery.of(context).size.height / 14,
    ),

      Container(
        color: Colors.orange,
        width: MediaQuery.of(context).size.width, 
        height: MediaQuery.of(context).size.height / 14,
      
        child: Row( 
        
        children:  [ 
          
           
      
        Expanded(
          
          flex: 5,
        child:TextField(
          onChanged: (value) => updateList(value),
        style: TextStyle(color: Colors.black, ),
        autofocus: true,
        
        
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.amber,
          border: OutlineInputBorder(
            borderRadius:BorderRadius.circular(8),
            borderSide: BorderSide.none
        ),
          hintText: "Search"
        ),
      ),
      
       ),
       Expanded(
        child:Container( 
          decoration: BoxDecoration(
            color: Colors.orange,
            
            
          
          
            
          ),
          
        child:IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          
        ) ,
         )
       )
     ]
      ),
     ),
     SizedBox(
      height: MediaQuery.of(context).size.height / 40,
      
      
     ),
     Expanded(
      child: ListView.builder(
        itemCount: displayed_search_meal_list.length,
        itemBuilder: (context, index) => ListTile(
          contentPadding: EdgeInsets.all(10),
          //leading: Image(image: AssetImage(displayed_search_meal_list[index].meal_image!)),
          title: Text(displayed_search_meal_list[index].title!),
          //subtitle: Text("${displayed_search_meal_list[index].meal_time!} min" ),


        ) 


      )
      )
    ],
    
    )
 );
}
}


