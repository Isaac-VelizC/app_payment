import 'package:app_payment/db/models/comprobante.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:app_payment/db/models/perfil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DBHelper {
  static const dbName = 'dbCobro.db';
  static const pagosTable = 'Pago';
  static const inquilinoTable = 'Inquilino';
  static const servicioTable = 'Servicio';
  static const perfilTable = 'Perfil';
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
      servicio TEXT,
      estado TEXT,
      descripcion TEXT
    )''');
    await db.execute('''CREATE TABLE $perfilTable(
      $tablaId INTEGER PRIMARY KEY,
      nombre INTEGER,
      imagen BLOB NULL
    )''');
    await db.rawInsert(
      'INSERT INTO $perfilTable(id, nombre, imagen) VALUES (?, ?, ?)',
      [1, 'Sin Nombre', 'none.jpg'],
    );
  }

  Future<Perfil> getPerfilId() async {
    var dbClient = await db;
    List<Map<String, dynamic>> user = await dbClient.rawQuery('SELECT * FROM $perfilTable WHERE id = 1');
    if (user.length == 1) {
      return Perfil(
          id: user[0]["id"],
          nombre: user[0]["nombre"],
          imagen: user[0]["imagen"]);
    } else {
      return Perfil(nombre: user[0]["nombre"]);
    }
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
          servicio: maps[index]['servicio'],
          estado: maps[index]['estado'],
          descripcion: maps[index]['descripcion']);
    });
  }

  Future<List<Inquilino>> getInquilinos() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps =
        await dbClient.query(inquilinoTable);
    return List.generate(maps.length, (index) {
      return Inquilino(
          id: maps[index]['id'],
          nombre: maps[index]['nombre'],
          apellidos: maps[index]['apellidos'],
          direccion: maps[index]['direccion'],
          telefono: maps[index]['telefono'],
          unidad: maps[index]['unidad'],
          estado: maps[index]['estado']);
    });
  }

  Future<List<Map<String, dynamic>>> getFactura() async {
    var dbClient = await db;
    return dbClient.rawQuery(
        'SELECT pa.id, pa.monto, pa.fecha, pa.servicio, pa.estado, pa.descripcion, inquil.id iduser, inquil.nombre, inquil.apellidos '
        'FROM $pagosTable as pa JOIN $inquilinoTable as inquil ON pa.idinquilino = inquil.id');
  }

  Future<Comprobante> getFacturaId(int userId) async {
    var dbClient = await db;
    List<Map<String, dynamic>> user = await dbClient.rawQuery(
      'SELECT pa.*, inquil.* '
      'FROM $pagosTable as pa JOIN $inquilinoTable as inquil ON pa.idinquilino = inquil.id WHERE pa.id = ?',
      [userId],
    );
    if (user.length == 1) {
      return Comprobante(
          id: user[0]["id"],
          nombre: user[0]["nombre"],
          apellido: user[0]["apellidos"],
          direccion: user[0]["direccion"],
          estado: user[0]["estado"],
          monto: user[0]["monto"],
          fecha: user[0]["fecha"],
          servicio: user[0]["servicio"],
          estadoPago: user[0]["estado"],
          descripcion: user[0]["descripcion"]);
    } else {
      return Comprobante();
    }
  }

  Future<Inquilino> insertInquilino(Inquilino inquilino) async {
    var dbClient = await db;
    inquilino.id = await dbClient.insert(inquilinoTable, inquilino.toMap());
    return inquilino;
  }

  Future<void> updateInquilino(int id, String nombre, String apellido,
      String direccion, int telefono, String unidad) async {
    Database db = await this.db;
    await db.update(
        inquilinoTable,
        {
          'nombre': nombre,
          'apellidos': apellido,
          'direccion': direccion,
          'telefono': telefono,
          'unidad': unidad
        },
        where: "id=?",
        whereArgs: [id]);
  }

  Future<List<Inquilino>> searchUsers(String query) async {
    var dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        'SELECT * FROM  $inquilinoTable WHERE nombre LIKE ? OR apellidos LIKE ?',
        ['%$query%', '%$query%']);
    return List.generate(maps.length, (index) {
      return Inquilino(
          id: maps[index]['id'],
          nombre: maps[index]['nombre'],
          apellidos: maps[index]['apellidos'],
          direccion: maps[index]['direccion'],
          telefono: maps[index]['telefono'],
          unidad: maps[index]['unidad'],
          estado: maps[index]['estado']);
    });
  }

  Future<String> eliminarRegistro(int id) async {
    var dbClient = await db;
    int result =
        await dbClient.delete(inquilinoTable, where: 'id = ?', whereArgs: [id]);
    if (result == 1) {
      return 'Registro eliminado con éxito';
    } else {
      return 'No se encontró ningún registro para eliminar';
    }
  }

  Future<Pago> insertPago(Pago pago) async {
    var dbClient = await db;
    pago.id = await dbClient.insert(pagosTable, pago.toMap());
    return pago;
  }

  Future<void> update(Pago pago) async {
    Database db = await this.db;
    await db
        .update(pagosTable, pago.toMap(), where: "id=?", whereArgs: [pago.id]);
  }

  Future<String> eliminarPago(int id) async {
    var dbClient = await db;
    int result =
        await dbClient.delete(pagosTable, where: 'id = ?', whereArgs: [id]);
    if (result == 1) {
      return 'Pago eliminado con éxito';
    } else {
      return 'No se encontró ningún registro para eliminar';
    }
  }

  Future<void> updateEstadoInquil(int id, String estado) async {
    Database dbClient = await db;
    await dbClient.update(inquilinoTable, {'estado': estado},
        where: "id=?", whereArgs: [id]);
  }

  Future<void> updatePerfil(String nombre) async {
    Database dbClient = await db;
    await dbClient.update(perfilTable, {'nombre': nombre}, where: "id=?", whereArgs: [1]);
  }

  Future<Map<String, dynamic>> getPagoById(int id) async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(pagosTable,
        where: 'idinquilino = ?',
        whereArgs: [id],
        orderBy: 'id DESC',
        limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
