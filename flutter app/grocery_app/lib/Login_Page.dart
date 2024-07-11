import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:grocery_app/main.dart";
import "package:hexcolor/hexcolor.dart";
import "package:supabase_flutter/supabase_flutter.dart";


class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.SignedIn});
  bool SignedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _conPasswort = TextEditingController();
  TextEditingController _conEmail = TextEditingController();
  bool default_signIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // HexColor("#d6e2de"), //HexColor("31473A")///,
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Image.asset("assets/images/Mahlzeit_Logo-removebg-preview.png",)
                ),
            ),
             Align(
              
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left:40.0),
                child: default_signIn == true? Text( "Einloggen", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)) : Text("Registration", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
              )
              ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35, top: 10),
              child: Container(
                height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(18)
                ),
                child: TextField(
                  controller: _conEmail,
                  decoration: InputDecoration(
                    fillColor:  HexColor("#d6e2de"),
                    hintText: "e-mail",
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.black, width: 0.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.black, width: 1)
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35, top: 30),
              child: Container(
                height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(18)
                ),
                child: TextField(
                  obscureText: true,
                  controller: _conPasswort,
                  decoration: InputDecoration(
                    
                    fillColor:  HexColor("#d6e2de"),
                    
                    hintText:"passwort",
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.black, width: 0.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(color: Colors.black, width: 1)
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35, top: 30),
              child: InkWell(
                onTap: () async {
                  final email = _conEmail.text.trim();
                  final passwort = _conPasswort.text.trim();
                  await Future.delayed(Duration.zero);
                  
                  if (default_signIn == false) {
                    try {
                      await supabase.auth.signUp(
                      email: email, 
                      password: passwort,
                      emailRedirectTo: "io.supabase.flutterquickstart://login-callback/"
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verifizierungsmail gesendet")));
                        Navigator.pop(context);
                      }
                    } on AuthException catch (error) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message), backgroundColor: Theme.of(context).colorScheme.error,));
                   }
                  } else {
                      try {
                        await supabase.auth.signInWithPassword(
                          email: email,
                          password: passwort
                        );
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Succelfull")));
                        Navigator.pop(context);
                      } on AuthException catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
                      } 
                    
                  }
                  
                  Navigator.pop(context);
                 
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width ,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(18),
                    color: HexColor("#d6e2de")
                  ),
                  child: Icon(Icons.check_outlined),
                ),
              ),
            ),
            
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all( 5),
                    child: default_signIn == false ? Text("schon einen Account?") : Text("Keinen Account?"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          default_signIn = !default_signIn;  
                        });
                         
                        
                      },
                      child: default_signIn == false ? Text("Einloggen", style: TextStyle(fontWeight: FontWeight.bold)) : Text("Registration", style: TextStyle(fontWeight: FontWeight.bold))
                    ),
                  )
                ],
              ),

            
            
          ],
      ),
    );
  }
}