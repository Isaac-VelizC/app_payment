import 'package:app_payment/Screens/print_screen.dart';
import 'package:app_payment/db/models/pagos.dart';
import 'package:app_payment/themes/colors.dart';
import 'package:app_payment/themes/style_text.dart';
import 'package:flutter/material.dart';

class ListNewWidget extends StatelessWidget {
  final Future<List<Pago>> pago;
  const ListNewWidget({super.key, required this.pago});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pago,
      builder: (BuildContext context, AsyncSnapshot<List<Pago>?> snapshot) {
        final pago = snapshot.data ?? [];
        return Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const StyleText(text: 'Recientes', colors: negro),
              SizedBox(
                height: 270,
                child: ListView.builder(
                  itemCount: pago.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Card(
                        color: Colors.primaries[index % Colors.primaries.length],
                        child: ListTile(
                          title: Text(
                            'Cliente: ${pago[index].nombre} ${pago[index].apellidos}',
                            style: const TextStyle(color: blanco),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
