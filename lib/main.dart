import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transactions_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      primarySwatch: Colors.green,
      fontFamily: 'QuickSand',
      textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.amber,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 'id',
      title: 'ajdksl;fj',
      amount: 100,
      date: DateTime.now().subtract(Duration(days: 0)),
    ),
    Transaction(
      id: 'id1',
      title: 'ajdksl;fj',
      amount: 100,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 'id2',
      title: 'ajdksl;fj',
      amount: 100,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 'id3',
      title: 'ajdksl;fj',
      amount: 100,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 'id4',
      title: 'ajdksl;fj',
      amount: 100,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: 'id5',
      title: 'ajdksl;fj',
      amount: 100,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Transaction(
      id: 'id6',
      title: 'ajdksl;fj',
      amount: 100,
      date: DateTime.now().subtract(Duration(days: 6)),
    ),
  ];

  var _showChart = false;

  List<Transaction> get _recentTransactions {
    return this._userTransactions.where((transaction) {
      final currentDate = DateTime.now();

      return transaction.date.isAfter(
        currentDate.subtract(
          Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final title = Text('Personal Expenses');

    final newTransactionStarter =
        () => this.showTransactionAdditionForm(context);

    final addTransactionButton = Platform.isAndroid
        ? IconButton(
            onPressed: newTransactionStarter,
            icon: Icon(Icons.add),
          )
        : CupertinoButton(
            child: Icon(CupertinoIcons.add),
            onPressed: newTransactionStarter,
          );

    final androidAppBar = AppBar(
      title: title,
      actions: [
        addTransactionButton,
      ],
    );

    final iosAppBar = CupertinoNavigationBar(
      middle: title,
      trailing: addTransactionButton,
    );

    final appBarHeight = Platform.isAndroid
        ? androidAppBar.preferredSize.height
        : iosAppBar.preferredSize.height;

    var transactionsListHeight =
        (mediaQuery.size.height * 0.6) - mediaQuery.padding.top;

    if (Platform.isAndroid) transactionsListHeight -= appBarHeight;

    final transactionsList = SizedBox(
      height: transactionsListHeight,
      child: TransactionsList(
        userTransactions: this._userTransactions,
        deleteTransaction: this._deleteTransaction,
      ),
    );

    final chart = SizedBox(
      height: (mediaQuery.size.height - appBarHeight - mediaQuery.padding.top) *
          0.3,
      child: Chart(
        recentTransactions: this._recentTransactions,
      ),
    );

    final scaffoldBody = SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show Chart',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Switch.adaptive(
                  value: this._showChart,
                  onChanged: (showChart) {
                    setState(() {
                      this._showChart = showChart;
                    });
                  },
                ),
              ],
            ),
          if (!isLandscape) chart,
          if (!isLandscape) transactionsList,
          if (isLandscape) this._showChart ? chart : transactionsList,
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: iosAppBar,
            child: SafeArea(
              child: scaffoldBody,
            ),
          )
        : Scaffold(
            appBar: androidAppBar,
            body: scaffoldBody,
            floatingActionButton: Platform.isAndroid
                ? FloatingActionButton(
                    onPressed: () => this.showTransactionAdditionForm(context),
                    child: Icon(Icons.add))
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  void showTransactionAdditionForm(BuildContext context) {
    if (Platform.isAndroid) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => NewTransaction(
          newTransactionAdder: this._addNewTransaction,
        ),
      );
    } else if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => NewTransaction(
          newTransactionAdder: this._addNewTransaction,
        ),
      );
    }
  }

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: dateTime,
    );

    setState(() {
      this._userTransactions.insert(0, transaction);
    });
  }

  void _deleteTransaction(String id) {
    this.setState(() {
      this._userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }
}
