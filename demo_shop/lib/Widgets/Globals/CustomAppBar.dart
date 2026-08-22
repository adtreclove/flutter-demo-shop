import 'package:demo_shop/Controler/drawer_controller.dart';
import 'package:demo_shop/Helper/logHelper.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, this.title, this.actions});

  // padding left 10.0 for title

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.background,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(title ?? ""),
      ),
      actions: actions,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            coloredLog(
              "Drawer button pressed",
              color: LogColor.green,
              tag: "CustomAppBar",
            );
            ref.read(drawerProvider.notifier).toggle();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
