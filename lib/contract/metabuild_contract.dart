import 'dart:math';

import 'package:debounce/constant/chain.dart';
import 'package:debounce/contract/multilcall.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class MetabuildContract {
  static String _address = '0x0EB32f0Ab3797117148B0Dd0C996ED61f9c9b91A';
  static final _abi = ContractAbi.fromJson(
      '[{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"clear","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"messages","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"offsets","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"uint256","name":"offset","type":"uint256"}],"name":"read","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"message","type":"string"}],"name":"sendMsg","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"string","name":"data","type":"string"}],"name":"write","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
      'Metabuild');

  Chain _chain = AURORA;
  DeployedContract _contract;

  MetabuildContract(this._contract, this._chain);

  factory MetabuildContract.fromChainId(int chainId) =>
      MetabuildContract(DeployedContract(_abi, EthereumAddress.fromHex(_address)), ChainData[chainId] ?? AURORA);

  Future<int> getOffsets(String account) async {
    if (account.isEmpty) return 0;

    try {
      final result = await Web3Client(_chain.rpc, Client()).call(
        contract: _contract,
        function: _contract.function('offsets'),
        params: [EthereumAddress.fromHex(account)],
      );

      return int.parse(result[0].toString());
    } catch (e) {
      print("get Offsets $e");
      return 0;
    }
  }

  Future<List<String>> getMessages(String account, int offset, {int limit = 20, bool desc = false}) async {
    if (account.isEmpty || offset == 0) return [];

    try {
      final count = min(offset, limit);
      final calls = List<int>.generate(count, (index) => max(0, offset - count) + index)
          .map((index) => MulticallCall(EthereumAddress.fromHex(_address), _abi.functions.firstWhere((each) => each.name == 'read'),
              [EthereumAddress.fromHex(account), BigInt.from(index)]))
          .toList();

      final resp = await Multicall.fromChain(ChainId.DEBOUNCE).aggregate(Web3Client(_chain.rpc, Client()), calls);
      final result = resp.map((each) => each.data[0].toString()).toList();
      return desc ? result.reversed.toList() : result;
    } catch (e) {
      print("get Messages $e");
      return [];
    }
  }

  Future<TransactionResponse?> sendMessage(String account, String message) async {
    if (account.isEmpty) return null;
    final abi = ["function sendMsg(string)"];

    try {
      final contract = Contract(_address, abi, Web3Provider(ethereum).getSigner());
      final estimateGas = await contract.estimateGas('sendMsg', [message]);
      return await contract.send('sendMsg', [message], TransactionOverride(gasLimit: BigInt.from(estimateGas * BigInt.from(3) / BigInt.two)));
    } catch (error) {
      print("sendMessage $error");
      return null;
    }
  }
}
