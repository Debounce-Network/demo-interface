import 'package:debounce/components/loading/loading.dart';
import 'package:debounce/components/rect/dash_rect.dart';
import 'package:debounce/controller/debounce_controller.dart';
import 'package:debounce/model/message.dart';
import 'package:debounce/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Messages extends GetView<DebounceController> {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return DashedRect(
        child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final list = controller.messages;

        if (controller.status.isLoading) return const SizedBox(height: 200, child: Loading());

        if (list.isEmpty) return _empty;

        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Message message = list[index];
                return Row(
                  mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 450,
                        decoration: BoxDecoration(
                          color: message.isUser ? greyTxt : blackHover,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Align(
                            alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Text(
                              message.message,
                            )))
                  ],
                );
              },
              separatorBuilder: (_, index) => const SizedBox(
                    height: 16,
                  ),
              itemCount: list.length),
          _loader
        ]);
      }),
    ));
  }

  Widget get _loader {
    if (!controller.isPending) return const SizedBox();

    return Column(
      children: const [
        SizedBox(
          height: 24,
        ),
        Loading()
      ],
    );
  }

  Widget get _empty => SizedBox(
      height: 120,
      child: Column(
        children: [
          const Text(
            "Start scenario",
            textAlign: TextAlign.center,
          ),
          _loader
        ],
      ));
}
