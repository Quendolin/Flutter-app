import "package:flutter/material.dart";
import "package:hexcolor/hexcolor.dart";

class SideBar extends StatelessWidget {
  const SideBar({super.key});

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
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  border: Border.all()
                ),
                
                child: ListView(
                  
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Divider(
                        color: HexColor("#EDF4F2"),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      leading: Icon(Icons.settings, color: HexColor("#EDF4F2")),
                      title: Text("Einstellungen", style: TextStyle(color: HexColor("#EDF4F2")),),
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