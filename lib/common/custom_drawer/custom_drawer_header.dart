import 'package:ecommerce/models/page_manager.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(25, 15, 40, 8),
        height: 240,
        child: Consumer<UserManager>
          (builder: (_, userManager, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //TODO: Implementação da variável no gerenciamento
             if (userManager.image != null)
               ...[
                   const Text(
                   'Loja Virtual:',
                   style:
                   TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                 ),
                  Image.asset(
                    'assets/logo/storeLogo.png',
                    height: 130,
                    fit: BoxFit.fill,
                  )
                 ]
             else
               const Text(
                'Loja Virtual:\n BRN Info_Dev',
                style:
                    TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              Text(
                'Bem-Vindo(a)! ${userManager.users?.userName ?? ''}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  if (userManager.isLoggedIn) {
                    userManager.signOut();
                    context.read<PageManager>().setPage(0);
                  } else {
                    Navigator.pushNamed(context, '/login');
                  }
                },
                child: Text(
                  userManager.isLoggedIn ? 'Sair' : 'Entre ou Cadastre-se >',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        }));
  }
}
