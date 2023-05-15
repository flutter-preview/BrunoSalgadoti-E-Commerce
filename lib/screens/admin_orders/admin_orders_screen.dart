import 'package:ecommerce/common/button/custom_icon_button.dart';
import 'package:ecommerce/common/custom_drawer/custom_drawer.dart';
import 'package:ecommerce/common/empty_indicator.dart';
import 'package:ecommerce/models/admin_orders_manager.dart';
import 'package:ecommerce/common/orders/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Pedidos Realizados'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, adminOrdersManager, __) {
          final filteredOrders = adminOrdersManager.filteredOrders;

          return Column(
            children: [
              if (adminOrdersManager.userFilter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pedidos de: ${adminOrdersManager.userFilter!.userName ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.close,
                        color: Colors.white,
                        onTap: () {
                          adminOrdersManager.setUserFilter(null);
                        },
                      )
                    ],
                  ),
                ),
              if (filteredOrders.isEmpty)
                const Expanded(
                    child: EmptyIndicator(
                  title: 'Aguardando vendas...',
                  iconData: Icons.border_clear,
                  image: null,
                ))
              else
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, index) {
                        return OrderTile(
                          filteredOrders[index],
                          showControls: true,
                        );
                      }),
                )
            ],
          );
        },
      ),
    );
  }
}
