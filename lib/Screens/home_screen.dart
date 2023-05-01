import 'dart:async';
import 'package:app_payment/Screens/inquilino_screen.dart';
import 'package:app_payment/Widgets/item_widget.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      backgroundColor: fondo1,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: barra1,
        title: _isSearch
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el nombre o apellido',
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 13, color: texto1),
                ),
                onChanged: (query) {
                  dbHelper.searchUsers(query).then((results) {
                    setState(() {
                      _searchResults = results;
                    });
                  });
                },
              )
            : const Text(
                'Heydi Anabel Ramos Mamani',
                style: TextStyle(fontSize: 17, color: rosapastel),
              ),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              _isSearch ? 'assets/icons/x.svg' : 'assets/icons/search.svg',
              color: boton2,
              height: 25,
              width: 25,
            ),
            onPressed: () {
              setState(() {
                _isSearch = !_isSearch;
                _searchController.clear();
                _searchResults = [];
              });
            },
          ),
          Builder(builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(
                'assets/icons/add.svg',
                color: boton2,
                height: 25,
                width: 25,
              ),
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
                    color: boton2,
                    onRefresh: () async {
                      allInquilinos();
                    },
                    child: user.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay Datos',
                              style: TextStyle(color: rosapastel),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                kToolbarHeight -
                                kBottomNavigationBarHeight -
                                56,
                            child: AnimatedList(
                              key: key,
                              initialItemCount: user.length,
                              itemBuilder: (context, index, animation) =>
                                  buildItem(user[index], index),
                            ),
                          ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  RefreshIndicator(
                    color: boton2,
                    onRefresh: () async {
                      allInquilinos();
                    },
                    child: _searchResults.isEmpty
                        ? Center(
                            child: Text(
                              'No se encontro a ${_searchController.value.text}',
                              style: const TextStyle(color: rosapastel),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                kToolbarHeight -
                                kBottomNavigationBarHeight -
                                56,
                            child: ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final result = _searchResults[index];
                                return buildItem(result, index);
                              },
                            ),
                          ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildItem(item, int index) {
    return UserItemWidget(
      dbHelper: dbHelper,
      item: item,
      onClicked: () {},
    );
  }
}
