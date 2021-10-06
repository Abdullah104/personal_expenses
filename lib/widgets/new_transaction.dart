import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final void Function(String, double, DateTime) _addNewTransaction;

  NewTransaction({
    Key? key,
    required void Function(String, double, DateTime) newTransactionAdder,
  })  : this._addNewTransaction = newTransactionAdder,
        super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _choosenDate;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: mediaQuery.viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Platform.isAndroid
                  ? TextField(
                      controller: this._titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    )
                  : CupertinoTextField(
                      controller: this._titleController,
                      placeholder: 'Title',
                    ),
              if (Platform.isIOS)
                SizedBox(
                  height: 8,
                ),
              Platform.isAndroid
                  ? TextField(
                      controller: this._amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      onEditingComplete: () =>
                          this._submitData(this._choosenDate!),
                    )
                  : CupertinoTextField(
                      controller: this._amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      placeholder: 'Amount',
                      onEditingComplete: () =>
                          this._submitData(this._choosenDate!),
                    ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(this._choosenDate == null
                          ? 'No date chosen'
                          : DateFormat('EEEE - dd/MM/y')
                              .format(this._choosenDate!)),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.calendar_today),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Choose Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: this._presentDatePicker,
                          )
                        : TextButton.icon(
                            onPressed: this._presentDatePicker,
                            icon: Icon(Icons.calendar_today),
                            label: Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Platform.isAndroid
                  ? ElevatedButton(
                      onPressed: () => this._submitData(this._choosenDate!),
                      child: Text(
                        'Add Transaction',
                      ),
                    )
                  : CupertinoButton(
                      child: Text(
                        'Add Transaction',
                      ),
                      onPressed: () => this._submitData(this._choosenDate!),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitData(DateTime dateTime) {
    final title = this._titleController.text;
    final amount = double.tryParse(this._amountController.text);

    if (title.isNotEmpty && amount != null && this._choosenDate != null) {
      this.widget._addNewTransaction(title, amount, this._choosenDate!);
      Navigator.pop(context);
    }
  }

  void _presentDatePicker() {
    final initialDate = DateTime.now();
    final firstDate = DateTime.now().subtract(Duration(days: 30));
    final lastDate = DateTime.now(); 

    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then((choosenDate) {
      setState(() {
        this._choosenDate = choosenDate;
      });
    });
  }
}
