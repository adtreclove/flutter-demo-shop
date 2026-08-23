import 'dart:ui';

import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Controler/drawer_controller.dart';
import 'package:demo_shop/Helper/logHelper.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerState = ref.watch(drawerProvider);
    final notifier = ref.read(drawerProvider.notifier);

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      elevation: 1,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.glassStrong,
              border: Border(
                right: BorderSide(color: AppColors.glassBorder, width: 1),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // HEADER - Shop name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ALGO',
                          style: GoogleFonts.montserrat(
                            color: AppColors.textPrimary,
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: AppColors.glassBorder, height: 1),
                  ),

                  const SizedBox(height: 18),
                  // MENU
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12, bottom: 10),
                          child: Text(
                            'MENU',
                            style: GoogleFonts.montserrat(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),

                        ...DrawerItem.values
                            .where(
                              (item) =>
                                  (item != DrawerItem.logout) &&
                                  (item != DrawerItem.profile),
                            )
                            .map((item) {
                              final isSelected =
                                  item == drawerState.selectedItem;

                              return _DrawerItem(
                                item: item,
                                isSelected: isSelected,
                                onTap: () {
                                  coloredLog(
                                    'Drawer item selected: $item',
                                    color: LogColor.yellow,
                                    tag: 'CustomDrawer',
                                  );
                                  notifier.selectItem(item);
                                },
                              );
                            }),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(
                            color: AppColors.glassBorder,
                            height: 1,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 10),
                          child: Text(
                            'ACCOUNT',
                            style: GoogleFonts.montserrat(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),

                        _DrawerItem(
                          item: DrawerItem.profile,
                          isSelected: false,
                          isDestructive: false,
                          onTap: () {
                            coloredLog(
                              'Drawer item selected: $DrawerItem.profile',
                              color: LogColor.yellow,
                              tag: 'CustomDrawer',
                            );
                            notifier.selectItem(DrawerItem.profile);
                          },
                        ),
                        _DrawerItem(
                          item: DrawerItem.logout,
                          isSelected: false,
                          isDestructive: true,
                          onTap: () async {
                            coloredLog(
                              'Drawer item selected: $DrawerItem.logout',
                              color: LogColor.yellow,
                              tag: 'CustomDrawer',
                            );
                            await ref.read(authProvider.notifier).logout();
                            // reset drawer to home
                            notifier.selectItem(DrawerItem.home);
                          },
                        ),
                      ],
                    ),
                  ),

                  // VERSION
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Text(
                      'ALGO • v1.0.0',
                      style: GoogleFonts.montserrat(
                        color: AppColors.textDisabled,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.isDestructive = false,
  });

  final DrawerItem item;
  final bool isSelected;
  final bool isDestructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color accentColor = isDestructive
        ? AppColors.error
        : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.glassPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : Colors.transparent,
              ),
            ),

            child: Row(
              children: [
                // ICON
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.glassSubtle,

                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.4)
                          : AppColors.glassBorder,
                    ),
                  ),

                  child: Icon(_iconFor(item), size: 21, color: Colors.white),
                ),

                const SizedBox(width: 14),

                // LABEL
                Expanded(
                  child: Text(
                    _labelFor(item),
                    style: GoogleFonts.montserrat(
                      color: isSelected ? accentColor : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),

                // SELECTED INDICATOR
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSelected ? 1 : 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _labelFor(DrawerItem item) {
    switch (item) {
      case DrawerItem.home:
        return 'Home';

      case DrawerItem.profile:
        return 'Profile';

      case DrawerItem.search:
        return 'Search';

      case DrawerItem.category:
        return 'Categories';

      case DrawerItem.cart:
        return 'Cart';

      case DrawerItem.logout:
        return 'Log out';
    }
  }

  IconData _iconFor(DrawerItem item) {
    switch (item) {
      case DrawerItem.home:
        return Icons.home_outlined;

      case DrawerItem.profile:
        return Icons.person_outline;

      case DrawerItem.search:
        return Icons.search_outlined;

      case DrawerItem.category:
        return Icons.view_list_outlined;

      case DrawerItem.cart:
        return Icons.shopping_cart_outlined;

      case DrawerItem.logout:
        return Icons.logout_rounded;
    }
  }
}
