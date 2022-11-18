import 'dart:async';

import 'package:debounce/constant/chain.dart';
import 'package:debounce/contract/metabuild_contract.dart';
import 'package:debounce/controller/connector.dart';
import 'package:debounce/helper/local_manager.dart';
import 'package:debounce/helper/scenario_strings.dart';
import 'package:debounce/model/message.dart';
import 'package:get/get.dart';

class DebounceController extends GetxController with StateMixin<bool> {
  final RxList<Message> _messages = <Message>[].obs;
  final RxInt _offset = 0.obs;
  final RxBool _pending = false.obs;
  final RxBool _reload = false.obs;

  Timer? _timer;

  List<Message> get messages => _messages.value;

  int get offset => _offset.value;

  bool get isZeroStep => offset == 0;

  bool get isSignStep => offset == 1;

  bool get isPending => _pending.value;

  bool get reload => _reload.value;

  @override
  onInit() {
    super.onInit();
    ConnectController connector = Get.find();

    connector.addressRx.listen((p0) {
      start();
    });

    change(false, status: RxStatus.loading());
  }

  start() async {
    stop();

    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetch();
    });
  }

  stop() {
    _timer?.cancel();
  }

  reset() {
    _offset.value = 0;
    _messages.clear();
  }

  _fetch() async {
    ConnectController connector = Get.find();

    if (!connector.isConnected) return;

    // save last messages
    final contract = MetabuildContract.fromChainId(ChainId.DEBOUNCE);
    _offset.value = await contract.getOffsets(connector.address);
    _offset.refresh();

    final resp = await contract.getMessages(connector.address, offset);
    _messages.value = await _convert(resp);
    _messages.refresh();

    await _updateOffset();

    change(true, status: RxStatus.success());
  }

  Future<List<Message>> _convert(List<String> list) async {
    List<Message> result = [];

    if (list.isEmpty) {
      reset();
      return result;
    }

    final helper = ScenarioStrings(nickname: list[0]);

    ConnectController connector = Get.find();
    _reload.value = await LocalManager.getChangeNetwork(connector.address);
    _reload.refresh();

    final currentChain = ChainData[connector.chainId];

    if (reload) {
      result.add(Message(message: helper.changed(currentChain!.name)));
      result.add(Message(message: helper.changed1));
    } else {
      result.add(Message(message: helper.userMessage1, isUser: true));
      result.add(Message(message: helper.debounceMessage1));
      result.add(Message(message: helper.currentNetwork(currentChain!.name)));
      result.add(Message(message: helper.changeNetwork));
    }

    if (list.length >= 2) {
      result.add(Message(message: helper.debounceMessage2(list[1])));
      result.add(Message(message: helper.debounceMessage3));

      for (var i = 2; i < list.length; i++) {
        result.add(Message(message: list[i], isUser: true));
      }
    }

    return result;
  }

  _updateOffset() async {
    final account = Get.find<ConnectController>().address;
    final finished = await LocalManager.getTxOffset(account);

    if (finished > offset) {
      LocalManager.setTxOffset(account, -1);
    }

    _pending.value = offset <= finished;
    _pending.refresh();
  }
}
