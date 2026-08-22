import 'package:demo_shop/Helper/designHelper.dart';
import 'package:demo_shop/Helper/timeHelper.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, top: 30),
            child: Text(
              getGreeting(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70, bottom: 5),
            child: ShimmerText(
              baseColor: AppColors.primary,
              highlightColor: Colors.white,
              child: const Text(
                "HELENA",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .white, // must be white/opaque — ShaderMask needs full alpha to blend against
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
