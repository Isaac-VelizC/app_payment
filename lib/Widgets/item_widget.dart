import 'package:app_payment/Screens/add_pago_screen.dart';
import 'package:app_payment/db/data/servicio.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserItemWidget extends StatelessWidget {
  final Inquilino item;
  final Animation animation;
  final VoidCallback onClicked;
  const UserItemWidget(
      {super.key,
      required this.item,
      required this.animation,
      required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade600,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(-5, 0),
          )
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        leading: const CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(
              'https://th.bing.com/th/id/R.27d2dd521054771968a761d579f5d100?rik=k6N4NeLGA0SkAA&pid=ImgRaw&r=0'),
        ),
        title: Text(
          '${item.nombre} ${item.apellidos}',
          style: const TextStyle(fontSize: 20),
        ),
        trailing: IconButton(
            onPressed: onClicked,
            icon: const Icon(
              Icons.check_circle,
              color: Colors.greenAccent,
              size: 32,
            )),
        onTap: () {
          for (var i = 0; i < servicios.length; i++) {
            servicios[i].estado = false;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => RegisterPagoScreen(user: item)),
          );
        },
      ),
    );
  }
}
