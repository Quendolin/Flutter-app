

import "dart:convert";
import "dart:io";
import 'package:crypto/crypto.dart';
import "package:flutter/foundation.dart";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:grocery_app/main.dart";
import "package:hexcolor/hexcolor.dart";
// ignore: unused_import
import "package:sign_in_with_apple/sign_in_with_apple.dart";
import "package:supabase_flutter/supabase_flutter.dart";



// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.SignedIn, required this.sideBar});
  bool SignedIn;
  bool sideBar;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  googleSignIn() async {

  /// Web Client ID that you registered with Google Cloud.
  const webClientId = '825452009662-v2r45g8c01rf46t98jbt3lpc8ps7noo8.apps.googleusercontent.com';

                         
  /// iOS Client ID that you registered with Google Cloud.
  const iosClientId = '825452009662-srbqmpp6cmh7j5qs1hsupa5mvtcbgi24.apps.googleusercontent.com';

  // Google sign in on Android will work without providing the Android
  // Client ID registered on Google Cloud.
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

  if (accessToken == null) {
    throw 'No Access Token found.';
  }
  if (idToken == null) {
    throw 'No ID Token found.';
  }

  await supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
 
  if (widget.sideBar == true) {
    Navigator.pop(context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eingeloggt")));
  } else {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eingeloggt")));
  }
  
  } catch (err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error"), backgroundColor: Theme.of(context).colorScheme.error, duration: const Duration(milliseconds: 300)));
  }
  

   
                        
  }

  appleSignIn() async {
    

    if (Platform.isIOS) { 
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }


      
      await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce
      );

     

   } else {

     await supabase.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication, // Launch the auth screen in a new webview on mobile.
);
   }

     if (widget.sideBar == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eingeloggt"), duration: Duration(milliseconds: 300),));
      } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eingeloggt"), duration: Duration(milliseconds: 300)));
  }
    
  }

  TextEditingController _conPasswort = TextEditingController();
  TextEditingController _conEmail = TextEditingController();
  bool default_signIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("31473A"), 
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.7,
                  child: Image.asset("assets/images/Mahlzeit_Logo.png",))
                ),
            ),
             Align(
              
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left:40.0),
                child: default_signIn == true? Text( "Einloggen", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)) : Text("Registration", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white))
              )
              ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35, top: 10),
              child: Container(
                
                decoration: BoxDecoration(
                  color:  HexColor("31473A"),
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
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black, width: 0.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black, width: 1)
                    )
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35, top: 30),
              child: Container(
                // height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                  color: HexColor("31473A"),
                  border: Border.all(width: 1),
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
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 0.5)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 1)
                      )
                    ),
                  ),
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35, top: 30),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () async {
                  final email = _conEmail.text.trim();
                  final passwort = _conPasswort.text.trim();
                  await Future.delayed(Duration.zero);
                  
                  if (default_signIn == false) {
                    try {
                      await supabase.auth.signUp(
                      email: email, 
                      password: passwort,
                      emailRedirectTo: "io.supabase.flutterquickstart://login-callback"
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eingeloggt"), duration: Duration(milliseconds: 300)));
                        if (widget.sideBar) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }

                        
                       
                      }
                    } on AuthException catch (error) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message), backgroundColor: Theme.of(context).colorScheme.error, duration: const Duration(milliseconds: 300)));
                   }
                  } else {
                      try {
                        await supabase.auth.signInWithPassword(
                          email: email,
                          password: passwort
                        );
                        
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Eingeloggt"), duration: Duration(milliseconds: 300)));
                         if (widget.sideBar) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      } on AuthException catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message), duration: Duration(milliseconds: 300)));
                        
                      } 
                    
                  }
                  
                  
                 
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width ,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15),
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
                    child: default_signIn == false ? Text("schon einen Account?", style: TextStyle(color: Colors.white),) : Text("Keinen Account?", style: TextStyle(color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          default_signIn = !default_signIn;  
                        });
                         
                        
                      },
                      child: default_signIn == false ? Text("Einloggen", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white )) : Text("Registration", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                    ),
                  )
                ],
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     IconButton(
                        onPressed: () {
                          
                          
                            googleSignIn();
                     
                          
            
                        
                        }, icon: Image.asset("assets/images/ios_dark_sq_na@1x.png")),
                    
                     
                       IconButton(
                        onPressed: () {
                          setState(() {
                            appleSignIn();
                          });
                          
                        }, 
                        icon: Image.asset("assets/images/appleid_button@1x.png")),
                     
                  ],
                ),
              )

            
            
          ],
      ),
    );
  }
}