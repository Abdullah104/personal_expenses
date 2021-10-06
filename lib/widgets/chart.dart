import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const Chart({
    Key? key,
    required List<Transaction> recentTransactions,
  })  : this._recentTransactions = recentTransactions,
        super(key: key);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(
          days: index,
        ),
      );

      final dayLabel = DateFormat.E().format(weekDay);
      var totalSum = 0.0;

      this._recentTransactions.forEach((transaction) {
        final sameDay = transaction.date.day == weekDay.day;
        final sameMonth = transaction.date.month == weekDay.month;
        final sameYear = transaction.date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) totalSum += transaction.amount;
      });

      return {
        'day': dayLabel,
        'amount': totalSum,
      };
    });
  }

  double get totalAmount => this.groupedTransactionValues.fold(0.0,
      (total, dayTransactions) => total += dayTransactions['amount'] as double);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: this.groupedTransactionValues.map((dayTransactions) {
            final day = dayTransactions['day'] as String;
            final spendingAmount = dayTransactions['amount'] as double;
            final spendingPercentageToTotal =
                spendingAmount / this.totalAmount;
    
            return Flexible(
              child: ChartBar(
                label: day,
                spendingAmount: spendingAmount,
                spendingPercentageToTotal:
                    this.totalAmount == 0 ? 0 : spendingPercentageToTotal,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
