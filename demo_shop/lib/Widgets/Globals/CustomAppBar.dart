import 'package:demo_shop/Controler/cart_controller.dart';
import 'package:demo_shop/Controler/drawer_controller.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, this.title, this.actions});

  // padding left 10.0 for title

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartTotalProvider);

    final resolvedActions = <Widget>[
      ...?actions,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${cart.toString()} \$",
            style: GoogleFonts.montserrat(
              color: AppColors.textPrimary,
              fontSize: 17,
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(left: 5, right: 10),
            onPressed: () {
              ref.read(drawerProvider.notifier).selectItem(DrawerItem.cart);
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
    ];

    return AppBar(
      backgroundColor: AppColors.background,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(title ?? ""),
      ),
      actions: resolvedActions,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // coloredLog(
            //   "Drawer button pressed",
            //   color: LogColor.green,
            //   tag: "CustomAppBar",
            // );
            ref.read(drawerProvider.notifier).toggle();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
