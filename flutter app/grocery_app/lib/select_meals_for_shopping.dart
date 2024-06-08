import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class select_meals_for_shopping extends StatefulWidget {
  final List callback; 
  final Function getItem;
  const select_meals_for_shopping({super.key, required this.callback, required this.getItem});

  @override
  State<select_meals_for_shopping> createState() => _select_meals_for_shoppingState();
}

class _select_meals_for_shoppingState extends State<select_meals_for_shopping> {

   select_meal(var data) async {
    List<Map> list = await data;
    var dbItem = list.first;
   // list = json.decode(list[0]["title"]);
    //selected_meals_list = list.map((instance) {String id = list["id"] }).toList();
    var resid = dbItem["id"];
    print(resid);
    
    
  }

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
              itemBuilder: (context, index) => Container(
                child: ListTile(
                  title: selected_meals_list[index]["title"],
                ),
              ),
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HexColor("#d6e2de"),
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12)
                ),
                
                height: MediaQuery.of(context).size.height /15,
                width: MediaQuery.of(context).size.width /5,
                child: Text("Fertig", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}