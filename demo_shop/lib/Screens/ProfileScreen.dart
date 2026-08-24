import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Controler/cart_controller.dart';
import 'package:demo_shop/Controler/drawer_controller.dart';
import 'package:demo_shop/Screens/FavoritesScreen.dart';
import 'package:demo_shop/Screens/OrderScreen.dart';
import 'package:demo_shop/Screens/SettingsScreen.dart';
import 'package:demo_shop/Widgets/Profile/ProfileMenuItem.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final cartItemCount = ref.watch(cartItemCountProvider);

    if (user == null) {
      // Shouldn't normally happen (ProfileScreen only shows once logged
      // in), but avoids a crash if this ever gets built during a
      // logout transition.
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  backgroundImage: user.image.isNotEmpty
                      ? NetworkImage(user.image)
                      : null,
                  child: user.image.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user.fullName,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 45),

          ProfileMenuItem(
            icon: Icons.shopping_bag_outlined,
            label: 'My orders',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
          ProfileMenuItem(
            icon: Icons.shopping_cart_outlined,
            label: 'Cart',
            trailing: cartItemCount > 0
                ? CountBadge(count: cartItemCount)
                : null,
            onTap: () {
              ref.read(drawerProvider.notifier).selectItem(DrawerItem.cart);
            },
          ),
          ProfileMenuItem(
            icon: Icons.favorite_border,
            label: 'Favorites',

            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteScreen()),
            ),
          ),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),

          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text(
                  'Logout',
                  style: GoogleFonts.montserrat(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
