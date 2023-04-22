import 'package:app_payment/Screens/add_pago_screen.dart';
import 'package:app_payment/db/data/servicio.dart';
import 'package:app_payment/db/models/inquilinos.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

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
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(70, 205, 205, 205),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        leading: const CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png'),
        ),
        title: SizedBox(
          height: 25,
          width: 25,
          child: Marquee(
            text: '${item.nombre} ${item.apellidos}',
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
