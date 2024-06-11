import "package:flutter/foundation.dart";
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
      """CREATE TABLE shoppingLists(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      name TEXT, 
      savedShoppingListsJson, Text
      ) """);
  }


  static Future<sql.Database> db() async {

    return sql.openDatabase(
      "db_meals6.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }
// Button --> create instance of a sql table
  static Future<int> createItem(String title, String description, String ingridientsJson, String spicesJson) async {
    final db = await SQLHelper.db();
    final data = {"title": title, "description": description, "ingridientsJson": ingridientsJson, "spicesJson": spicesJson};
    final id = await db.insert("items", data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id; 
  }

  static Future<int> createSavesShppongList(String name, String savedShoppingListsJson) async {
    final db = await SQLHelper.db();
    final data = {"name": name, "savedShoppingListsJson": savedShoppingListsJson};
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

  static Future<int> updateMeal(int id, String? title, String? description, String? ingridientsJson, String spicesJson) async {
    final db = await SQLHelper.db();
    final data = {"title": title, "description": description, "ingridientsJson": ingridientsJson, "spicesJson": spicesJson};
    final result = await db.update("items", data, where: "id = ?", whereArgs: [id]);
    return result;
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