import 'dart:convert';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/services.dart';

class PrintScreen extends StatefulWidget {
  final int idPago;
  const PrintScreen({super.key, required this.idPago});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  late Future<List<Map<String, dynamic>>> printer;
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';
  late DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getIdPago();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
  }

  getIdPago() {
    setState(() {
      printer = dbHelper.getFacturaId(widget.idPago);
    });
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;
    bluetoothPrint.state.listen((state) {
      print('*************************: $state');
      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Conexion Exitosa';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'Desconexion Exitosa';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo1,
      appBar: AppBar(
        foregroundColor: boton2,
        title: const Text('Seleccione una impresora', style: TextStyle(color: rosapastel),),
        backgroundColor: barra1,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(tips),
                  )
                ],
              ),
              const Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: [],
                builder: (context, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (d) => ListTile(
                          title: Text(d.name ?? ''),
                          subtitle: Text(d.address ?? ''),
                          onTap: () {
                            setState(() async {
                              _device = d;
                            });
                          },
                          trailing:
                              _device != null && _device!.address == d.address
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                        ),
                      )
                      .toList(),
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_device != null &&
                                      _device!.address != null) {
                                    setState(() {
                                      tips = 'Conectando...';
                                    });
                                    await bluetoothPrint.connect(_device!);
                                  } else {
                                    setState(() {
                                      tips =
                                          'Por favor seleccione un dispositivo';
                                    });
                                  }
                                },
                          child: const Text('Conectar'),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        OutlinedButton(
                          onPressed: _connected
                              ? () async {
                                  setState(() {
                                    tips = 'Desconectado....';
                                  });
                                  await bluetoothPrint.disconnect();
                                }
                              : null,
                          child: const Text('Desconectado'),
                        ),
                      ],
                    ),
                    const Divider(),
                    OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              Map<String, dynamic> config = Map();
                              List<LineText> list = [];
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      '**********************************************',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '打印单据头',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  fontZoom: 2,
                                  linefeed: 1));
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '物资名称规格型号',
                                  align: LineText.ALIGN_LEFT,
                                  y: 0,
                                  relativeX: 0,
                                  linefeed: 0));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '单位',
                                  align: LineText.ALIGN_LEFT,
                                  y: 350,
                                  relativeX: 0,
                                  linefeed: 0));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '数量',
                                  align: LineText.ALIGN_LEFT,
                                  y: 500,
                                  relativeX: 0,
                                  linefeed: 1));

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '混凝土C30',
                                  align: LineText.ALIGN_LEFT,
                                  y: 0,
                                  relativeX: 0,
                                  linefeed: 0));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '吨',
                                  align: LineText.ALIGN_LEFT,
                                  y: 350,
                                  relativeX: 0,
                                  linefeed: 0));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '12.0',
                                  align: LineText.ALIGN_LEFT,
                                  y: 500,
                                  relativeX: 0,
                                  linefeed: 1));

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      '**********************************************',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));
                              list.add(LineText(linefeed: 1));

                              ByteData data = await rootBundle.load("");
                              List<int> imageBytes = data.buffer.asUint8List(
                                  data.offsetInBytes, data.lengthInBytes);
                              String base64Image = base64Encode(imageBytes);

                              await bluetoothPrint.printReceipt(config, list);
                            }
                          : null,
                      child: const Text('Imprimir'),
                    ),
                    OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              Map<String, dynamic> config = Map();
                              config['width'] = 40;
                              config['height'] = 70;
                              config['gap'] = 2;

                              List<LineText> list = [];

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  x: 10,
                                  y: 10,
                                  content: 'A Title'));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  x: 10,
                                  y: 40,
                                  content: 'this is content'));
                              list.add(LineText(
                                  type: LineText.TYPE_QRCODE,
                                  x: 10,
                                  y: 70,
                                  content: 'qrcode i\n'));
                              list.add(LineText(
                                  type: LineText.TYPE_BARCODE,
                                  x: 10,
                                  y: 190,
                                  content: 'qrcode i\n'));

                              List<LineText> list1 = [];
                              ByteData data = await rootBundle.load("");
                              List<int> imageBytes = data.buffer.asUint8List(
                                  data.offsetInBytes, data.lengthInBytes);
                              String base64Image = base64Encode(imageBytes);
                              list1.add(LineText(
                                type: LineText.TYPE_IMAGE,
                                x: 10,
                                y: 10,
                                content: base64Image,
                              ));

                              await bluetoothPrint.printLabel(config, list);
                              await bluetoothPrint.printLabel(config, list1);
                            }
                          : null,
                      child: const Text('Imprimir Etiquetas'),
                    ),
                    OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              await bluetoothPrint.printTest();
                            }
                          : null,
                      child: const Text('autodiagnóstico de impresión'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data == true) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: () => bluetoothPrint.startScan(
                timeout: const Duration(seconds: 4),
              ),
            );
          }
        },
      ),
    );
  }
}
