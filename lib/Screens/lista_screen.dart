import 'dart:developer';
import 'dart:typed_data';
import 'package:app_payment/Screens/print_screen.dart';
import 'package:app_payment/Screens/update_pago_screen.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as x;
import 'package:file_saver/file_saver.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Map<String, dynamic>>> facturas;
  late Future<List<Inquilino>> users;
  late DBHelper dbHelper;
  DateTime fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getFacturas();
  }

  getFacturas() {
    setState(() {
      facturas = dbHelper.getFactura();
    });
  }

  @override
  Widget build(BuildContext context) {
    String nameFile = "/Reportes_$fecha";
    return Scaffold(
      backgroundColor: fondo1,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: barra1,
        centerTitle: true,
        title: FutureBuilder<List<Map<String, dynamic>>>(
          future: facturas,
          builder: (context, snapshot) {
            final fact = snapshot.data ?? [];
            return Text(
              'Total: ${fact.length}',
              style: const TextStyle(
                  color: rosapastel, fontSize: 20, fontWeight: FontWeight.bold),
            );
          },
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(38.0),
          ),
        ),
        actions: <Widget>[
          FutureBuilder<List<Map<String, dynamic>>>(
              future: facturas,
              builder: (context, snapshot) {
                return Builder(builder: (BuildContext context) {
                  return IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/export.svg',
                      color: boton2,
                      height: 32,
                      width: 32,
                    ),
                    onPressed: () async {
                      if (await Permission.storage.request().isGranted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.0))),
                              contentPadding: EdgeInsets.only(top: 10.0),
                              scrollable: true,
                              title: Center(child: Text('Exportar')),
                              content: SizedBox(
                                width: 200.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        final x.Workbook workbook =
                                            x.Workbook();
                                        final x.Worksheet excel = workbook
                                            .worksheets
                                            .addWithName('Pagos');
                                        Intl.defaultLocale = 'es';
                                        excel.getRangeByName('D1').setText(
                                            'Fecha: ${DateFormat.yMMMMEEEEd().format(DateTime.now())}');
                                        excel
                                            .getRangeByName('A4')
                                            .setText('Nombre Completo');
                                        excel
                                            .getRangeByName('B4')
                                            .setText('Servicios');
                                        excel
                                            .getRangeByName('C4')
                                            .setText('Monto');
                                        excel
                                            .getRangeByName('D4')
                                            .setText('Fecha');
                                        excel
                                            .getRangeByName('E4')
                                            .setText('Descricpión');

                                        var rows = 5;
                                        rows = 5;
                                        snapshot.data!
                                            .map((e) => excel
                                                .getRangeByName('A${rows++}')
                                                .setText(
                                                    '${e['nombre']} ${e['apellidos']}'))
                                            .toList();

                                        rows = 5;
                                        snapshot.data!
                                            .map((e) => excel
                                                .getRangeByName('B${rows++}')
                                                .setText('${e['servicio']}'))
                                            .toList();
                                        rows = 5;
                                        snapshot.data!
                                            .map((e) => excel
                                                .getRangeByName('C${rows++}')
                                                .setText('${e['monto']}'))
                                            .toList();
                                        rows = 5;
                                        snapshot.data!
                                            .map((e) => excel
                                                .getRangeByName('D${rows++}')
                                                .setText(e['fecha']))
                                            .toList();
                                        rows = 5;
                                        snapshot.data!
                                            .map((e) => excel
                                                .getRangeByName('E${rows++}')
                                                .setText(e['descripcion']))
                                            .toList();
                                        List<int> sheets =
                                            workbook.saveAsStream();
                                        workbook.dispose();
                                        Uint8List data =
                                            Uint8List.fromList(sheets);
                                        MimeType type = MimeType.OTHER;
                                        String path = await FileSaver.instance
                                            .saveAs(
                                                nameFile, data, "xlsx", type);
                                        log(path);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, bottom: 20.0),
                                        decoration: const BoxDecoration(
                                          color: negro,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(22.0),
                                              bottomRight:
                                                  Radius.circular(22.0)),
                                        ),
                                        child: const Text(
                                          "Exportar",
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.storage,
                        ].request();
                      }
                    },
                  );
                });
              })
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: facturas,
        builder: (context, snapshot) {
          final fact = snapshot.data ?? [];
          return Stack(children: <Widget>[
            Container(
              child: fact.isEmpty
                  ? const Center(
                      child: Text(
                      'No hay datos',
                      style: TextStyle(color: rosapastel),
                    ))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Factura')),
                            DataColumn(label: Text('Nombre Completo')),
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Monto')),
                            DataColumn(label: Text('Tag')),
                          ],
                          rows: snapshot.data!
                              .map((e) => DataRow(cells: [
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PrintScreen(
                                                idPago: e['id'],
                                              ),
                                            ),
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/factura.svg',
                                          color: boton2,
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(
                                        '${e['nombre']} ${e['apellidos']}')),
                                    DataCell(Text(e['fecha'].toString())),
                                    DataCell(Text('${e['monto']} Bs.')),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _confirmarDelete(
                                                e['id'], e['iduser']);
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/borrar.svg',
                                            color: boton3,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            print('hol ${e['id']}');
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdatePagoScreen(
                                                        idPago: e['id'],
                                                      )),
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/editar.svg',
                                            color: boton4,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ),
            ),
          ]);
        },
      ),
    );
  }

  _confirmarDelete(int id, int iduser) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('¿Esta segura de Borrar?')),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    dbHelper.eliminarPago(id);
                    dbHelper.updateEstadoInquil(iduser, 'A');
                    getFacturas();
                    Navigator.pop(context);
                  },
                  child: const Text('SI'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
