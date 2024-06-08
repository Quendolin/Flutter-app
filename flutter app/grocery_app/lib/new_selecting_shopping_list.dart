import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

class selecting_shoppingcard extends StatefulWidget {
  const selecting_shoppingcard({super.key, required this.new_});
  final bool new_;
  @override
  State<selecting_shoppingcard> createState() => _selecting_shoppingcardState();
}

class _selecting_shoppingcardState extends State<selecting_shoppingcard> {

  //late bool existing_shopping_list;
  bool first = true; 
  bool button1 = true;
  final PageController _pageController = PageController();
  @override
 
  Widget build(BuildContext context) {
    
    return PopScope(
      canPop: false,
      child: Scaffold(  
          appBar: AppBar(
            backgroundColor: HexColor("#31473A"),
            title: Text("Mahlzeiten", style: TextStyle(color: HexColor("#EDF4F2"))),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                if (widget.new_ == false) {Navigator.pop(context);}
              }, 
            icon: Icon(Icons.arrow_back, color: Colors.white,)) ,
            actions: <Widget> [
              
              IconButton(
                icon: Icon(Icons.search), 
                onPressed: () {},
                 ), 
               ],
           ),
          backgroundColor: HexColor("31473A"),
          body: Column( children: [
            
            const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text("Einkaufliste", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
              )
             ),
             
            
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()
                      ),
                    child: PageView(
                      controller: _pageController,
                      children: [
                        ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) => const ListTile(
                          
                            title: Text("data"),
                          ),
                      ),
                        ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) => const ListTile(
                            title: Text("sdadas"),
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
                    border: Border.all()
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

