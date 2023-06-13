import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/db/transactions/transaction_model.dart';
import 'package:money_manager/models/category/category_model.dart';

class ScreenaddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenaddTransaction({super.key});

  @override
  State<ScreenaddTransaction> createState() => _ScreenaddTransactionState();
}

class _ScreenaddTransactionState extends State<ScreenaddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  //itreyum data venam//

  //Purpose
  //Amount
  //Date
  //Income/Expence
  //CategoryType

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Purpose
          TextFormField(
            controller: _purposeTextEditingController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Purpose',
            ),
          ),

          //Amount
          TextFormField(
            controller: _amountEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Amount',
            ),
          ),

          //Calender

          TextButton.icon(
            onPressed: () async {
              final _selectedDateTemp = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 30)),
                lastDate: DateTime.now(),
              );

              if (_selectedDateTemp == null) {
                return;
              } else {
                print(_selectedDate.toString());
                setState(() {
                  _selectedDate = _selectedDateTemp;
                });
              }
            },
            icon: Icon(Icons.calendar_today),
            label: Text(_selectedDate == null
                ? 'Select Date'
                : _selectedDate.toString()),
          ),

          //Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio(
                    value: CategoryType.income,
                    groupValue: _selectedCategorytype,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategorytype = CategoryType.income;
                        _categoryID = null;
                      });
                    },
                  ),
                  Text('Income'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: CategoryType.expense,
                    groupValue: _selectedCategorytype,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategorytype = CategoryType.expense;
                        _categoryID = null;
                      });
                    },
                  ),
                  Text('Expence'),
                ],
              ),
            ],
          ),

          //Category Type

          DropdownButton(
            hint: const Text('Select Category'),
            value: _categoryID,
            items: (_selectedCategorytype == CategoryType.income
                    ? CategoryDB().incomeCategoryListListener
                    : CategoryDB().expenseCategoryListListener)
                .value
                .map((e) {
              return DropdownMenuItem(
                 value: e.id,
                child: Text(e.name),
                onTap: () {
                  print(e.toString());
                  _selectedCategoryModel = e;
                },
               
              );
            }).toList(),
            onChanged: (selectedValue) {
              print(selectedValue);
              setState(() {
                _categoryID = (selectedValue);
              });
            },
          ),

          //Submit Button

          ElevatedButton(
            onPressed: () {
              addTransaction();
            },
            child: Text('Submit'),
          )
        ],
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController;
    final _amountText = _amountEditingController;
    if (_purposeText == "") {
      return;
    }
    if (_amountText == "") {
      return;
    }

    if (_categoryID == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }

    if (_selectedCategoryModel == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amountText.text);
    if (_parsedAmount == null) {
      return;
    }
    // _selectedDate
    // _selectedCategorytype
    // _categoryID

    final _model = TransactionModel(
      purpose: _purposeText.text,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _selectedCategoryModel!,
    );


   await TransactionDB.instance.addTransaction(_model);
   Navigator.of(context).pop();
   TransactionDB.instance.refresh();
  }
}
