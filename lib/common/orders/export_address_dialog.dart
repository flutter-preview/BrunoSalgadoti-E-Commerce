import 'dart:ffi';

import 'package:ecommerce/common/button/custom_button.dart';
import 'package:ecommerce/common/button/custom_text_button.dart';
import 'package:ecommerce/common/show_alert_dialog.dart';
import 'package:ecommerce/models/address.dart';
import 'package:ecommerce/models/order_client.dart';
import 'package:flutter/material.dart';

class ExportAddressDialog extends StatelessWidget {
  const ExportAddressDialog(this.address, this.orderClient,
      {Key? key}) : super(key: key);

  final Address? address;
  final OrderClient? orderClient;

  @override
  Widget build(BuildContext context) {
         return ShowAlertDialog(
           titleText: 'Endereço de Entrega',
           titleColor: Colors.black,
           titleSize: 19,
           bodyText: 'Destinatário:  ${orderClient?.userName ?? '' }\n'
               '${address!.street ?? ''}, ${address!.number ?? ''},\n'
               '${address!.district ?? ''}\n'
               '${address!.city ?? ''}-${address!.state ?? ''}\n'
               '${address!.zipCode ?? ''}\n'
               '${address?.complement ?? ''}',
           bodyWeight: FontWeight.normal,
           bodyAlign: TextAlign.start,
           contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
           actions: [
             CustomTextButton(
             text: 'Exportar',
             icon: null,
             onPressed: () {

             },
         )
           ],
         );
  }
}
