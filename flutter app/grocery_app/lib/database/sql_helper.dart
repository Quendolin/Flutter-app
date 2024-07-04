import "package:flutter/foundation.dart";
import "package:grocery_app/meal_model.dart";
import "package:sqflite/sqflite.dart" as sql;


class SQLHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      title TEXT,
      description TEXT,
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
      Ingredient(id: 2, name: "Avocado"),
      Ingredient(id: 3, name: "Banane"),
      Ingredient(id: 4, name: "Basilikum"),
      Ingredient(id: 5, name: "Brot"),
      Ingredient(id: 6, name: "Butter"),
      Ingredient(id: 7, name: "Chili"),
      Ingredient(id: 8, name: "Eier"),
      Ingredient(id: 9, name: "Essig"),
      Ingredient(id: 10, name: "Fisch"),
      Ingredient(id: 11, name: "Garnele"),
      Ingredient(id: 12, name: "Gurke"),
      Ingredient(id: 13, name: "Hackfleisch"),
      Ingredient(id: 14, name: "Honig"),
      Ingredient(id: 15, name: "Joghurt"),
      Ingredient(id: 16, name: "Kartoffeln"),
      Ingredient(id: 17, name: "Käse"),
      Ingredient(id: 18, name: "Knoblauch"),
      Ingredient(id: 19, name: "Kräuter"),
      Ingredient(id: 20, name: "Lachs"),
      Ingredient(id: 21, name: "Lauch"),
      Ingredient(id: 22, name: "Limette"),
      Ingredient(id: 23, name: "Mandeln"),
      Ingredient(id: 24, name: "Mehl"),
      Ingredient(id: 25, name: "Milch"),
      Ingredient(id: 26, name: "Minze"),
      Ingredient(id: 27, name: "Nudeln"),
      Ingredient(id: 28, name: "Oliven"),
      Ingredient(id: 29, name: "Olivenöl"),
      Ingredient(id: 30, name: "Orange"),
      Ingredient(id: 31, name: "Paprika"),
      Ingredient(id: 32, name: "Parmesan"),
      Ingredient(id: 33, name: "Pfeffer"),
      Ingredient(id: 34, name: "Pilze"),
      Ingredient(id: 35, name: "Reis"),
      Ingredient(id: 36, name: "Rosmarin"),
      Ingredient(id: 37, name: "Salat"),
      Ingredient(id: 38, name: "Salz"),
      Ingredient(id: 39, name: "Schokolade"),
      Ingredient(id: 40, name: "Schweinefleisch"),
      Ingredient(id: 41, name: "Sellerie"),
      Ingredient(id: 42, name: "Senf"),
      Ingredient(id: 43, name: "Sojasoße"),
      Ingredient(id: 44, name: "Spinat")
  
    ];

    for (var i in list) {
      await database.insert("Ingredient", i.toMap());
    }
    
    
    
  }


  static Future<sql.Database> db() async {

    return sql.openDatabase(
      "db_meals15.db",
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
  static Future<int> createMeal(String title, String description, String ingridientsJson, String spicesJson) async {
    final db = await SQLHelper.db();
    final data = {"title": title, "description": description, "ingridientsJson": ingridientsJson, "spicesJson": spicesJson};
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

  static Future<int> updateMeal(int id, String? title, String? description, String? ingridientsJson, String spicesJson) async {
    final db = await SQLHelper.db();
    final data = {"title": title, "description": description, "ingridientsJson": ingridientsJson, "spicesJson": spicesJson};
    final result = await db.update("items", data, where: "id = ?", whereArgs: [id]);
    return result;
  }


  static Future<void> deleteSavedShoppingList(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("shoppingLists", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("something went wrong when deleting an item: $err");
    }
  }
  static Future<void> deleteMeal(int id) async {
    final db = await SQLHelper.db();
    try { 
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("something went wrong when deleting an item: $err");
    }
  }

}