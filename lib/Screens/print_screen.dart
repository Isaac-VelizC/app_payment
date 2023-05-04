import 'dart:io';
import 'dart:ui' as ui;
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/comprobante.dart';
import 'package:app_payment/db/models/perfil.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PrintScreen extends StatefulWidget {
  final int idPago;
  const PrintScreen({super.key, required this.idPago});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  final GlobalKey _globalKey = GlobalKey();
  late Future<Comprobante> printer;
  late Future<Perfil> perfil;
  late DBHelper dbHelper;

  Future<String> _capturePantalla() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    var status = await Permission.storage.request();
    if (status.isDenied) {
      // Si el usuario rechaza los permisos, muestra un mensaje de error
      return 'Error: el usuario rechazó los permisos';
    }
    // Guarda la imagen en la galería
    File imageFile = await _saveImage(pngBytes);
    await _shareImage(imageFile);
    return 'Se guardo el Comprobante en Galeria';
  }

  Future<File> _saveImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    File file = File('${directory.path}/$fileName.png');
    await file.writeAsBytes(bytes);
    await GallerySaver.saveImage(file.path);
    return file;
  }

  Future<void> _shareImage(File imageFile) async {
    List<String> paths = [imageFile.path];
    // ignore: deprecated_member_use
    await Share.shareFiles(
      paths,
      text: 'Compartir imagen',
      subject: 'Imagen compartida',
      mimeTypes: ['image/png'],
    );
  }

  String imprimirFechaHoraActual() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDateTime;
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    getIdPago();
  }

  getIdPago() {
    setState(() {
      printer = dbHelper.getFacturaId(widget.idPago);
      perfil = dbHelper.getPerfilId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: FutureBuilder<Comprobante>(
        future: printer,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Comprobante comprobante = snapshot.data!;
            String texto =
                comprobante.servicio!.replaceAll('[', '').replaceAll(']', '');
            return RepaintBoundary(
              key: _globalKey,
              child: Container(
                margin: const EdgeInsets.all(30.0),
                child: FutureBuilder<Perfil>(
                    future: perfil,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Perfil perfil = snapshot.data!;
                        return Column(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/bros.png'),
                                  //fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Text(
                              'COMPROBANTE',
                              style: GoogleFonts.castoro(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              imprimirFechaHoraActual(),
                              style: GoogleFonts.castoro(
                                  fontSize: 15, fontWeight: FontWeight.w100),
                            ),
                            const Divider(
                              height: 50.0,
                              color: negro,
                              indent: 20,
                              endIndent: 20,
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'De:',
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  perfil.nombre,
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Para:',
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  '${comprobante.nombre} ${comprobante.apellido}',
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fecha de pago:',
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  comprobante.fecha!,
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monto:',
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  '${comprobante.monto} Bs.',
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Servicios:',
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  texto,
                                  style: GoogleFonts.acme(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              'Descripción:',
                              style: GoogleFonts.acme(
                                  fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                            Text(
                              '${comprobante.descripcion}',
                              style: GoogleFonts.acme(
                                  fontSize: 15, fontWeight: FontWeight.w100),
                            ),
                            const Divider(
                              height: 50.0,
                              color: negro,
                              thickness: 2,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Text(
                              'GRACIAS!!!',
                              style: GoogleFonts.castoro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Errooorrr......'),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 100,
                    color: rosapastel,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Ocurrió un error',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: boton3),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Error al cargar los datos',
                    style: TextStyle(fontSize: 16, color: boton3),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String mensaje = await _capturePantalla();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              color: boton3,
              title: 'Guardando...',
              message: mensaje,
              contentType: ContentType.success,
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.fixed,
          ));
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
