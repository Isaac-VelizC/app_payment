import 'dart:developer';
import 'package:app_payment/Screens/print_screen.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:app_payment/themes/colors.dart';
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
  late Future<List<Inquilino>> users;
  late Future<List<Pago>> pagos;
  late DBHelper dbHelper;
  DateTime fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    allPagos();
    allInquilinos();
  }

  allPagos() {
    setState(() {
      pagos = dbHelper.getPagos();
    });
  }

  allInquilinos() {
    setState(() {
      users = dbHelper.getInquilinos();
    });
  }

  @override
  Widget build(BuildContext context) {
    String nameFile = "/Reportes_$fecha";
    final Orientation orientation = MediaQuery.of(context).orientation;
    final barraAltura = orientation == Orientation.portrait ? .15 : .30;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: FutureBuilder(
          future: pagos,
          builder: (BuildContext context, AsyncSnapshot<List<Pago>?> snapshot) {
            final pago = snapshot.data ?? [];
            return Text(
              'Total: ${pago.length}',
              style: const TextStyle(
                  color: negro, fontSize: 20, fontWeight: FontWeight.bold),
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
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.document_scanner),
              onPressed: () {
                /*Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const InquilinoScreen()),
                );*/
              },
            );
          }),
        ],
      ),
      body: FutureBuilder(
        future: pagos,
        builder: (BuildContext context, AsyncSnapshot<List<Pago>?> snapshot) {
          final pago = snapshot.data ?? [];
          return Stack(children: <Widget>[
            Container(
              child: pago.isEmpty
                  ? const Center(child: Text('No hay datos'))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Imprimir')),
                            DataColumn(label: Text('Nombre Completo')),
                            DataColumn(label: Text('Servicios')),
                            DataColumn(label: Text('Monto')),
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Estado')),
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
                                                  data: snapshot.data),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.print),
                                      ),
                                    ),
                                    DataCell( //Text('${e.idinquilino}'),
                                      FutureBuilder(
                                        future: users,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Inquilino>?>
                                                snapshot) {
                                          final user = snapshot.data ?? [];
                                          return Text('${user.map((i) => e.idinquilino == i.id ? i.nombre : '' ).toList()}');
                                        },
                                      ),
                                    ),
                                    DataCell(Text(e.idservicio)),
                                    DataCell(Text('${e.monto} Bs.')),
                                    DataCell(Text(e.fecha.toString())),
                                    DataCell(Text(e.estado)),
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

  /*buildInvoice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Factura',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
    );
  }*/
}


/**
 * Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0, 0.6],
                      colors: [Colors.transparent, Colors.red],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * barraAltura,
                  padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('hol'),
                          /*IconButton(
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
                                          const EdgeInsets.only(top: 10.0),
                                      scrollable: true,
                                      title: Text('Exportar Datos'),
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
                                                final x.Workbook workbook =
                                                    x.Workbook();
                                                final x.Worksheet excel =
                                                    workbook.worksheets
                                                        .addWithName('Pagos');

                                                Intl.defaultLocale = 'es';
                                                excel.getRangeByName('D1').setText(
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
                                                        .setText('${e.monto}'))
                                                    .toList();
                                                rows = 5;
                                                snapshot.data!
                                                    .map((e) => excel
                                                        .getRangeByName(
                                                            'C${rows++}')
                                                        .setText(e.fecha))
                                                    .toList();
                                                List<int> sheets =
                                                    workbook.saveAsStream();
                                                workbook.dispose();
                                                Uint8List data =
                                                    Uint8List.fromList(sheets);
                                                MimeType type = MimeType.OTHER;
                                                String path = await FileSaver
                                                    .instance
                                                    .saveAs(nameFile, data,
                                                        "xlsx", type);
                                                log(path);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0, bottom: 20.0),
                                                decoration: const BoxDecoration(
                                                  color: negro,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  22.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  22.0)),
                                                ),
                                                child: const Text(
                                                  "Exportar",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.storage,
                                ].request();
                              }
                            },
                            icon: const StyleIcono(
                                iconName: 'excel',
                                color: negro,
                                ancho: 25,
                                alto: 25),
                          ),
                        */],
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
 */