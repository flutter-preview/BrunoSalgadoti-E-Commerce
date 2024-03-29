import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/order_client.dart';
import 'package:ecommerce/models/users.dart';
import 'package:flutter/cupertino.dart';

class AdminOrdersManager extends ChangeNotifier {
  final List<OrderClient> _orders = [];

  Users? userFilter;
  List<Status> statusFilter = [Status.preparing, Status.transporting];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  void updateAdmin({required bool adminEnable}) {
    _orders.clear();

    _subscription?.cancel();
    if (adminEnable) {
      _listenToOrders();
    }
  }

  List<OrderClient> get filteredOrders {
    List<OrderClient> output = _orders.reversed.toList();
    
    if(userFilter != null) {
      output = output.where((o) => o.userId == userFilter!.id).toList();
    }
    
    return output = output.where((o) => statusFilter.contains(o.status)).toList();
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen((events) {
      for (final change in events.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(OrderClient.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final modOrder = _orders
                .firstWhere((element) => element.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            break;
        }
      }
      notifyListeners();
    });
  }

  void setUserFilter(Users? user) {
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status? status, bool? enabled}){
    if(enabled!){
      statusFilter.add(status!);
    } else{
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
