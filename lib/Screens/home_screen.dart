import 'dart:async';
import 'package:app_payment/Screens/add_pago_screen.dart';
import 'package:app_payment/Screens/inquilino_screen.dart';
import 'package:app_payment/Screens/lista_screen.dart';
import 'package:app_payment/db/data/servicio.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Inquilino>> users;
  late DBHelper dbHelper;
  bool _isSearch = false;
  DateTime now = DateTime.now();
  //DateTime? _fecha;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    allInquilinos();
  }

  allInquilinos() {
    setState(() {
      users = dbHelper.getInquilinos();
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
        child: FutureBuilder(
          future: users,
          builder:
              (BuildContext context, AsyncSnapshot<List<Inquilino>?> snapshot) {
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
                            for (var i = 0; i < servicios.length; i++) {
                              servicios[i].estado = false;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterPagoScreen(user: inquil)),
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
    );
  }
}
