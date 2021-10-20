import 'package:sqflite/sqflite.dart' as sql;
class SQLHelper {
   static final DATABASE_NAME = "tvdb";
   static final VERSTION = 1;
   static final TABLE_NAME = "citems";

   static final COL_1 = "id";
   static final COL_2 = "title";
   static final COL_3 = "link";
   static final COL_4 = "logo";
   static final COL_5 = "createdAt";

  static Future<void> createTables(sql.Database database) async {
    String CREATE_TABLE_QUERY = "CREATE TABLE "
        + TABLE_NAME + "("
        + COL_1 + " INTEGER PRIMARY KEY AUTOINCREMENT ,"
        + COL_2 + " TEXT,"
        + COL_3 + " TEXT,"
        + COL_4 + " TEXT,"
        + COL_5 + " TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP"+ ")";

    await database.execute(CREATE_TABLE_QUERY);

   /* await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);*/

  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      DATABASE_NAME,
      version: VERSTION,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String link,String? logo) async {
    final db = await SQLHelper.db();

    final data = {COL_2: title, COL_3: link,COL_4: logo};
    final id = await db.insert(TABLE_NAME, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query(TABLE_NAME, orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query(TABLE_NAME, where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String title, String? descrption) async {
    final db = await SQLHelper.db();

    final data = {
      COL_2: title,
      COL_3: descrption,
      COL_5: DateTime.now().toString()
    };

    final result = await db.update(TABLE_NAME, data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(TABLE_NAME, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when deleting an item: $err");
    }
  }
}