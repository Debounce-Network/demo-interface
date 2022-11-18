import 'package:debounce/constant/chain.dart';
import 'package:debounce/contract/metabuild_contract.dart';
import 'package:debounce/controller/connector.dart';
import 'package:debounce/controller/debounce_controller.dart';
import 'package:debounce/helper/local_manager.dart';
import 'package:debounce/helper/signature_helper.dart';
import 'package:debounce/model/message.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:get/get.dart';

enum ScenarioStep { changeToDB, signInDB, changeToService, txInService }

class MessageController extends GetxController with StateMixin<bool> {
  final RxString _message = ''.obs;
  final Rx<ScenarioStep> _signStep = ScenarioStep.changeToDB.obs;
  final RxBool _expandSignStep = false.obs;

  String _signature = '';

  String get message => _message.value;

  ScenarioStep get signStep => _signStep.value;

  bool get expand => _expandSignStep.value;

  bool get isChangeDBStep => signStep == ScenarioStep.changeToDB;

  bool get isSignDBStep => signStep == ScenarioStep.signInDB;

  bool get isChangeServiceStep => signStep == ScenarioStep.changeToService;

  bool get isTxServiceStep => signStep == ScenarioStep.txInService;

  onChange(String val) {
    _message.value = val;
    _message.refresh();
  }

  Future<TransactionResponse?> onSend(String message) async {
    ConnectController connector = Get.find();
    if (!connector.isConnected) return null;

    final contract = MetabuildContract.fromChainId(connector.chainId);
    final resp = await contract.sendMessage(connector.address, message);

    if (resp != null) {
      LocalManager.setTxOffset(connector.address, Get.find<DebounceController>().offset);
      LocalManager.setServiceChain(connector.address, connector.chainId);
    }

    return resp;
  }

  toggleSignStep() {
    _expandSignStep.value = !expand;
    _expandSignStep.refresh();
  }

  changeToDB() async {
    final connector = Get.find<ConnectController>();
    await LocalManager.setServiceChain(connector.address, connector.chainId);
    if (await connector.changeNetwork(DEBOUNCE)) {
      _setSignStep(ScenarioStep.signInDB);
    }
  }

  signInDB() async {
    final message = Message(message: "save signature", timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000);
    _signature = await SignatureHelper.sign(message.toJson()) ?? '';
    if (_signature.isNotEmpty) {
      _setSignStep(ScenarioStep.changeToService);
    }
  }

  changeToService() async {
    final connector = Get.find<ConnectController>();
    final serviceChainId = await LocalManager.getServiceChain(connector.address);

    if (await connector.changeNetwork(ChainData[serviceChainId]!)) {
      _setSignStep(ScenarioStep.txInService);
    }
  }

  txInService() async {
    final resp = await onSend(_signature);
    if (resp != null) {
      _signature = '';
      _expandSignStep.value = false;
      _expandSignStep.refresh();
    }
  }

  _setSignStep(ScenarioStep step) {
    _signStep.value = step;
    _signStep.refresh();
  }
}
