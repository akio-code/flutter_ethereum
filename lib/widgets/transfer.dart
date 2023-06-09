import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionData {
  TransactionData(this.to, this.amount);

  final String to;
  final double amount;
}

class Transfer extends StatefulWidget {
  const Transfer({
    super.key,
    required this.onSendTransaction,
  });

  final ValueChanged<TransactionData>? onSendTransaction;

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final _toController = TextEditingController();
  final _amountController = TextEditingController();

  void _sendTransactionData() {
    widget.onSendTransaction?.call(
      TransactionData(
        _toController.text,
        double.parse(_amountController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _sendTransactionData,
              icon: const Icon(Icons.send),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'transfer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _toController,
              maxLength: 42,
              decoration: InputDecoration(
                labelText: 'to',
                suffixIcon: IconButton(
                  onPressed: _toController.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
              ],
              decoration: InputDecoration(
                labelText: 'amount',
                suffixIcon: IconButton(
                  onPressed: _amountController.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
