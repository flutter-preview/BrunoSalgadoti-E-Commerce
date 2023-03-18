import 'package:ecommerce/common/custom_drawer/custom_drawer.dart';
import 'package:ecommerce/models/page_manager.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:ecommerce/screens/admin_users/admin_users_screen.dart';
import 'package:ecommerce/screens/home/home_screen.dart';
import 'package:ecommerce/screens/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
   BaseScreen({Key? key,}) : super(key: key);

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(),
              const ProductsScreen(),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home3'),
                ),
              ),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home4'),
                ),
              ),
             if(userManager.adminEnable)
               ...[
                   const AdminUsersScreen(),
                 Scaffold(
                   drawer:   const CustomDrawer(),
                   appBar: AppBar(
                     title:  const Text('Pedidos'),
                   ),
                 ),
               ]
            ],
          );
        },
      ),
    );
  }
}
