import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import './chart_bar.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues =>
      List.generate(7, (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        var totalSum = 0.0;

        for (var transaction in recentTransactions)
          if (transaction.date.day == weekDay.day &&
              transaction.date.month == weekDay.month &&
              transaction.date.year == weekDay.year)
            totalSum += transaction.amount;

        print("${DateFormat.E().format(weekDay)}'s transactions are $totalSum");

        return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
      });

  double get totalSpendings => groupedTransactionValues.fold(
      0.0, (sum, daySpendings) => sum + daySpendings['amount']);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues
              .map((daySpendings) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      label: daySpendings['day'],
                      spendingAmount: daySpendings['amount'],
                      spendingPercentageOfTotal: totalSpendings != 0
                          ? (daySpendings['amount'] as double) / totalSpendings
                          : 0,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
