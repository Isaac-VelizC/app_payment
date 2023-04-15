import 'package:app_payment/Screens/lista_screen.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:flutter/material.dart';

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
  DateTime? _fecha;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _montoController.dispose();
    //_facturaController.dispose();
    super.dispose();
  }

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
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                showMenu(
                  context: context,
                  position: RelativeRect.fromRect(
                      Rect.fromPoints(
                          overlay.localToGlobal(Offset.zero),
                          overlay.localToGlobal(
                              overlay.size.bottomLeft(Offset.zero))),
                      Offset.zero & overlay.size),
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Listar'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ListScreen()),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Registrar'),
                        onTap: () {},
                      ),
                    ),
                  ],
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
                title: Text(_fecha == null
                    ? 'Fecha de Pago'
                    : 'Fecha de Pago: ${_fecha!.toString()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _showDatePicker,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar Pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDatePicker() async {
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
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Enviar los datos a la base de datos o API
      final nombre = _nombreController.text;
      final apellido = _apellidoController.text;
      final monto = double.parse(_montoController.text);
      //final factura = _facturaController.text;
      final fecha = _fecha ?? DateTime.now();
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
