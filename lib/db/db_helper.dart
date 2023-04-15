import 'package:app_payment/db/models/pagos.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {

  static const dbName = 'dbCobro.db';
  static const pagosTable = 'Pago';
  static const pagosId = 'id';

  static Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }
  
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dbName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $pagosTable(
      $pagosId INTEGER PRIMARY KEY,
      nombre TEXT,
      apellidos TEXT,
      monto REAL,
      fecha TEXT
    )''');
  }

  Future<List<Pago>> getPagos() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(pagosTable);
    return List.generate(maps.length, (index) {
      return Pago(
        id: maps[index]['id'],
        nombre: maps[index]['nombre'],
        apellidos: maps[index]['apellidos'],
        monto: maps[index]['monto'],
        fecha: maps[index]['fecha']
      );
    });
  }

  Future<Pago> insertPago(Pago pago) async {
    var dbClient = await db;
    pago.id = await dbClient.insert(pagosTable, pago.toMap());
    return pago;
  }



  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}