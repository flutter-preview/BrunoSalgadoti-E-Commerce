import 'package:ecommerce/common/custom_drawer/custom_drawer.dart';
import 'package:ecommerce/models/home_manager.dart';
import 'package:ecommerce/models/users_manager.dart';
import 'package:ecommerce/screens/home/components/add_section_widget.dart';
import 'package:ecommerce/screens/home/components/section_header.dart';
import 'package:ecommerce/screens/home/components/section_list.dart';
import 'package:ecommerce/screens/home/components/section_staggered.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    this.sectionHeader,
  }) : super(key: key);

  final SectionHeader? sectionHeader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(156, 162, 22, 22),
                  Color.fromARGB(239, 255, 137, 137),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: kIsWeb
                ? const EdgeInsets.all(0)
                : const EdgeInsets.only(top: 1.8),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  elevation: 4,
                  backgroundColor: Colors.white.withAlpha(100),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Image.asset(
                      'assets/logo/storeLogo2.png',
                      width: 150,
                      fit: BoxFit.fill,
                    ),
                    centerTitle: true,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (context.read<UserManager>().isLoggedIn) {
                          Navigator.pushNamed(context, '/cart');
                        } else {
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                      icon: Consumer<UserManager>(
                        builder: (_, userManager, __) {
                          return userManager.isLoggedIn
                              ? const Icon(Icons.shopping_cart)
                              : const Icon(Icons.account_circle);
                        },
                      ),
                      color: Colors.white,
                    ),
                    Consumer2<UserManager, HomeManager>(
                      builder: (_, userManager, homeManager, __) {
                        if (userManager.adminEnable && !homeManager.loading) {
                          return homeManager.editing
                              ? PopupMenuButton(
                                  onSelected: (e) {
                                    if (e == 'Salvar') {
                                      homeManager.saveEditing();
                                    } else {
                                      homeManager.discardEditing();
                                    }
                                  },
                                  itemBuilder: (_) {
                                    return ['Salvar', 'Descartar'].map((e) {
                                      return PopupMenuItem(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList();
                                  },
                                )
                              : IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: homeManager.enterEditing,
                                );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
                Consumer<HomeManager>(
                  builder: (_, homeManager, __) {
                    if (homeManager.loading) {
                      return const SliverToBoxAdapter(
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    }
                    final List<Widget> children =
                        homeManager.sections.map<Widget>((section) {
                      switch (section.type) {
                        case 'List':
                          return SectionList(section: section);
                        case 'Staggered':
                          return SectionStaggered(section: section);
                        default:
                          return Container();
                      }
                    }).toList();

                    if (homeManager.editing) {
                      children.add(AddSectionWidget(
                        homeManager: homeManager,
                      ));
                    }
                    return SliverList(
                      delegate: SliverChildListDelegate(children),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
