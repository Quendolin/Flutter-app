import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:grocery_app/Login_Page.dart";
import "package:grocery_app/main.dart";
import "package:hexcolor/hexcolor.dart";


class SideBar extends StatefulWidget {
  const SideBar({super.key, });
  

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isLoggedIn = false;
  String email = "";
  @override
  
  void initState() {
    super.initState();
    checkAccountStatus();
    
  }
  checkAccountStatus() {
    final session = supabase.auth.currentSession;
    session == null ? isLoggedIn = false : isLoggedIn = true;
    session != null ? email = supabase.auth.currentUser!.email.toString() : null;
    
    
  }

  @override
  Widget build(BuildContext context) {

    signOut() async {
      var googleSignedIn = await GoogleSignIn().isSignedIn();
      if  (googleSignedIn) await GoogleSignIn().signOut();
      await supabase.auth.signOut();
      
        isLoggedIn = false; 
      
      
    }

    
   
   
    
    return Drawer(
      child: Material(
        color: HexColor("#31473A"),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                  
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
                           Text("Angemeldet mit", style: TextStyle(color: HexColor("#EDF4F2"), fontSize: 10)),
                           Text(email, style: TextStyle(color: HexColor("#EDF4F2"), fontSize: 18))
                        ],
                      ) : IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(SignedIn: false, sideBar: true)));
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
                    ),
                     isLoggedIn == true ? ListTile(
                      onTap: () => 
                        showDialog(
                          context: context, 
                          builder: (context) =>   AlertDialog(
                            title: const Text("Von deinem Konto Abmelden?", style: TextStyle(fontSize: 20) ,),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        signOut();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } ,
                                      child: Container(
                                        decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Abmelden", style: TextStyle(fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                padding: const EdgeInsets.only(left:20),
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Abbrechen", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    ),
                                ),
                              )
                                ],
                              ),
                              
                            ],
                          )),
                        
                      
                      leading: const Opacity(
                        opacity: 0,
                        child: Icon(Icons.check)),
                      title: Text("Abmelden", style: TextStyle(color: HexColor("#EDF4F2") ),),
                    ) : ListTile(
                      leading: const Opacity(
                        opacity: 0,
                        child: Icon(Icons.check)),
                      title: Text("Anmelden", style: TextStyle(color: HexColor("#EDF4F2") )),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Image.asset("assets/images/Mahlzeit_Logo.png"))
          ],
        ),
      ),
    );
  }
}


