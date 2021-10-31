import 'package:flutter_sqflite_flight/flight.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "cardb.db";
  static final _databaseVersion = 2;
  static final table = 'cars_table';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnDist = 'dist';
  static final columnDays = 'days';
  static final columnDate1 = 'firstDate';
  static final columnDate2 = 'secondDate';

// make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
// only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
// lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

// this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

// SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $table (
$columnId INTEGER PRIMARY KEY AUTOINCREMENT,
$columnName TEXT NOT NULL,
$columnDist TEXT  NOT NULL,
$columnDays INTEGER  NOT NULL,
$columnDate1 TEXT NOT NULL,
$columnDate2 TEXT NOT NULL

)
''');
  }

// Helper methods
// Inserts a row in the database where each key in the Map is a column name
// and the value is the column value. The return value is the id of the
// inserted row.
  Future<int> insert(Flight flight) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'name': flight.name,
      'dist': flight.dist,
      'days': flight.days,
      'firstDate': flight.firstDate,
      'secondDate': flight.secondDate,
    });
  }

//Observe that we have imported the sqflite and path at the start of our main.dart file.
//Flutter UI
////Following is the complete main.dart file.
//main.dart
//}
// All of the rows are returned as a list of maps, where each map is
// a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

// Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnName LIKE '%$name%'");
  }

// All of the methods (insert, query, update, delete) can also be done using
// raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

// We are assuming here that the id column in the map is set. The other
// column values will be used to update the row.
  Future<int> update(Flight flight) async {
    Database db = await instance.database;
    int id = flight.toMap()['id'];
    return await db
        .update(table, flight.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

// Deletes the row specified by the id. The number of affected rows is
// returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
