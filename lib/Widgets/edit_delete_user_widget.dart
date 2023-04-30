import 'dart:io';

import 'package:app_payment/Screens/edit_user_screen.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class EditDeleteModal extends StatelessWidget {
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final Inquilino item;
  final DBHelper dbHelper;

  const EditDeleteModal({super.key, required this.onEditPressed, required this.onDeletePressed, required this.item, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(item.nombre),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => EditUserScreen(item: item, onEditPressed: onEditPressed,)),
          ),
            child: const Icon(Icons.edit),
          ),
          ElevatedButton(
            onPressed: () async {
              String mensaje = await dbHelper.eliminarRegistro(item.id!);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      color: boton3,
                      title: 'Eliminando...',
                      message: mensaje,
                      contentType: ContentType.success,
                    ),
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.fixed,
                  ));
                  onDeletePressed();
            },
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}