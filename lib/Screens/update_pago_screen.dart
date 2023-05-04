import 'dart:async';

import 'package:app_payment/db/data/servicio.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

class UpdatePagoScreen extends StatefulWidget {
  final int idPago;
  const UpdatePagoScreen({super.key, required this.idPago});

  @override
  State<UpdatePagoScreen> createState() => _UpdatePagoScreenState();
}

class _UpdatePagoScreenState extends State<UpdatePagoScreen> {
  late Future<List<Pago>> pagos;
  late Future<List<Inquilino>> users;
  late DBHelper dbHelper;
  final _formKey = GlobalKey<FormState>();
  String _monto = '', _descripcion = '', _servicio = '', _fecha = '';

  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //String formattedTime = DateFormat('kk:mm:ss').format(DateTime.now());
  //DateTime? _fecha;
  List<dynamic> multipleSelected = [];
  late Pago updatepago;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    //getPago();
  }

  /*getPago() {
    setState(() {
      updatepago = dbHelper.getPagoById(widget.idPago);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: barra1,
        foregroundColor: boton2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(38.0),
          ),
        ),
        title: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Marquee(
            text: 'Actualizar el pago de ',
            style: const TextStyle(
              fontFamily: 'Pacifico',
              color: rosapastel,
            ),
            pauseAfterRound: const Duration(seconds: 3),
            accelerationDuration: const Duration(seconds: 2),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(seconds: 2),
            decelerationCurve: Curves.easeInOut,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 150.0,
            velocity: 100.0,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('En Desarrollo', style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),),
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/work.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver'))
          ],
      ),
      /*
      Container(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: List.generate(
                    servicios.length,
                    (index) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      title: Text(
                        servicios[index].tipo,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      value: servicios[index].estado,
                      onChanged: (value) {
                        setState(
                          () {
                            servicios[index].estado = value!;
                            if (multipleSelected
                                .contains(servicios[index].tipo)) {
                              multipleSelected.remove(servicios[index].tipo);
                            } else {
                              multipleSelected.add(servicios[index].tipo);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  //title: Text('Fecha: $formattedDate $formattedTime'),
                  title: Text(_fecha == null
                      ? 'Fecha de Pago'
                      : 'Fecha: ${_fecha!.toString()}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _showDatePicker,
                ),
                TextFormField(
                  controller: _montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    hintText: 'Ingrese el monto',
                    prefixIcon: Icon(Icons.money),
                    hintStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                    labelStyle: TextStyle(fontSize: 13, color: Colors.teal),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el monto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descripcionController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descripción del Pago',
                    hintText: 'Ingrese una descripción',
                    prefixIcon: Icon(Icons.description),
                    hintStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                    labelStyle: TextStyle(fontSize: 13, color: Colors.teal),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción corta';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final monto = double.parse(_montoController.text);
                          final tipo = multipleSelected.isEmpty
                              ? ""
                              : multipleSelected.toString();
                          final fecha = formattedDate; // ?? DateTime.now();
                          final descripcion = _descripcionController.text;
                          /*dbHelper.update(Pago(
                            idinquilino: widget.user.id,
                            monto: monto,
                            fecha: fecha.toString(),
                            estado: 'A',
                            servicio: tipo,
                            descripcion: descripcion,
                          ));*/
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Actualizado'),
                            duration: Duration(seconds: 2),
                          ));
                          Timer(const Duration(seconds: 1), () {
                            _confirmarPrint();
                          });
                          _formKey.currentState!.reset();
                        }
                      },
                      child: const Text('Registrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    */
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrintScreen(idPago: null,),
                      ),
                    );*/
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
}
