import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function adder;

  NewTransaction(this.adder);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => submitData(),
            ),
            FlatButton(
              onPressed: submitData,
              child: Text('Add Transaction'),
              textColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  void submitData() {
    final title = titleController.text;
    final amount = amountController.text.isNotEmpty
        ? double.parse(amountController.text)
        : -1;

    if (title.isNotEmpty && amount >= 0) {
      widget.adder(title, amount);
      Navigator.of(context).pop();
    }
  }
}
