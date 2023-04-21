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
        backgroundColor: Colors.amber,
        title:
            _isSearch ? const TextField(
              decoration: InputDecoration(
                  hintText: 'Ingrese el nombre',
                  hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 13, color: Colors.teal),
                
              ),
            ) : const Text('Anabel Ramos Mamani'),
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
        padding: const EdgeInsets.all(12.0),
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: users,
          builder:
              (BuildContext context, AsyncSnapshot<List<Inquilino>?> snapshot) {
            final user = snapshot.data ?? [];
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
