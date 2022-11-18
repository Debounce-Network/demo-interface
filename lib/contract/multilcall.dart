import 'package:convert/convert.dart';
import 'package:debounce/constant/chain.dart';
import 'package:web3dart/web3dart.dart';

class MulticallCall {
  EthereumAddress target;
  ContractFunction function;
  List<dynamic> params;

  MulticallCall(this.target, this.function, this.params);
}

class AggregateResult {
  bool success;
  List<dynamic> data;

  AggregateResult(this.success, this.data);
}

class Multicall {
  static final ContractAbi _abi = ContractAbi.fromJson(
    '[{"inputs":[{"components":[{"internalType":"address","name":"target","type":"address"},{"internalType":"bytes","name":"callData","type":"bytes"}],"internalType":"struct Multicall2.Call[]","name":"calls","type":"tuple[]"}],"name":"aggregate","outputs":[{"internalType":"uint256","name":"blockNumber","type":"uint256"},{"internalType":"bytes[]","name":"returnData","type":"bytes[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"components":[{"internalType":"address","name":"target","type":"address"},{"internalType":"bytes","name":"callData","type":"bytes"}],"internalType":"struct Multicall2.Call[]","name":"calls","type":"tuple[]"}],"name":"blockAndAggregate","outputs":[{"internalType":"uint256","name":"blockNumber","type":"uint256"},{"internalType":"bytes32","name":"blockHash","type":"bytes32"},{"components":[{"internalType":"bool","name":"success","type":"bool"},{"internalType":"bytes","name":"returnData","type":"bytes"}],"internalType":"struct Multicall2.Result[]","name":"returnData","type":"tuple[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"name":"getBlockHash","outputs":[{"internalType":"bytes32","name":"blockHash","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getBlockNumber","outputs":[{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCurrentBlockCoinbase","outputs":[{"internalType":"address","name":"coinbase","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCurrentBlockDifficulty","outputs":[{"internalType":"uint256","name":"difficulty","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCurrentBlockGasLimit","outputs":[{"internalType":"uint256","name":"gaslimit","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCurrentBlockTimestamp","outputs":[{"internalType":"uint256","name":"timestamp","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"addr","type":"address"}],"name":"getEthBalance","outputs":[{"internalType":"uint256","name":"balance","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getLastBlockHash","outputs":[{"internalType":"bytes32","name":"blockHash","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bool","name":"requireSuccess","type":"bool"},{"components":[{"internalType":"address","name":"target","type":"address"},{"internalType":"bytes","name":"callData","type":"bytes"}],"internalType":"struct Multicall2.Call[]","name":"calls","type":"tuple[]"}],"name":"tryAggregate","outputs":[{"components":[{"internalType":"bool","name":"success","type":"bool"},{"internalType":"bytes","name":"returnData","type":"bytes"}],"internalType":"struct Multicall2.Result[]","name":"returnData","type":"tuple[]"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bool","name":"requireSuccess","type":"bool"},{"components":[{"internalType":"address","name":"target","type":"address"},{"internalType":"bytes","name":"callData","type":"bytes"}],"internalType":"struct Multicall2.Call[]","name":"calls","type":"tuple[]"}],"name":"tryBlockAndAggregate","outputs":[{"internalType":"uint256","name":"blockNumber","type":"uint256"},{"internalType":"bytes32","name":"blockHash","type":"bytes32"},{"components":[{"internalType":"bool","name":"success","type":"bool"},{"internalType":"bytes","name":"returnData","type":"bytes"}],"internalType":"struct Multicall2.Result[]","name":"returnData","type":"tuple[]"}],"stateMutability":"nonpayable","type":"function"}]',
    "Multicall2",
  );

  static final Map<int, String> _addresses = {
    ChainId.DEBOUNCE: '0xe7817b84902a38fFA630166b93c9fB4Bc31B55f2',
  };

  final DeployedContract contract;

  const Multicall(this.contract);

  factory Multicall.fromChain(int id) {
    if (!_addresses.keys.contains(id)) {
      throw ArgumentError('Invalid ChainId');
    }
    return Multicall(DeployedContract(_abi, EthereumAddress.fromHex(_addresses[id]!)));
  }

  Future<List<AggregateResult>> aggregate(Web3Client client, List<MulticallCall> calls) async {
    final result = await client.call(
      contract: contract,
      function: contract.function('tryAggregate'),
      params: [false, _encodeCallData(calls)],
    );

    return _decodeReturnData(calls, result[0]);
  }

  List<dynamic> _encodeCallData(List<MulticallCall> calls) {
    final calldata = [];
    for (var call in calls) {
      calldata.add([call.target, call.function.encodeCall(call.params)]);
    }
    return calldata;
  }

  List<AggregateResult> _decodeReturnData(List<MulticallCall> calls, List<dynamic> data) {
    final List<AggregateResult> responses = [];
    for (var i = 0; i < calls.length; i++) {
      try {
        final decoded = calls[i].function.decodeReturnValues(hex.encode((data[i][1])));
        responses.add(AggregateResult(data[i][0], decoded));
      } catch (err) {
        responses.add(AggregateResult(false, data[i][1]));
      }
    }
    return responses;
  }
}
