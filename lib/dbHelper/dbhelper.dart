import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/task.dart';
class DbHelper{
  static final String _dbname = 'task.db';

  static int _dbversion = 1;

  static final String _tableTask = 'taskList';

  static final String _id = 'id';
  static final String _title = 'title';
  static final String _desc = 'description';
  static final String _date = 'date';
  static final String _time = 'time';
  static final String _priority = 'priority';

  static Database? _database;

  static final DbHelper _instance = DbHelper._internal();


  factory DbHelper() {
    return _instance;
  }

  DbHelper._internal();

  Future<Database?> getDatabase() async{
    _database ??= await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async{
    var databasePath = join(await getDatabasesPath(), _dbname);
    print('datbase path : ${databasePath}');

    return await openDatabase(
        databasePath,
        version: _dbversion,
        onCreate: (db, version){
          return db.execute('CREATE TABLE $_tableTask('
              '$_id INTEGER PRIMARY KEY AUTOINCREMENT,'
              '$_title TEXT, '
              '$_desc TEXT, '
              '$_date TEXT, '
              '$_time TEXT, '
              '$_priority TEXT )');
        }
    );
  }
  Future<int> insertTask(Task person) async{
    var db = await getDatabase();
    print(person.toMap().toString());
    return db!.insert(_tableTask, person.toMap());
  }

  Future<List<Task>> getTask() async {
    var db = await getDatabase();
    List<Map<String, dynamic>> maps = await db!.query(_tableTask, orderBy: '$_date DESC');
    return List.generate(maps.length, (index) => Task.fromMap(maps[index])).toList();

    List.generate(maps.length, (index) {
      print(maps[index]);
      return index;
    });
  }

  Future<int> deleteTask(int id) async {
    var db = await getDatabase();
    return db!.delete(_tableTask, where: '$_id=?', whereArgs: [id]);
  }

  Future<int> updateTask(Task person) async {
    var db = await getDatabase();
    return db!.update(_tableTask, person.toMap(),where: '$_id=?', whereArgs: [person.id]);
  }

}