import 'dart:developer';

import 'package:flutter/material.dart';
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
  final String privateKey =
      '37d53450862207452d5d2cddd688f355d9286b3fa3f911f70cb139b9931bde99';
  final String rcpUrl =
      'https://sepolia.infura.io/v3/9a810c8790eb4d93823ebbf0bf807ae7';

  // Ganache
  // final String privateKey =
  //     '0x8266c590168bd1db02ed0b695ff49b82a831616e0cf0dc14d9e18736d2742e1b';
  // final String rcpUrl = 'HTTP://127.0.0.1:7545';

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

  Future<void> _init() async {
    httpClient = Client();
    web3client = Web3Client(rcpUrl, httpClient);
    credentials = EthPrivateKey.fromHex(privateKey);
    address = credentials.address;

    log(address.hexEip55);
  }

  Future<void> _getBalance() async {
    final weiBalance = await web3client.getBalance(address);
    final ethBalance = weiBalance.getValueInUnit(EtherUnit.ether);
    _balance = ethBalance;
    setState(() {});
  }

  Future<void> _sendTransaction(String to, double amount) async {
    final chainId = await web3client.getChainId();

    final transactionHash = await web3client.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(to),
        value: EtherAmount.fromInt(
          EtherUnit.finney,
          (amount * 1000).toInt(),
        ),
      ),
      chainId: chainId.toInt(),
    );
    log('hash: $transactionHash');
  }

  @override
  void initState() {
    super.initState();
    _init();
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
            onSendTransaction: (TransactionData data) {
              _sendTransaction(data.to, data.amount);
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
