import 'package:flutter/material.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class EditUserScreen extends StatefulWidget {
  final VoidCallback onEditPressed;
  final Inquilino item;
  const EditUserScreen(
      {super.key, required this.item, required this.onEditPressed});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late DBHelper dbHelper;

  final _formKey = GlobalKey<FormState>();

  String _nombre = '', _apellido = '', _direccion = '', _telefono = '', _unidad = '';

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _nombre = widget.item.nombre;
    _apellido = widget.item.apellidos;
    _direccion = widget.item.direccion!;
    _telefono = widget.item.telefono.toString();
    _unidad = widget.item.unidad!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo1,
      appBar: AppBar(
        foregroundColor: boton2,
        backgroundColor: barra1,
        toolbarHeight: 80,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(38.0),
          ),
        ),
        title: Text(
          'Actualizar a $_nombre',
          style: const TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: rosapastel,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 25.0),
              TextFormField(
                initialValue: _nombre,
                onSaved: (value) {
                  _nombre = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ingrese el nombre',
                  prefixIcon: Icon(
                    Icons.people,
                    color: boton2,
                  ),
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(
                      fontSize: 13, color: boton4, fontWeight: FontWeight.bold),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _apellido,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Ingrese el apellido',
                  prefixIcon: Icon(
                    Icons.people_alt,
                    color: boton2,
                  ),
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(
                      fontSize: 13, color: boton4, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _apellido = value!;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                initialValue: _direccion,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  hintText: 'Ingrese la direccion',
                  prefixIcon: Icon(
                    Icons.add_location,
                    color: boton2,
                  ),
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(
                      fontSize: 13, color: boton4, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección';
                  }
                  return null;
                },
                onSaved: (value) {
                  _direccion = value!;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                initialValue: _telefono,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Telefono',
                  hintText: 'Ingrese el telefono',
                  prefixIcon: Icon(
                    Icons.phone,
                    color: boton2,
                  ),
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(
                      fontSize: 13, color: boton4, fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el telefono';
                  }
                  return null;
                },
                onSaved: (value) {
                  _telefono = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _unidad,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ingrese una descripción',
                  prefixIcon: Icon(
                    Icons.description,
                    color: boton2,
                  ),
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(
                      fontSize: 13, color: boton4, fontWeight: FontWeight.bold),
                ),
                onSaved: (value) {
                  _unidad = value!;
                },
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      dbHelper.updateInquilino(widget.item.id!, _nombre, _apellido, _direccion,
          int.parse(_telefono), _unidad);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          color: boton3,
          title: 'Actualizando',
          message: 'Datos actualizados correctamento',
          contentType: ContentType.success,
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.fixed,
      ));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
