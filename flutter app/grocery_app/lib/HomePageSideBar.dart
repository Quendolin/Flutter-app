import "package:flutter/material.dart";
import "package:hexcolor/hexcolor.dart";

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.isLoggedIn});
  final bool isLoggedIn;
  @override
  
  Widget build(BuildContext context) {
    
    return Drawer(
      child: Material(
        color: HexColor("#31473A"),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 1 - 16,
                decoration: BoxDecoration(
                  border: Border.all()
                ),
                
                child: ListView(
                  
                  children: [
                    // header profile
                     ListTile(
                      
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                      title: isLoggedIn == true ? Column(
                        children: [
                          Text("Vor und Nachname", style: TextStyle(color: HexColor("#EDF4F2"), fontSize: 20),),
                          Text("emailadresse", style: TextStyle(color: HexColor("#EDF4F2"), ))
                        ],
                      ) : IconButton(
                            onPressed: () {
                              
                            },
                        icon:
                        Text("Anmelden", style: TextStyle(color: HexColor("#EDF4F2"), fontSize: 20),),
                    )),

                    // devider 
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      
                        child: Divider(
                          color: HexColor("#EDF4F2"),
                        ),
                      
                    ),

                    // settings usw. 
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      leading: Icon(Icons.settings, color: HexColor("#EDF4F2")),
                      title: Text("Account", style: TextStyle(color: HexColor("#EDF4F2")),),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}