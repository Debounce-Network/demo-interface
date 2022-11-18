class ScenarioStrings {
  String nickname = '';

  ScenarioStrings({required this.nickname});

  String get userMessage1 => 'Hello, Debounce Network! My name is $nickname';

  String get debounceMessage1 =>
      'Welcome to the Debounce Network, $nickname! \n\nDebounce is a decentralized database-specific side chain based on EVM.';

  String currentNetwork(String chain) => 'You are currently connected to the $chain Network,';

  String get changeNetwork =>
      'but this conversation is stored in the Debounce network. Therefore, I can recognize you no matter which chain you are connected to. Change your network!';

  String changed(String chain) =>
      'Welcome back, $nickname. You are currently connected to $chain.';

  String get changed1 => "Debounce is EVM compatible and  you can also sign on the Debounce Network. Try it!";

  String debounceMessage2(String sig) => 'Good job, $nickname! The signature is "$sig" and it is stored in Debounce Network.';

  String get debounceMessage3 => 'You can use this signature on any chain (Of course, the signature has to be acknowledged by the Dapp.)';

  static String get oracleMessage =>
      'Debounce is also a data marketplace.If you want to sell your data, you can do so by participating in the Debounce Node.';
}
