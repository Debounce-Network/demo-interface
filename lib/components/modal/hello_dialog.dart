import 'package:debounce/components/button/button.dart';
import 'package:debounce/components/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelloDialog extends StatefulWidget {
  HelloDialog({super.key, required this.onSend});

  Function(String) onSend;

  @override
  State<StatefulWidget> createState() => _HelloDialogState();
}

class _HelloDialogState extends State<HelloDialog> {
  bool checked = false;
  String name = '';

  onClose() {
    Get.back();
  }

  Future<void> onEnter() async {
    await widget.onSend(name);
    onClose();
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Welcome", style: Get.textTheme.bodyLarge),
        InkWell(
            onTap: onClose,
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.clear,
                    size: 24,
                  ),
                )))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        title: title(),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Flexible(
                  child: Row(children: [
                Text("My name is", style: Get.textTheme.bodyMedium),
                const SizedBox(width: 8),
                Container(
                    width: 150,
                    padding: const EdgeInsets.only(left: 4, right: 4, bottom: 2),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      width: 2,
                    ))),
                    child: Text(name, style: Get.textTheme.bodyMedium))
              ])),
              const SizedBox(height: 32),
              Row(
                children: [
                  SearchInput(
                      debounce: false,
                      onCallback: (val) {
                        setState(() {
                          name = val;
                        });
                      }),
                  const SizedBox(
                    width: 16,
                  ),
                  Button(
                    width: 48,
                    height: 48,
                    onClick: onEnter,
                    text: 'Ok',
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

void showHelloDialog(Function(String) onSend) {
  if (Get.isDialogOpen ?? false) Get.back();
  Get.generalDialog(
    pageBuilder: (context, animation, secondaryAnimation) {
      return HelloDialog(
        onSend: onSend,
      );
    },
  );
}
