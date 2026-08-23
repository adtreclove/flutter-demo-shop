import 'package:demo_shop/Controler/drawer_controller.dart';
import 'package:demo_shop/Core/Navigation/scaffoldKey.dart';
import 'package:demo_shop/Screens/CartScreen.dart';
import 'package:demo_shop/Screens/CategoryScreen.dart';
import 'package:demo_shop/Screens/HomeScreen.dart';
import 'package:demo_shop/Screens/SearchScreen.dart';
import 'package:demo_shop/Widgets/Globals/AppBar/CustomAppBar.dart';
import 'package:demo_shop/Widgets/Globals/Drawer/CustomDrawer.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerProvider);

    return Scaffold(
      key: scaffoldKey,
      onDrawerChanged: (isOpen) {
        ref.read(drawerProvider.notifier).setOpenState(isOpen);
      },
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(
          drawerState.isOpen ? 250 : 0,
          0,
          0,
        ),
        child: _CurrentPage(selectedItem: drawerState.selectedItem),
      ),
    );
  }
}

class _CurrentPage extends StatelessWidget {
  const _CurrentPage({required this.selectedItem});

  final DrawerItem selectedItem;

  @override
  Widget build(BuildContext context) {
    switch (selectedItem) {
      case DrawerItem.home:
        return const HomeScreen();

      case DrawerItem.category:
        return const CategoryScreen();

      case DrawerItem.search:
        return const SearchScreen();

      case DrawerItem.cart:
        return const CartScreen();

      case DrawerItem.profile:
        return const SizedBox.shrink();

      case DrawerItem.logout:
        return const SizedBox.shrink();
    }
  }
}
