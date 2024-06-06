import 'package:flutter/material.dart';
import 'package:grocery_app/meal_model.dart';
import 'package:hexcolor/hexcolor.dart';

class add_spcies extends StatefulWidget {
  final Function add;
  const add_spcies({super.key, required this.add});

  @override
  State<add_spcies> createState() => _add_spciesState();
}

class _add_spciesState extends State<add_spcies> {

  updateList(String value) {
    setState(() {
      spices_add1 = spices_add.where((element) => element.spices_title!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  TextEditingController spice_con = TextEditingController();
  bool spices_selected = false;
  List<spices> spices_add1 = List.from(spices_add); 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: HexColor("31473A"),
      body: Column(
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
              widget.add(spice_con.text);
              spices_selected = true;
              Navigator.pop(context);
            },
            onChanged: (value) => updateList(value),
            onTap: () {
               
            },
            
            autofocus: true,
            controller: spice_con,

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
           spices_selected == false?
            Expanded(
              child: ListView.builder(
                itemCount: spices_add1.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    spice_con.text = spices_add1[index].spices_title!;
                    widget.add(spice_con.text);
                    Navigator.pop(context);
                  },
                  title: Text(spices_add1[index].spices_title!, style: const TextStyle(color: Colors.white))
            
            )
           ) 
           )  : 
            Container()
            
           
          
           
           
          
        ],
      ),
    );
  }
}