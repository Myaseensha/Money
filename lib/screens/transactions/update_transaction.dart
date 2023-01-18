import 'package:app_money/db/category/category_db.dart';
import 'package:app_money/db/transation/transation_db.dart';
import 'package:app_money/models/category_model/category_model.dart';
import 'package:app_money/models/transaction_model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

// ignore: must_be_immutable
class Update extends StatefulWidget {
  Update({Key? key, required this.model, required this.index})
      : super(key: key);

  TransactionModel model;
  int index;

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late TextEditingController amuont;
  late TextEditingController discripstion;
  late DateTime selectedDate;
  late CategoryModel categorymodel;
  late CategoryType categorytype;
  String? categoryID;
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    amuont = TextEditingController(text: widget.model.amount.toString());
    discripstion = TextEditingController(text: widget.model.description);
    selectedDate = widget.model.calender;
    categorymodel = widget.model.category;
    categorytype = widget.model.type;
    CategoryDB.instance.expenseCategoryList.value;
    CategoryDB.instance.incomeCategoryList.value;
    CategoryDB.instance.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        '   Update Transaction',
        textAlign: TextAlign.center,
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextButton.icon(
                    style: ButtonStyle(
                      alignment: Alignment.centerRight,
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      fixedSize: MaterialStateProperty.all(const Size(340, 50)),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final selectedDateTemp = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDateTemp == null) {
                        return;
                      } else {
                        setState(() {
                          selectedDate = selectedDateTemp;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.purple,
                    ),
                    label: Text(
                      // ignore: unnecessary_null_comparison
                      selectedDate == null
                          ? 'Select Date'
                          : parseDate(selectedDate),
                      style: TextStyle(color: Colors.purple.shade600),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.category_rounded, color: Colors.purple),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(10),
                      hint: const Text('Select Category'),
                      value: categoryID,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category Items is Empty';
                        } else {
                          return null;
                        }
                      },
                      items: (categorytype == CategoryType.income
                              ? CategoryDB.instance.incomeCategoryList
                              : CategoryDB.instance.expenseCategoryList)
                          .value
                          .map((e) {
                        return DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                          onTap: () {
                            categorymodel = e;
                          },
                        );
                      }).toList(),
                      onChanged: (selectValue) {
                        setState(() {
                          categoryID = selectValue;
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: amuont,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Amount',
                      suffixIcon: IconButton(
                        onPressed: () {
                          amuont.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      prefixIcon: const Icon(
                        Icons.currency_rupee,
                        color: Color.fromARGB(255, 144, 15, 204),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Category is Empty';
                      } else {
                        return null;
                      }
                    },
                    controller: discripstion,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.notes, color: Colors.purple),
                      hintText: 'Description',
                      suffixIcon: IconButton(
                        onPressed: () {
                          discripstion.clear();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      update();
                    },
                    icon: const Icon(Icons.archive_rounded),
                    label: const Text('Update'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> update() async {
    final amounts = int.tryParse(amuont.text);
    if (amounts == null) {
      return;
    }
    final discriptioan = discripstion.text;
    final date = selectedDate;
    final model = categorymodel;
    final type = categorytype;
    final trans = TransactionModel(
        category: model,
        type: type,
        amount: amounts,
        description: discriptioan,
        calender: date);

    log(trans.toString());
    TransactionDb.instance.updateTransaction(widget.index, trans);
    Navigator.of(context).pop();
    CategoryDB.instance.refreshUI();
    TransactionDb.instance.refreshUI();
  }

  String parseDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
