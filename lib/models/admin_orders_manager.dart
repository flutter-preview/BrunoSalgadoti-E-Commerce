import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/order_client.dart';
import 'package:flutter/cupertino.dart';

class AdminOrdersManager extends ChangeNotifier {

  List<OrderClient> orders = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  void updateAdmin({required bool adminEnable}) {
    orders.clear();

    _subscription?.cancel();
    if (adminEnable) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders').snapshots().listen(
            (events) {
              for(final change in events.docChanges){
                switch(change.type){
                  case DocumentChangeType.added:
                    orders.add(
                        OrderClient.fromDocument(change.doc)
                    );
                    break;
                  case DocumentChangeType.modified:
                    final modOrder = orders.firstWhere(
                            (element) => element.orderId == change.doc.id);
                    modOrder.updateFromDocument(change.doc);
                    break;
                  case DocumentChangeType.removed:
                    break;
                }
              }
          
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}