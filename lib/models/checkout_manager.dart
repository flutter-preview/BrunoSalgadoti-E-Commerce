import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/cart_manager.dart';
import 'package:ecommerce/models/order_client.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {required Function onStockFail, required Function onSuccess}) async {

    loading = true;

    try {
      await _decrementStock();
    } catch (error) {
      onStockFail(error);
      loading = false;
      return;
    }

    //TODO: PROCESSAR PAGAMENTO

    final orderId = await _getOrderId();

    final order = OrderClient.fromCartManager(cartManager!);
    order.orderId = orderId.toString();

    await order.saveOrder();

    cartManager!.clear();

    onSuccess(order);
    loading = false;
  }

  Future<int> _getOrderId() async {
    final transactionRef = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(transactionRef);
        final orderId = doc.get('current') as int;
        tx.update(transactionRef, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (error) {
      debugPrint(error.toString());
      return Future.error('Falha ao gerar número do pedido!');
    }
  }

  Future<void> _decrementStock() async {
    // 1. Ler todos os estoques
    // 2. Decrementar localmente os estoques
    // 3. Salvar os estoques no Firebase

    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for (final cartProduct in cartManager!.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc =
              await tx.get(firestore.doc('products/${cartProduct.productId}'));
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;
        notifyListeners();

        final details = product.findSize(cartProduct.size!);
        if (details!.stock - cartProduct.quantity! < 0) {
          productsWithoutStock.add(product);
        } else {
          details.stock -= cartProduct.quantity!;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error('${productsWithoutStock.length} '
            'Estoque modificado antes da finalização da compra!'
            'Favor Verificar quantidade!');
      }

      for (final product in productsToUpdate) {
        tx.update(firestore.doc('products/${product.id}'),
            {'details': product.exportDetailsList()});
      }
    });
  }
}
