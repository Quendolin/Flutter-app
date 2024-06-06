import "package:flutter/material.dart";
import "package:openfoodfacts/openfoodfacts.dart";



class Apicall extends StatefulWidget {
  const Apicall({super.key});
  

  @override
  State<Apicall> createState() => _ApicallState();
}

class _ApicallState extends State<Apicall> {
  

  Future<Product> fetchData() async { 
    final product = await OpenFoodAPIClient().searchProductByBarcode();
    return product;
  }
  @override
  Widget build(BuildContext context) {
    OpenFoodAPIConfiguration.globalUser = User(userId: "mahlzeit", password: "Mahlzeit123");
    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage> [OpenFoodFactsLanguage.GERMAN];
    
    return const Placeholder();
  }
}