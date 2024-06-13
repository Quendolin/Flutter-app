



class MealModel{
  final int? id; 
  final String? title;
  
   MealModel( 
    
    this.id,
    this.title
  );
 }

 

List<MealModel> main_meal_list = [
      MealModel(0, "KEKW"),
      
  ];

  class spices {
    String spices_title;
    spices(
     {required this.spices_title}
    );
  }

  List<spices> spices_add = [
    spices(spices_title: "curry"), 
   
    
  ];


  class Ingredient { 
    final int id; 
    final String name; 
    
    Ingredient({
      required this.id,
      required this.name
    });
      
    Map<String, dynamic> toMap() {
      return {
        "id": id, 
        "name": name
      };
    }
    

  }




class add_ingridients_list {
  String Ingridient_name;
  String Ingridient_mass; 
  String Ingridient_mass_unit;
  

  add_ingridients_list({ 
    required this.Ingridient_name,
    required this.Ingridient_mass, 
    required this.Ingridient_mass_unit
   }
  );
} 

  class selectedMeal {
    String meal_title;
    int meal_id;
    int meal_size; 

    selectedMeal({
      required this.meal_title,
      required this.meal_id,
      required this.meal_size
    });

    
  }


  class shoppingIngredient {
    String Ingridient_name;
    String Ingridient_mass; 
    String Ingridient_mass_unit;
    bool crossedOff; 
  

    shoppingIngredient({ 
    required this.Ingridient_name,
    required this.Ingridient_mass, 
    required this.Ingridient_mass_unit,
    required this.crossedOff
   }
  );
  }


  
  

