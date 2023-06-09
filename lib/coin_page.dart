import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import 'widgets/balance.dart';

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
        children: [
          Balance(
            balance: _balance,
            onRefresh: _getBalance,
          ),
          Text('transfer'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Balance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Balance',
          ),
        ],
        currentIndex: _selectedPage,
        onTap: _changePage,
      ),
    );
  }
}
