import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late final backgroundColor;

  @override
  void initState() {
    super.initState();

    const availableColors = [
      Colors.green,
      Colors.purple,
      Colors.blue,
    ];

    backgroundColor = availableColors[Random().nextInt(availableColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final amount = widget.transaction.amount;
    final formattedAmount = amount.toStringAsFixed(2);
    final title = widget.transaction.title;
    final date = widget.transaction.date;
    final format = 'EEEE - dd/M/y - kk:mm';
    final formattedDate = DateFormat(format).format(date);
    final id = widget.transaction.id;
    final mediaQuery = MediaQuery.of(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text(
                '$formattedAmount SAR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          '$title',
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          '$formattedDate',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: mediaQuery.size.width > 400
            ? TextButton.icon(
                onPressed: () => this.widget.deleteTransaction(id),
                icon: Icon(Icons.delete),
                label: Text('DELETE'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).errorColor,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).errorColor.withOpacity(0.1),
                  ),
                ),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => this.widget.deleteTransaction(id),
              ),
      ),
    );
  }
}
