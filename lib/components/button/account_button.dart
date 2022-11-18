import 'package:debounce/constant/chain.dart';
import 'package:debounce/controller/connector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountButton extends GetView<ConnectController> {
  const AccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final supported = isSupportedChain(controller.chainId);

      return InkWell(
          onTap: controller.connect,
          child: Row(
            children: [
              Text(
                  !controller.isConnected
                      ? 'Connect'
                      : supported
                          ? controller.shortAddr
                          : 'Change Network',
                  style: Get.textTheme.bodyMedium)
            ],
          ));
    });
  }
}
