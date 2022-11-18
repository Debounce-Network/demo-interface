import 'package:debounce/constant/chain.dart';
import 'package:debounce/controller/connector.dart';
import 'package:debounce/helper/local_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class NetworkSelector extends StatefulWidget {
  const NetworkSelector({super.key});

  @override
  State<StatefulWidget> createState() => _NetworkSelectorState();
}

class _NetworkSelectorState extends State<NetworkSelector> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<ConnectController>();
      const networks = [ChainId.AURORA, ChainId.AURORA_TEST, ChainId.POLYGON];
      final chainId = networks.contains(controller.chainId) ? controller.chainId : ChainId.AURORA;

      return DropdownButton(
          value: chainId,
          items: networks.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset(ChainData[value]!.logo, width: 24),
                const SizedBox(
                  width: 8,
                ),
                Text(ChainData[value]!.name, style: Get.textTheme.bodyMedium)
              ]),
            );
          }).toList(),
          onChanged: (int? chainId) async {
            if (await controller.changeNetwork(ChainData[chainId]!)) {
              await LocalManager.setChangeNetwork(controller.address, true);
              html.window.location.reload();
            }
          });
    });
  }
}
