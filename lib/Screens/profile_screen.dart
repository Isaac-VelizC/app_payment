import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/perfil.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late DBHelper dbHelper;
  late Future<Perfil> perfil;
  bool _autoSyncEnabled = true;
  bool _darkModeEnabled = false;
  String _nombre = '', _imagen = '';

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getIdPerfil();
  }

  getIdPerfil() {
    setState(() {
      perfil = dbHelper.getPerfilId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo1,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: barra1,
        foregroundColor: boton2,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(38.0),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Ajustes',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: rosapastel,
          ),
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder<Perfil>(
              future: perfil,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Perfil perfil = snapshot.data!;
                  _nombre = perfil.nombre;
                  _imagen = perfil.imagen!;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: const BoxDecoration(color: fondo2, boxShadow: [
                      BoxShadow(
                          color: barra1,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 7)),
                    ]),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/bros.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              perfil.nombre,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: rosapastel,),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Editar información'),
                                    content: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        initialValue: _nombre,
                                        onSaved: (value) {
                                          _nombre = value!;
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Nombre',
                                          hintText: 'Ingrese su Nombre Completo',
                                          prefixIcon: Icon(
                                            Icons.people,
                                            color: boton2,
                                          ),
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w100),
                                          labelStyle: TextStyle(
                                              fontSize: 13,
                                              color: boton4,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor ingrese su nombre';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Guardar'),
                                        onPressed: () {
                                          _submitForm();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/editar.svg',
                              color: boton4,
                              height: 25,
                              width: 25,
                            ),
                            color: boton2,
                          )
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    color: Colors.red,
                    child: const Center(
                      child: Text('Ocurrio un Error'),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18), color: boton6),
            child: SwitchListTile(
              title: const Text('Modo Oscuro'),
              subtitle: const Text('Habilitar modo oscuro'),
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18), color: boton6),
            child: SwitchListTile(
              title: const Text('Modo Oscuro'),
              subtitle: const Text('Habilitar modo oscuro'),
              value: _autoSyncEnabled,
              onChanged: (value) {
                setState(() {
                  _autoSyncEnabled = value;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18), color: boton6),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              subtitle: Text('Información sobre la aplicación'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navegar a la pantalla de información sobre la aplicación
              },
            ),
          ),
          const Divider(
            indent: 35,
            endIndent: 35,
            color: texto1,
            thickness: 2,
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18), color: boton6),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              subtitle: Text('Información sobre la aplicación'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navegar a la pantalla de información sobre la aplicación
              },
            ),
          ),
        ],
      ),
    );
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      dbHelper.updatePerfil(_nombre);
      Navigator.of(context).pop();
      getIdPerfil();
    }
  }
}
