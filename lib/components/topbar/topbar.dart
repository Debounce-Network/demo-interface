import 'package:debounce/components/button/button.dart';
import 'package:debounce/styles.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: disabledBg))),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Image.asset(
              'assets/logo/debounce_logo.png',
              height: 32,
            ),
            const SizedBox(
              width: 16,
            ),
            Button(
              fontSize: ButtonTextSize.small,
              width: 80,
              text: 'Explorer',
              onClick: () {
                html.window.open('https://explorer.debounce.network', '_blank');
              },
            )
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
