import 'package:app_payment/db/models/pagos.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:intl/intl.dart';

class PrintScreen extends StatefulWidget {
  final List<Pago>? data;
  const PrintScreen({super.key, required this.data});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _deviceMsg = "";
  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 2));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen((event) {
      if (!mounted) return;
      setState(() {
        _devices = event;
      });
      if (_devices.isEmpty) {
        setState(() {
          _deviceMsg = "No hay dispocitivos";
      });}
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccione una impresora'),
        backgroundColor: Colors.redAccent,
      ),
      body: _devices.isEmpty
          ? Center(
              child: Text(_deviceMsg ?? ''),
            )
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (c, i) {
                return ListTile(
                  leading: const Icon(Icons.print),
                  title: Text('${_devices[i].name}'),
                  subtitle: Text('${_devices[i].address}'),
                  onTap: () {
                    _startPrint(_devices[i]);
                  },
                );
              },
            ),
    );
  }

  Future<void> _startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await bluetoothPrint.connect(device);

      Map<String, dynamic> config = Map();
      List<LineText> list = [];
      list.add(
        LineText(
          type: LineText.TYPE_TEXT,
          content: "Grocery App",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        )
      );
      for (var i = 0; i < widget.data!.length; i++) {
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "",
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          )
        );
        list.add(
          LineText(
            type: LineText.TYPE_TEXT,
            content: "",
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          )
        );
      }
    }
  }
}
