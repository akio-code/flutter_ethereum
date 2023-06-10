import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'widgets/balance.dart';
import 'widgets/transfer.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({super.key});

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  // Ganache
  final String privateKey =
      '0x15894c3296208e7fdbff3d554b518ba182e45b8801bdb883e1e2b087860f9565';
  final String rcpUrl = 'HTTP://127.0.0.1:8545';

  late Client httpClient;
  late Web3Client web3client;
  late EthPrivateKey credentials;
  late EthereumAddress address;

  double _balance = 0;

  final _pageViewController = PageController();
  int _selectedPage = 0;

  void _changePage(int index) {
    _selectedPage = index;
    _pageViewController.animateToPage(
      index,
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  void _onPageViewChanged(int index) {
    _selectedPage = index;
    setState(() {});
  }

  /// Loads a contract from the ABI (Application Binary Interface) and returns a DeployedContract instance.
  ///
  /// This function loads the contract ABI from the 'abi.json' file located in the 'assets' directory.
  /// It creates a DeployedContract object using the loaded ABI and the contract address.
  ///
  /// Returns:
  /// A [Future] that resolves to a [DeployedContract] instance representing the contract.
  Future<DeployedContract> loadContract() async {
    final abi = await rootBundle.loadString('assets/abi.json');
    const contractAddress = '0x31C35074bf8C0A339b7e868dbba6eD6C353AC5CA';

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, 'AkioKoin'),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  /// Sends a query to a contract function and returns the result as a list of dynamic values.
  ///
  /// Parameters:
  /// - [fnName]: The name of the contract function to query.
  /// - [params]: The list of parameters to pass to the contract function.
  ///
  /// Returns:
  /// A [Future] that resolves to a list of dynamic values representing the result of the contract function call.
  Future<List<dynamic>> _query(String fnName, List<dynamic> params) async {
    final contract = await loadContract();
    final contractFn = contract.function(fnName);

    final result = await web3client.call(
      contract: contract,
      function: contractFn,
      params: params,
    );

    return result;
  }

  /// Retrieves the account balance for the specified address and updates the local balance state variable.
  ///
  /// This function sends a query to the contract's 'balanceOf' function with the given [address] as a parameter.
  /// The returned balance value is extracted from the query result list and stored in the [_balance] variable.
  /// The balance is converted from Wei to Ether by dividing it by the decimal factor of 10^18 and then converted to a double.
  /// Finally, the widget's state is updated using [setState].
  ///
  /// Note: This function assumes that the 'balanceOf' function in the contract returns a single balance value as the first element of the result list.
  Future<void> _getBalance() async {
    final List<dynamic> result = await _query('balanceOf', [address]);
    _balance = (result[0] ~/ BigInt.from(pow(10, 18))).toDouble();
    setState(() {});
  }

  /// Sends a transaction to transfer a specified value to a given recipient address.
  ///
  /// This function sends a transaction to the blockchain to invoke the 'transfer' function of the deployed contract.
  /// The transaction transfers the specified [value] to the recipient address [to].
  /// The transaction is signed using the provided [credentials] and sent with the corresponding [chainId].
  ///
  /// Parameters:
  /// - [to]: The recipient address to transfer the value to.
  /// - [value]: The value to transfer.
  ///
  /// Returns:
  /// A [Future] that resolves to a transaction hash representing the transaction on the blockchain.
  Future<String> _sendTransaction(String to, BigInt value) async {
    final chainId = await web3client.getChainId();
    final contract = await loadContract();
    final function = contract.function('transfer');

    final transactionHash = await web3client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [EthereumAddress.fromHex(to), value],
      ),
      chainId: chainId.toInt(),
    );

    return transactionHash;
  }

  @override
  void initState() {
    super.initState();
    web3client = Web3Client(rcpUrl, Client());
    credentials = EthPrivateKey.fromHex(privateKey);
    address = credentials.address;

    print(address.hexEip55);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        onPageChanged: _onPageViewChanged,
        children: [
          Balance(
            balance: _balance,
            onRefresh: _getBalance,
          ),
          Transfer(
            onSendTransaction: (TransactionData data) async {
              final hash = await _sendTransaction(
                data.to,
                BigInt.from(data.amount * pow(10, 18)),
              );
              print(hash);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Balance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_vert),
            label: 'Transfer',
          ),
        ],
        currentIndex: _selectedPage,
        onTap: _changePage,
      ),
    );
  }
}
