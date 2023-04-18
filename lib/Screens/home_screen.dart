import 'dart:async';

import 'package:app_payment/Screens/inquilino_screen.dart';
import 'package:app_payment/db/data/servicio.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Pago>> pagos;
  late Future<List<Inquilino>> users;
  late DBHelper dbHelper;
  bool _isSearch = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoController = TextEditingController();
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:ss').format(DateTime.now());
  //DateTime? _fecha;

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    allPagos();
    allInquilinos();
  }

  allInquilinos() {
    setState(() {
      users = dbHelper.getInquilinos();
    });
  }

  allPagos() {
    setState(() {
      pagos = dbHelper.getPagos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearch ? const TextField() : const Text('Anabel Ramos Mamani'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearch = !_isSearch;
              });
            },
          ),
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const InquilinoScreen()),
                );
              },
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: FutureBuilder(
            future: users,
            builder: (BuildContext context,
                AsyncSnapshot<List<Inquilino>?> snapshot) {
              final user = snapshot.data ?? [];
              return Column(
                children: [
                  Text(
                    'INQUILINOS',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  RefreshIndicator(
                    color: Colors.red,
                    onRefresh: () async {
                      allInquilinos();
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: user.length,
                        itemBuilder: (BuildContext context, int index) {
                          final inquil = user[index];
                          return ListTile(
                            title: Text('${inquil.nombre} ${inquil.apellidos}'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Center(
                                        child: Text('Registrar Pago')),
                                    content: Text(
                                        'Registrar el pago de ${inquil.nombre}'),
                                    actions: [
                                      Column(
                                        children: servicios
                                            .map(
                                              (option) => CheckboxListTile(
                                                title: Text(option.tipo),
                                                value: option.estado,
                                                onChanged: (value) {
                                                  setState(() {
                                                    option.estado =
                                                        value ?? false;
                                                  });
                                                },
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      TextFormField(
                                        controller: _montoController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Monto',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese el monto';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                      ListTile(
                                        title: Text(
                                            'Fecha: $formattedDate $formattedTime'),
                                        /*title: Text(_fecha == null
                    ? 'Fecha de Pago'
                    : 'Fecha de Pago: ${_fecha!.toString()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _showDatePicker,*/
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final monto = double.parse(
                                                    _montoController.text);
                                                /*final List<int> tipo =
                                                _selectController.text
                                                    as List<int>;
                                            final fecha =
                                                formattedDate;*/ // ?? DateTime.now();
                                                /*dbHelper.insertPago(Pago(
                                              idinquilino: inquil.id,
                                              monto: monto,
                                              fecha: fecha.toString(),
                                              estado: 'A',
                                              idservicio: tipo,
                                            ));*/
                                                _formKey.currentState!.reset();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text('Registrado'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                                Navigator.of(context).pop();
                                                Timer(
                                                    const Duration(seconds: 1),
                                                    () {
                                                  _confirmarPrint();
                                                });
                                              }
                                            },
                                            child: const Text('Registrar'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _confirmarPrint() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('¿Imprimir Factura?')),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Imprimir'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /*_showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _fecha = date;
      });
    }
  }*/
}
