import 'package:app_payment/Screens/add_pago_screen.dart';
import 'package:app_payment/Screens/update_pago_screen.dart';
import 'package:app_payment/Widgets/edit_delete_user_widget.dart';
import 'package:app_payment/db/data/servicio.dart';
import 'package:app_payment/db/db_helper.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class UserItemWidget extends StatelessWidget {
  final Inquilino item;
  final VoidCallback onClicked;
  final DBHelper dbHelper;
  const UserItemWidget({super.key, required this.item, required this.onClicked, required this.dbHelper});
  

  @override
  Widget build(BuildContext context) {
    void showEditDeleteModal(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditDeleteModal(
          onEditPressed: () {
            Navigator.pop(context);
          },
          onDeletePressed: () {
            Navigator.pop(context);
          },
          item: item,
          dbHelper: dbHelper,
        );
      },
    );
  }

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: fondo2,
        boxShadow: const [
          BoxShadow(
            color: barra1,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.transparent,
            offset: Offset(-5, 0),
          )
        ],
      ),
      child: ListTile(
        onLongPress: () {
            showEditDeleteModal(item.id!);
        },
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        leading: const CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage('assets/usuario.png')
        ),
        title: SizedBox(
          height: 25,
          width: 25,
          child: Marquee(
            text: '${item.nombre} ${item.apellidos}',
            style: const TextStyle(color: negro),
            pauseAfterRound: const Duration(seconds: 5),
            accelerationDuration: const Duration(seconds: 2),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(seconds: 2),
            decelerationCurve: Curves.easeInOut,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 150.0,
            velocity: 100.0,
          ),
        ),
        trailing: IconButton(
            onPressed: onClicked,
            icon: Icon(
              item.estado == 'A' ? Icons.close_rounded : item.estado == 'P' ? Icons.check_box : Icons.paypal,
              color: item.estado == 'A' ? boton2 : item.estado == 'P' ? grisoscuro : boton4,
              size: 32,
            )),
        onTap: () {
          for (var i = 0; i < servicios.length; i++) {
            servicios[i].estado = false;
          }
          item.estado == 'A' ?
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => RegisterPagoScreen(user: item)),
          ) : item.estado == 'P' ? 
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => UpdatePagoScreen(user: item)),
          ) : onClicked ;
        },
      ),
    );
  }
}


