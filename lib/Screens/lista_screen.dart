import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:app_payment/themes/style_icon.dart';
import 'package:app_payment/themes/style_text.dart';
import 'package:flutter/material.dart';
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
  late Future<List<Pago>> pagos;
  late DBHelper dbHelper;
  DateTime fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    allPagos();
  }

  allPagos() {
    setState(() {
      pagos = dbHelper.getPagos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).size.height * 0.01;
    String nameFile = "/Reportes_$fecha";
    return Scaffold(
      body: FutureBuilder(
        future: pagos,
        builder: (BuildContext context, AsyncSnapshot<List<Pago>?> snapshot) {
          final pago = snapshot.data ?? [];
          return Stack(children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0, 0.6],
                      colors: [Colors.yellow, Colors.blue],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * .20,
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 50),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            icon: const Icon(Icons.arrow_back),
                            color: negro,
                          ),
                          const StyleText(
                            colors: negro,
                            text: 'Reporte',
                            size: 25,
                            fontweight: FontWeight.w700,
                          ),
                              IconButton(
                                  onPressed: () async {
                                    if (await Permission.storage
                                        .request()
                                        .isGranted) {
                                      return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(22.0))),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 10.0),
                                            scrollable: true,
                                            title: Text(
                                                'Exportar Datos'),
                                            content: SizedBox(
                                              width: 300.0,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () async {
                                                      final x.Workbook
                                                          workbook =
                                                          x.Workbook();
                                                      final x.Worksheet excel =
                                                          workbook.worksheets
                                                              .addWithName(
                                                                  'Pagos');
                                                      var i = 0;
                                                      final col = [
                                                        'A',
                                                        'B',
                                                        'C',
                                                      ];
                                                      Intl.defaultLocale = 'es';
                                                      excel
                                                          .getRangeByName('D1')
                                                          .setText(
                                                              'Fecha: ${DateFormat.yMMMMEEEEd().format(DateTime.now())}');
                                                      /*Text(
                                                          '${barra.map((e) => excel.getRangeByName('${col[i++]}4').setText(e.)).toList()}',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ));*/

                                                      var rows = 5;
                                                      rows = 5;
                                                      snapshot.data!
                                                          .map((e) => excel
                                                              .getRangeByName(
                                                                  'A${rows++}')
                                                              .setText(
                                                                  '${e.nombre} ${e.apellidos}'))
                                                          .toList();

                                                      rows = 5;
                                                      snapshot.data!
                                                          .map((e) => excel
                                                              .getRangeByName(
                                                                  'B${rows++}')
                                                              .setText(
                                                                  '${e.monto}'))
                                                          .toList();
                                                      rows = 5;
                                                      snapshot.data!
                                                          .map((e) => excel
                                                              .getRangeByName(
                                                                  'C${rows++}')
                                                              .setText(
                                                                  e.fecha))
                                                          .toList();
                                                      List<int> sheets =
                                                          workbook
                                                              .saveAsStream();
                                                      workbook.dispose();
                                                      Uint8List data =
                                                          Uint8List.fromList(
                                                              sheets);
                                                      MimeType type =
                                                          MimeType.OTHER;
                                                      String path =
                                                          await FileSaver
                                                              .instance
                                                              .saveAs(
                                                                  nameFile,
                                                                  data,
                                                                  "xlsx",
                                                                  type);
                                                      log(path);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20.0,
                                                              bottom: 20.0),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: negro,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        22.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        22.0)),
                                                      ),
                                                      child: const Text(
                                                        "Exportar",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
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
                                      Map<Permission, PermissionStatus>
                                          statuses = await [
                                        Permission.storage,
                                      ].request();
                                    }
                                  },
                                  icon: const StyleIcono(
                                      iconName: 'excel',
                                      color: negro,
                                      ancho: 25,
                                      alto: 25),),
                        ],
                      ),
                      Center(
                        child: StyleText(
                          text: 'Total: ${pago.length}',
                          colors: negro,
                          size: 25.0,
                          fontweight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .20,
                right: 20.0,
                left: 20.0,
              ),
              child: pago.isEmpty
                  ? Center(child: Text('Anabel Ramos'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Nombre Completo ')),
                            DataColumn(label: Text('Monto')),
                            DataColumn(label: Text('Fecha ')),
                          ],
                          rows: snapshot.data!
                              .map((e) => DataRow(cells: [
                                    DataCell(
                                        Text('${e.nombre} ${e.apellidos}')),
                                    DataCell(Text('${e.monto} Bs.')),
                                    DataCell(Text(e.fecha.toString())),
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
}