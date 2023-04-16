import 'package:app_payment/Screens/lista_screen.dart';
import 'package:app_payment/Widgets/list_new_widget.dart';
import 'package:app_payment/db/db_helper.dart';
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
  late DBHelper dbHelper;
  bool _isSearch = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:ss').format(DateTime.now());

  //DateTime? _fecha;

  TextEditingController _selectController = TextEditingController();

  final List<String> _options = [
    'Luz',
    'Agua',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _selectController = TextEditingController(text: _options[0]);
    allPagos();
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
        title: _isSearch ? const TextField() : const Text('Anabel Ramos'),
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
              icon: const Icon(Icons.list),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ListScreen()),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Registrar Pago',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
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
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
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
                controller: _selectController,
                readOnly: true,
                onTap: () {
                  _showOptionsDialog(context);
                },
                decoration: const InputDecoration(
                  labelText: 'Selecciona un servicio',
                  border: OutlineInputBorder(),
                ),
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
                title: Text('Fecha y Hora: $formattedDate $formattedTime'),
                /*title: Text(_fecha == null
                    ? 'Fecha de Pago'
                    : 'Fecha de Pago: ${_fecha!.toString()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _showDatePicker,*/
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar Pago'),
              ),
              const SizedBox(height: 40.0),
              SizedBox(
                height: 300,
                child: ListNewWidget(pago: pagos,)),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un servicio'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _options.map((option) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectController.text = option;
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(option),
                  ),
                );
              }).toList(),
            ),
          ),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final apellido = _apellidoController.text;
      final monto = double.parse(_montoController.text);
      final tipo = _selectController.text;
      final fecha = formattedDate ?? DateTime.now();
      dbHelper.insertPago(
        Pago(
            nombre: nombre,
            apellidos: apellido,
            monto: monto,
            fecha: fecha.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registrado'),
        duration: Duration(seconds: 2),
      ));
      //form.save();
      _formKey.currentState!.reset();
    }
  }
}
