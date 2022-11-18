import 'package:debounce/components/button/button.dart';
import 'package:debounce/components/messages/messages.dart';
import 'package:debounce/components/modal/hello_dialog.dart';
import 'package:debounce/components/news/news_feed.dart';
import 'package:debounce/controller/connector.dart';
import 'package:debounce/controller/debounce_controller.dart';
import 'package:debounce/controller/message_controller.dart';
import 'package:debounce/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String message1 = 'Hello Debounce';
String message2 = 'sign message';
String message3 = 'clear message';

String signMessage1 = '1. change to Debounce chain';
String signMessage2 = '2. sign message in Debounce chain';
String signMessage3 = '3. change to service chain';
String signMessage4 = '4. save signature';

String debounceMessage =
    'Debounce Network is currently in alpha development stage and our goal is to transform the web2 data market into web3 in the most decentralized way and to keep the context of the EOA across chains.\n\nWe are everywhere and near you!';

class Demo extends GetView<MessageController> {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MessageController());

    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                "Demo #1 - Context store",
                style: Get.textTheme.titleMedium,
              ),
              const SizedBox(
                height: 24,
              ),
              _buttons(),
              const SizedBox(
                height: 16,
              ),
              _signButtons(),
              const Messages(),
              divider,
              const NewsFeed(),
              divider,
              Text(debounceMessage),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ));
  }

  Widget _buttons() {
    final dbController = Get.find<DebounceController>();
    final connector = Get.find<ConnectController>();

    return Wrap(
      direction: Axis.horizontal,
      spacing: 8,
      runSpacing: 8,
      children: [
        Obx(() => Button(
              text: message1,
              disabled: !connector.isConnected || dbController.isPending || !dbController.isZeroStep,
              onClick: () {
                showHelloDialog(controller.onSend);
              },
            )),
        Obx(() => Button(
              text: message2,
              disabled: !connector.isConnected || !dbController.reload || dbController.isPending || !dbController.isSignStep,
              onClick: controller.toggleSignStep,
            )),
        Button(
          text: message3,
          onClick: () {
            controller.onSend('clear');
          },
        )
      ],
    );
  }

  Widget _signButtons() {
    return Obx(() {
      if (!controller.expand) return const SizedBox();

      return Column(
        children: [
          Wrap(
            direction: Axis.vertical,
            spacing: 8,
            runSpacing: 8,
            children: [
              Obx(() => Button(
                    width: 500,
                    text: signMessage1,
                    disabled: !controller.isChangeDBStep,
                    onClick: controller.changeToDB,
                  )),
              Obx(() => Button(
                    width: 500,
                    text: signMessage2,
                    disabled: !controller.isSignDBStep,
                    onClick: controller.signInDB,
                  )),
              Obx(() => Button(
                    width: 500,
                    text: signMessage3,
                    disabled: !controller.isChangeServiceStep,
                    onClick: controller.changeToService,
                  )),
              Obx(() => Button(
                    width: 500,
                    text: signMessage4,
                    disabled: !controller.isTxServiceStep,
                    onClick: controller.txInService,
                  ))
            ],
          ),
          const SizedBox(
            height: 24,
          )
        ],
      );
    });
  }

  Widget get divider => Container(margin: const EdgeInsets.symmetric(vertical: 48), width: double.infinity, height: 1, color: disabledBg);
}
