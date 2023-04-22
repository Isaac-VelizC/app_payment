import 'dart:async';
import 'package:app_payment/Screens/inquilino_screen.dart';
import 'package:app_payment/Widgets/item_widget.dart';
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
  final key = GlobalKey<AnimatedListState>();
  late DBHelper dbHelper;
  bool _isSearch = false;
  final TextEditingController _searchController = TextEditingController();
  late List<Inquilino> _searchResults;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    allInquilinos();
    _searchResults = [];
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
        toolbarHeight: 80,
        backgroundColor: Colors.amber,
        title: _isSearch
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el nombre o apellido',
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 13, color: Colors.teal),
                ),
                onChanged: (query) {
                  dbHelper.searchUsers(query).then((results) {
                    setState(() {
                      _searchResults = results;
                    });
                  });
                },
              )
            : const Text('Anabel Ramos Mamani'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearch ? Icons.clear : Icons.search),
            onPressed: () {
              setState(() {
                _isSearch = !_isSearch;
                _searchResults = [];
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
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(38.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: users,
          builder:
              (BuildContext context, AsyncSnapshot<List<Inquilino>?> snapshot) {
            final user = snapshot.data ?? [];
            _searchController.value.text.isEmpty
                ? _searchResults = []
                : _searchResults;
            if (_searchResults.isEmpty &&
                _searchController.value.text.isEmpty) {
              return Column(
                children: [
                  RefreshIndicator(
                    color: Colors.red,
                    onRefresh: () async {
                      allInquilinos();
                    },
                    child: user.isEmpty
                        ? const Center(
                            child: Text('No hay Datos'),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: AnimatedList(
                              key: key,
                              initialItemCount: user.length,
                              itemBuilder: (context, index, animation) =>
                                  buildItem(user[index], index, animation),
                            ),
                          ),
                  ),
                ],
              );
            } else {
              return _searchResults.isEmpty
                  ? Center(
                      child: Text('No se encontro a ${_searchController.value.text}'),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return ListTile(
                            title: Text(result.nombre),
                            subtitle: Text(result.apellidos),
                            onTap: () {
                              // Navegar a la pantalla de detalles del resultado seleccionado
                            },
                          );
                        },
                      ),
                    );
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(item, int index, Animation<double> animation) {
    return UserItemWidget(
      item: item,
      animation: animation,
      onClicked: () {},
    );
  }
}
