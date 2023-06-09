import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class InquilinoScreen extends StatefulWidget {
  const InquilinoScreen({super.key});

  @override
  State<InquilinoScreen> createState() => _InquilinoScreenState();
}

class _InquilinoScreenState extends State<InquilinoScreen> {
  late DBHelper dbHelper;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _unidadController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _unidadController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
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
        title: const Text(
          'Registrar Inquilino',
          style: TextStyle(
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
                controller: _nombreController,
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
                controller: _apellidoController,
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
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _direccionController,
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
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _telefonoController,
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
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _unidadController,
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
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },*/
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      color: boton3,
                      title: 'Registro',
                      message: 'El Inquilino se registro correctamento',
                      contentType: ContentType.success,
                    ),
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.fixed,
                  ));
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final apellido = _apellidoController.text;
      final direccion = _direccionController.text;
      final telefono = int.parse(_telefonoController.text);
      final unidad = _unidadController.text;
      dbHelper.insertInquilino(
        Inquilino(
            nombre: nombre,
            apellidos: apellido,
            direccion: direccion,
            telefono: telefono,
            unidad: unidad,
            estado: 'A'),
      );
      _formKey.currentState!.reset();
    }
  }
}
