import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {

  static const dbName = 'dbCobro.db';
  static const pagosTable = 'Pago';
  static const inquilinoTable = 'Inquilino';
  static const servicioTable = 'Servicio';
  static const tablaId = 'id';

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
    await db.execute('''CREATE TABLE $inquilinoTable(
      $tablaId INTEGER PRIMARY KEY,
      nombre TEXT,
      apellidos TEXT,
      direccion TEXT,
      telefono  INTEGER,
      unidad TEXT,
      estado TEXT
    )''');
    await db.execute('''CREATE TABLE $servicioTable(
      $tablaId INTEGER PRIMARY KEY,
      tipo TEXT,
      estado INTEGER
    )''');
    await db.execute('''CREATE TABLE $pagosTable(
      $tablaId INTEGER PRIMARY KEY,
      idinquilino INTEGER,
      monto REAL,
      fecha TEXT,
      idservicio INTEGER,
      estado INTEGER
    )''');
  }

  Future<List<Pago>> getPagos() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(pagosTable);
    return List.generate(maps.length, (index) {
      return Pago(
        id: maps[index]['id'],
        idinquilino: maps[index]['idinquilino'],
        monto: maps[index]['monto'],
        fecha: maps[index]['fecha'],
        idservicio: maps[index]['idservicio'],
        estado: maps[index]['estado']
      );
    });
  }

  Future<List<Inquilino>> getInquilinos() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(inquilinoTable);
    return List.generate(maps.length, (index) {
      return Inquilino(
        id: maps[index]['id'],
        nombre: maps[index]['nombre'],
        apellidos: maps[index]['apellidos'],
        direccion: maps[index]['direccion'],
        telefono: maps[index]['telefono'],
        unidad: maps[index]['unidad'],
        estado: maps[index]['estado']
      );
    });
  }

  Future<Inquilino> insertInquilino(Inquilino inquilino) async {
    var dbClient = await db;
    inquilino.id = await dbClient.insert(inquilinoTable, inquilino.toMap());
    return inquilino;
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