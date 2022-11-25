import 'package:debounce/constant/chain.dart';
import 'package:debounce/helper/local_manager.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';

class ConnectController extends GetxController {
  final RxString _address = ''.obs;
  final RxInt _chainId = ChainId.AURORA.obs;

  bool get isEnabled => ethereum != null;

  bool get isConnected => _address.value.isNotEmpty && isEnabled;

  int get chainId => _chainId.value;

  RxInt get chainIdRx => _chainId;

  String get address => _address.value;

  String get shortAddr => isConnected ? '${address.substring(0, 4)}..${address.substring(address.length - 4, address.length)}' : '';

  RxString get addressRx => _address;

  RxInt get chainRx => _chainId;

  Future<bool> isEthereumConnected() async {
    List<String>? accounts = await ethereum?.getAccounts();
    return accounts?.isNotEmpty ?? false;
  }

  @override
  onInit() async {
    super.onInit();
    await connect();
  }

  connect() async {
    if (isEnabled) {
      final accounts = await ethereum!.requestAccount();
      if (accounts.isNotEmpty) {
        _address.value = accounts.first;
        _chainId.value = (await ethereum!.getChainId());
      } else {
        reset();
      }
    } else {
      reset();
    }
  }

  Future<bool> changeNetwork(Chain chain) async {
    try {
      await ethereum!.walletSwitchChain(chain.chainId);
    } catch (e) {
      if (e is EthereumUserRejected) {
        return false;
      }

      try {
        await ethereum!.walletAddChain(
            chainId: chain.chainId,
            chainName: chain.name,
            rpcUrls: [chain.rpc],
            nativeCurrency: CurrencyParams(name: chain.name, symbol: chain.symbol, decimals: 18));
      } catch (err) {
        return false;
      }

      return false;
    }

    return true;
  }

  reset() {
    _address.value = "";
    _chainId.value = ChainId.AURORA;
    update();
  }

  start() async {
    if (isEnabled) {
      await connect();

      ethereum!.onAccountsChanged((accounts) {
        if (accounts.isEmpty) {
          reset();
        } else {
          connect();
        }
      });
      ethereum!.onChainChanged((_) async {
        await connect();
        await LocalManager.setChangeNetwork(address, true);
      });
    }
  }
}
