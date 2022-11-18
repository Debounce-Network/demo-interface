class Chain {
  final int chainId;
  final String name;
  final String symbol;
  final String logo;
  final String rpc;
  final String explorer;

  Chain({required this.chainId, required this.name, required this.symbol, required this.logo, required this.rpc, required this.explorer});
}

class ChainId {
  static const POLYGON = 137;
  static const AURORA = 1313161554;
  static const AURORA_TEST = 1313161555;
  static const DEBOUNCE = 3306;
}

Chain POLYGON = Chain(
    chainId: ChainId.POLYGON,
    name: 'POLYGON',
    symbol: 'MATIC',
    logo: 'assets/logo/polygon.png',
    rpc: 'https://polygon-rpc.com',
    explorer: 'https://polygonscan.com/');
Chain AURORA = Chain(
    chainId: ChainId.AURORA,
    name: 'Aurora',
    symbol: 'ETH',
    logo: 'assets/logo/aurora.png',
    rpc: 'https://mainnet.aurora.dev',
    explorer: 'https://aurorascan.dev/');
Chain AURORA_TEST = Chain(
    chainId: ChainId.AURORA_TEST,
    name: 'Aurora Testnet',
    symbol: 'ETH',
    logo: 'assets/logo/aurora.png',
    rpc: 'https://testnet.aurora.dev',
    explorer: 'https://testnet.aurorascan.dev/');
Chain DEBOUNCE = Chain(
    chainId: ChainId.DEBOUNCE,
    name: 'Debounce',
    symbol: 'DB',
    logo: 'assets/logo/db.png',
    rpc: 'https://dev-rpc.debounce.network/',
    explorer: 'https://explorer.debounce.network/');

Map<int, Chain> ChainData = {ChainId.POLYGON: POLYGON, ChainId.AURORA: AURORA, ChainId.AURORA_TEST: AURORA_TEST, ChainId.DEBOUNCE: DEBOUNCE};

bool isSupportedChain(int chain) => [ChainId.DEBOUNCE, ChainId.POLYGON, ChainId.AURORA, ChainId.AURORA_TEST].contains(chain);
