import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionsList extends StatefulWidget {
  final List<Transaction> _userTransactions;
  final void Function(String) _deleteTransaction;

  const TransactionsList({
    Key? key,
    required List<Transaction> userTransactions,
    required void Function(String) deleteTransaction,
  })  : this._userTransactions = userTransactions,
        this._deleteTransaction = deleteTransaction,
        super(key: key);

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  Widget build(BuildContext context) {
    return this.widget._userTransactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView(
            children: this
                .widget
                ._userTransactions
                .map((transaction) => TransactionItem(
                      key: ValueKey(transaction.id),
                      transaction: transaction,
                      deleteTransaction: this.widget._deleteTransaction,
                    ))
                .toList(),
          );
  }
}
