import "package:flutter/foundation.dart";
import "package:grocery_app/meal_model.dart";
import "package:sqflite/sqflite.dart" as sql;


class SQLHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      title TEXT,
      ingridientsJson TEXT,
      spicesJson TEXT
      ) """
    );
  
    await database.execute(
      """CREATE TABLE shoppingLists(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      name TEXT, 
      savedShoppingListsJson TEXT,
      originalMealListFromShoppingListJson TEXT,
      spicesOFShoppingListJson TEXT
      ) """
    );

    

    await database.execute(
      """CREATE TABLE deleteMealsInCloud(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      meal_id INTEGER
      )
      """
    );

    await database.execute(
       """CREATE TABLE deleteShoppingListsInCloud(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      list_id INTEGER
      )
      """
    );

    await database.execute(
      """CREATE TABLE Ingredient(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT
      
      )
      """
    );

    await database.execute(
      """CREATE INDEX index_name ON Ingredient(name);"""
    );

    List<Ingredient> list = [

      Ingredient(id: 1, name: "Apfel"),
      Ingredient(id: 2, name: "Ananas"),
      Ingredient(id: 3, name: "Aubergine"),
      Ingredient(id: 4, name: "Artischocke"),
      Ingredient(id: 5, name: "Avocado"),
      Ingredient(id: 6, name: "Ahornsirup"),
      Ingredient(id: 7, name: "Apfelessig"),
      Ingredient(id: 8, name: "Amaranth"),
      Ingredient(id: 9, name: "Aprikose"),
      Ingredient(id: 10, name: "Ayran"),
      Ingredient(id: 11, name: "Banane"),
      Ingredient(id: 12, name: "Birne"),
      Ingredient(id: 13, name: "Bohnen"),
      Ingredient(id: 14, name: "Brokkoli"),
      Ingredient(id: 15, name: "Blumenkohl"),
      Ingredient(id: 16, name: "Basilikum"),
      Ingredient(id: 17, name: "Butter"),
      Ingredient(id: 18, name: "Buttermilch"),
      Ingredient(id: 19, name: "Balsamico-Essig"),
      Ingredient(id: 20, name: "Bulgur"),
      Ingredient(id: 21, name: "Cranberry"),
      Ingredient(id: 22, name: "Chili"),
      Ingredient(id: 23, name: "Champignons"),
      Ingredient(id: 24, name: "Couscous"),
      Ingredient(id: 25, name: "Chiasamen"),
      Ingredient(id: 26, name: "Curry"),
      Ingredient(id: 27, name: "Creme Fraiche"),
      Ingredient(id: 28, name: "Cashewnüsse"),
      Ingredient(id: 29, name: "Camu-Camu"),
      Ingredient(id: 30, name: "Ceylon-Zimt"),
      Ingredient(id: 31, name: "Datteln"),
      Ingredient(id: 32, name: "Dill"),
      Ingredient(id: 33, name: "Dinkelmehl"),
      Ingredient(id: 34, name: "Dijonsenf"),
      Ingredient(id: 35, name: "Dorade"),
      Ingredient(id: 36, name: "Drachenfrucht"),
      Ingredient(id: 37, name: "Dinkel"),
      Ingredient(id: 38, name: "Dunkle Schokolade"),
      Ingredient(id: 39, name: "Dattelsirup"),
      Ingredient(id: 40, name: "Durian"),
      Ingredient(id: 41, name: "Erdbeeren"),
      Ingredient(id: 42, name: "Ei"),
      Ingredient(id: 43, name: "Erdnüsse"),
      Ingredient(id: 44, name: "Essig"),
      Ingredient(id: 45, name: "Edamame"),
      Ingredient(id: 46, name: "Eierlikör"),
      Ingredient(id: 47, name: "Erdmandel"),
      Ingredient(id: 48, name: "Estragon"),
      Ingredient(id: 49, name: "Endivie"),
      Ingredient(id: 50, name: "Echter Koriander"),
      Ingredient(id: 51, name: "Feigen"),
      Ingredient(id: 52, name: "Fenchel"),
      Ingredient(id: 53, name: "Fisch"),
      Ingredient(id: 54, name: "Feta"),
      Ingredient(id: 55, name: "Fladenbrot"),
      Ingredient(id: 56, name: "Feldsalat"),
      Ingredient(id: 57, name: "Fleisch"),
      Ingredient(id: 58, name: "Farfalle"),
      Ingredient(id: 59, name: "Frühlingszwiebel"),
      Ingredient(id: 60, name: "Forelle"),
      Ingredient(id: 61, name: "Gurke"),
      Ingredient(id: 62, name: "Grapefruit"),
      Ingredient(id: 63, name: "Garnelen"),
      Ingredient(id: 64, name: "Grünkohl"),
      Ingredient(id: 65, name: "Granatapfel"),
      Ingredient(id: 66, name: "Gorgonzola"),
      Ingredient(id: 67, name: "Gelatine"),
      Ingredient(id: 68, name: "Gouda"),
      Ingredient(id: 69, name: "Grüner Spargel"),
      Ingredient(id: 70, name: "Ghee"),
      Ingredient(id: 71, name: "Honig"),
      Ingredient(id: 72, name: "Hackfleisch"),
      Ingredient(id: 73, name: "Haferflocken"),
      Ingredient(id: 74, name: "Hähnchen"),
      Ingredient(id: 75, name: "Hefe"),
      Ingredient(id: 76, name: "Himbeeren"),
      Ingredient(id: 77, name: "Hirse"),
      Ingredient(id: 78, name: "Holunder"),
      Ingredient(id: 79, name: "Hüttenkäse"),
      Ingredient(id: 80, name: "Hühnerbrühe"),
      Ingredient(id: 81, name: "Ingwer"),
      Ingredient(id: 82, name: "Iberico-Schinken"),
      Ingredient(id: 83, name: "Irish Coffee"),
      Ingredient(id: 84, name: "Ingweröl"),
      Ingredient(id: 85, name: "Ingwerpulver"),
      Ingredient(id: 86, name: "Indische Gewürze"),
      Ingredient(id: 87, name: "Irish Stew"),
      Ingredient(id: 88, name: "Ingwersirup"),
      Ingredient(id: 89, name: "Ingwer-Tee"),
      Ingredient(id: 90, name: "Instant-Kaffee"),
      Ingredient(id: 91, name: "Joghurt"),
      Ingredient(id: 92, name: "Johannisbeeren"),
      Ingredient(id: 93, name: "Jasminreis"),
      Ingredient(id: 94, name: "Jakobsmuscheln"),
      Ingredient(id: 95, name: "Jalapeños"),
      Ingredient(id: 96, name: "Jodsalz"),
      Ingredient(id: 97, name: "Johannisbrotkernmehl"),
      Ingredient(id: 98, name: "Jackfrucht"),
      Ingredient(id: 99, name: "Jägermeister"),
      Ingredient(id: 100, name: "Jalapeño-Sauce"),
      Ingredient(id: 101, name: "Kirschen"),
      Ingredient(id: 102, name: "Käse"),
      Ingredient(id: 103, name: "Karotten"),
      Ingredient(id: 104, name: "Kokosmilch"),
      Ingredient(id: 105, name: "Kichererbsen"),
      Ingredient(id: 106, name: "Kartoffeln"),
      Ingredient(id: 107, name: "Kohl"),
      Ingredient(id: 108, name: "Kürbis"),
      Ingredient(id: 109, name: "Kabeljau"),
      Ingredient(id: 110, name: "Kapern"),
      Ingredient(id: 111, name: "Lauch"),
      Ingredient(id: 112, name: "Linsen"),
      Ingredient(id: 113, name: "Limetten"),
      Ingredient(id: 114, name: "Lachs"),
      Ingredient(id: 115, name: "Leberwurst"),
      Ingredient(id: 116, name: "Lammfleisch"),
      Ingredient(id: 117, name: "Litschi"),
      Ingredient(id: 118, name: "Limonade"),
      Ingredient(id: 119, name: "Lorbeer"),
      Ingredient(id: 120, name: "Lebkuchen"),
      Ingredient(id: 121, name: "Möhren"),
      Ingredient(id: 122, name: "Milch"),
      Ingredient(id: 123, name: "Mandeln"),
      Ingredient(id: 124, name: "Mehl"),
      Ingredient(id: 125, name: "Mangos"),
      Ingredient(id: 126, name: "Maronen"),
      Ingredient(id: 127, name: "Mohn"),
      Ingredient(id: 128, name: "Müsli"),
      Ingredient(id: 129, name: "Meerrettich"),
      Ingredient(id: 130, name: "Mozzarella"),
      Ingredient(id: 131, name: "Nüsse"),
      Ingredient(id: 132, name: "Nudeln"),
      Ingredient(id: 133, name: "Nektarinen"),
      Ingredient(id: 134, name: "Nougat"),
      Ingredient(id: 135, name: "Nashi-Birne"),
      Ingredient(id: 136, name: "Nori-Algen"),
      Ingredient(id: 137, name: "Nelken"),
      Ingredient(id: 138, name: "Nussmus"),
      Ingredient(id: 139, name: "Naan-Brot"),
      Ingredient(id: 140, name: "Nutella"),
      Ingredient(id: 141, name: "Orangen"),
      Ingredient(id: 142, name: "Olivenöl"),
      Ingredient(id: 143, name: "Oregano"),
      Ingredient(id: 144, name: "Okraschoten"),
      Ingredient(id: 145, name: "Oliven"),
      Ingredient(id: 146, name: "Orangensaft"),
      Ingredient(id: 147, name: "Orangenmarmelade"),
      Ingredient(id: 148, name: "Ochsenschwanz"),
      Ingredient(id: 149, name: "Orangenschale"),
      Ingredient(id: 150, name: "Orangenblütenwasser"),
      Ingredient(id: 151, name: "Paprika"),
      Ingredient(id: 152, name: "Petersilie"),
      Ingredient(id: 153, name: "Pflaume"),
      Ingredient(id: 154, name: "Pistazien"),
      Ingredient(id: 155, name: "Preiselbeeren"),
      Ingredient(id: 156, name: "Pfeffer"),
      Ingredient(id: 157, name: "Peperoni"),
      Ingredient(id: 158, name: "Pomelo"),
      Ingredient(id: 159, name: "Pastinake"),
      Ingredient(id: 160, name: "Parmesan"),
      Ingredient(id: 161, name: "Quinoa"),
      Ingredient(id: 162, name: "Quark"),
      Ingredient(id: 163, name: "Quitte"),
      Ingredient(id: 164, name: "Radieschen"),
      Ingredient(id: 165, name: "Rindfleisch"),
      Ingredient(id: 166, name: "Rosmarin"),
      Ingredient(id: 167, name: "Rote Bete"),
      Ingredient(id: 168, name: "Ricotta"),
      Ingredient(id: 169, name: "Räucherlachs"),
      Ingredient(id: 170, name: "Rucola"),
      Ingredient(id: 171, name: "Rotkohl"),
      Ingredient(id: 172, name: "Rosinen"),
      Ingredient(id: 173, name: "Ravioli"),
      Ingredient(id: 174, name: "Spinat"),
      Ingredient(id: 175, name: "Süßkartoffel"),
      Ingredient(id: 176, name: "Sellerie"),
      Ingredient(id: 177, name: "Spargel"),
      Ingredient(id: 178, name: "Schalotten"),
      Ingredient(id: 179, name: "Schnittlauch"),
      Ingredient(id: 180, name: "Salbei"),
      Ingredient(id: 181, name: "Schinken"),
      Ingredient(id: 182, name: "Sauerrahm"),
      Ingredient(id: 183, name: "Sesam"),
      Ingredient(id: 184, name: "Tomaten"),
      Ingredient(id: 185, name: "Thymian"),
      Ingredient(id: 186, name: "Tofu"),
      Ingredient(id: 187, name: "Trauben"),
      Ingredient(id: 188, name: "Trüffel"),
      Ingredient(id: 189, name: "Tamarinde"),
      Ingredient(id: 190, name: "Topinambur"),
      Ingredient(id: 191, name: "Tortellini"),
      Ingredient(id: 192, name: "Tintenfisch"),
      Ingredient(id: 193, name: "Teff"),
      Ingredient(id: 194, name: "Udon-Nudeln"),
      Ingredient(id: 195, name: "Ungarische Salami"),
      Ingredient(id: 196, name: "Unagi"),
      Ingredient(id: 197, name: "Umeboshi"),
      Ingredient(id: 198, name: "Urdbohnen"),
      Ingredient(id: 199, name: "Umami-Paste"),
      Ingredient(id: 200, name: "Vanille"),
      Ingredient(id: 201, name: "Vanilleschote"),
      Ingredient(id: 202, name: "Vanillezucker"),
      Ingredient(id: 203, name: "Vollmilch"),
      Ingredient(id: 204, name: "Vollkornmehl"),
      Ingredient(id: 205, name: "Vollkornnudeln"),
      Ingredient(id: 206, name: "Vollkornreis"),
      Ingredient(id: 207, name: "Vollrohrzucker"),
      Ingredient(id: 208, name: "Vogelmiere"),
      Ingredient(id: 209, name: "Vollkornbrot"),
      Ingredient(id: 210, name: "Wassermelone"),
      Ingredient(id: 211, name: "Walnüsse"),
      Ingredient(id: 212, name: "Weintrauben"),
      Ingredient(id: 213, name: "Weißkohl"),
      Ingredient(id: 214, name: "Weizenmehl"),
      Ingredient(id: 215, name: "Wachteleier"),
      Ingredient(id: 216, name: "Wacholderbeeren"),
      Ingredient(id: 217, name: "Wirsing"),
      Ingredient(id: 218, name: "Waldmeister"),
      Ingredient(id: 219, name: "Wasabi"),
      Ingredient(id: 220, name: "Xanthan"),
      Ingredient(id: 221, name: "Xylit"),
      Ingredient(id: 222, name: "Xeres-Essig"),
      Ingredient(id: 223, name: "Yamswurzel"),
      Ingredient(id: 224, name: "Yoghurt"),
      Ingredient(id: 225, name: "Yuzu"),
      Ingredient(id: 226, name: "Zucchini"),
      Ingredient(id: 227, name: "Zwiebel"),
      Ingredient(id: 228, name: "Zitronen"),
      Ingredient(id: 229, name: "Zucker"),
      Ingredient(id: 230, name: "Zimt"),
      Ingredient(id: 231, name: "Ziegenkäse"),
      Ingredient(id: 232, name: "Zitronengras"),
      Ingredient(id: 233, name: "Zitronenmelisse"),
      Ingredient(id: 234, name: "Zander"),
      Ingredient(id: 235, name: "Zuckerrüben")
  
    ];

    for (var i in list) {
      await database.insert("Ingredient", i.toMap());
    }
    
    
    
  }


  static Future<sql.Database> db() async {

    return sql.openDatabase(
      "db_meals18.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }

  Future<List<Ingredient>> searchIngredient(String query) async {
    final db = await SQLHelper.db();
    
    final List<Map<String, dynamic>> maps = await db.query("Ingredients", where: "name LIKE ?", whereArgs: ["%$query%"], limit: 15);
    return List.generate(maps.length, (index) {
      return Ingredient(
        id: maps[index]["id"],
        name: maps[index]["name"]
        );
    });
  }

// Button --> create instance of a sql table
  static Future<int> createMeal(String title, String ingridientsJson, String spicesJson) async {
    final db = await SQLHelper.db();
    final data = {"title": title, "ingridientsJson": ingridientsJson, "spicesJson": spicesJson};
    final id = await db.insert("items", data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id; 
  }

  static Future<int> createSavesShppongList(String name, String savedShoppingListsJson, String originalMealListFromShoppingListJson, String spicesOFShoppingListJson ) async {
    final db = await SQLHelper.db();
    final data = {"name": name, "savedShoppingListsJson": savedShoppingListsJson, "originalMealListFromShoppingListJson": originalMealListFromShoppingListJson, "spicesOFShoppingListJson": spicesOFShoppingListJson };
    final id = await db.insert("shoppingLists", data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id; 
  }

  // initializing at the start 
  static Future<List<Map<String, dynamic>>> getAllMeals() async {
    final db = await SQLHelper.db();
    return db.query("items", orderBy: "id");
  }
  
   // initializing at the start 
  static Future<List<Map<String, dynamic>>> getAllsavedShoppingLists() async {
    final db = await SQLHelper.db();
    return db.query("shoppingLists", orderBy: "id");
  }

  // initializing at the start


  static Future<List<Map<String, dynamic>>> getAllDeleteMealWaitingRoom() async {
    final db = await SQLHelper.db();
    return db.query("deleteMealsInCloud", orderBy: "id");
  }




  // initializing at the start 
 
  static Future<List<Map<String, dynamic>>> getAllDeleteShoppingListsWaitingRoom() async {
    final db = await SQLHelper.db();
    return db.query("deleteShoppingListsInCloud", orderBy: "id");
  }


  
  
  static Future<List<Map<String, dynamic>>> getOneMeal(int id) async {
    final db = await SQLHelper.db();
    return db.query("items", where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getOneSavedShoppingList(int id) async {
    final db = await SQLHelper.db();
    return db.query("shoppingLists", where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateSavedShoppingList(int id, String name, String savedShoppingListsJson, String originalMealListFromShoppingListJson, String spicesOFShoppingListJson) async {
    final db = await SQLHelper.db();
    final data = {"name": name, "savedShoppingListsJson": savedShoppingListsJson, "originalMealListFromShoppingListJson": originalMealListFromShoppingListJson, "spicesOFShoppingListJson": spicesOFShoppingListJson}; 
    final result = await db.update("shoppingLists", data, where: "id = ?", whereArgs: [id]);
    return result; 
  }

  static Future<int> updateMeal(int id, String? title, String? ingridientsJson, String spicesJson) async {
    final db = await SQLHelper.db();
    final data = {"title": title, "ingridientsJson": ingridientsJson, "spicesJson": spicesJson};
    final result = await db.update("items", data, where: "id = ?", whereArgs: [id]);
    return result;
  }


  static Future<void> deleteSavedShoppingList(int id) async {
    final db = await SQLHelper.db();

    try {
      final data = {"list_id": id};
      await db.insert("deleteShoppingListsInCloud", data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    } catch (err) {
      debugPrint("something went wrong when deleting an item: $err");
    }


    try {
      await db.delete("shoppingLists", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("something went wrong when deleting an item: $err");
    }

  }
  static Future<void> deleteMeal(int id) async {
    final db = await SQLHelper.db();

    try {
      final data = {"meal_id": id};
      await db.insert("deleteMealsInCloud", data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      
    } catch (err) {
      debugPrint("something went wrong when deleting an item: $err");
    }

    try { 
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("something went wrong when deleting an item: $err");
    }
  }

}