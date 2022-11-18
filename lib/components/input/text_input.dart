import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key, this.debounce = true, required this.onCallback});

  final bool debounce;
  final Function(String value) onCallback;

  @override
  State<StatefulWidget> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController controller = TextEditingController();

  Timer? _debounce;

  onChange(String val) {
    if (!widget.debounce) {
      widget.onCallback(val);
      return;
    }

    if ((_debounce?.isActive ?? false)) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onCallback(val);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100),
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 8),
            child: TextField(
              autofocus: false,
              controller: controller,
              cursorColor: Colors.black,
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 20),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  hintText: 'Input your name',
                  hintStyle: Get.textTheme.bodySmall?.copyWith(color: Colors.white),
                  isDense: true),
              onChanged: onChange,
            ),
          ),
          // const Icon(Icons.search, size: 20, color: Colors.white)
        ],
      ),
    );
  }
}
