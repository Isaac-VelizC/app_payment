import 'package:app_payment/Screens/inquilino_screen.dart';
import 'package:app_payment/db/data/servicio.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:app_payment/themes/style_text.dart';
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

  TextEditingController _selectController = TextEditingController();

  //List<String> _hobbies = ['Fútbol', 'Música', 'Lectura'];
  List<bool> _checkedHobbies = [false, false, false];

  void _handleHobbyCheckbox(int index, bool value) {
    setState(() {
      _checkedHobbies[index] = value;
    });
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    //_selectController = TextEditingController(text: _options[0]);
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
              return Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const StyleText(text: 'Inquilinos', colors: negro),
                    SizedBox(
                      height: 270,
                      child: ListView.builder(
                        itemCount: user.length,
                        itemBuilder: (BuildContext context, int index) {
                          final inquil = user[index];
                          return ListTile(
                            title: Text(inquil.nombre),
                            onTap: () {
                              _showPaymentDialog(context, inquil);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, Inquilino user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar pago'),
          content: Text('¿Desea registrar el pago para ${user.nombre}?'),
          actions: <Widget>[
            const SizedBox(height: 16.0),
            /*Row(
              children: servicios.asMap().entries.map((entry) => Row(
                children: [
                  Checkbox(value: _checkedHobbies[entry.key], onChanged: (value) {
                            _handleHobbyCheckbox(entry.key, value ?? false);
                  }),
                  Text(entry.value),
                ],
              )),
            ),*/
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
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {}, //_submitForm(user),
              child: const Text('Registrar Pago'),
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

  _submitForm(Inquilino user) {
    if (_formKey.currentState!.validate()) {
      final monto = double.parse(_montoController.text);
      final List<int> tipo = _selectController.text as List<int>;
      final fecha = formattedDate;// ?? DateTime.now();
      dbHelper.insertPago(
        Pago(
            idinquilino: user.id,
            monto: monto,
            fecha: fecha.toString(),
            estado: 'A',
            idservicio: tipo,
        )
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registrado'),
        duration: Duration(seconds: 2),
      ));
      Navigator.of(context).pop();
    }
  }
}
