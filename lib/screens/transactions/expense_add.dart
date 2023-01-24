import 'package:app_money/db/category/category_db.dart';

import 'package:app_money/db/transation/transation_db.dart';
import 'package:app_money/models/transaction_model/transaction_model.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/category_model/category_model.dart';
import '../basescreen/decoration.dart';

class ExpenssScreen extends StatefulWidget {
  const ExpenssScreen({super.key});

  @override
  State<ExpenssScreen> createState() => _ExpenssScreen();
}

class _ExpenssScreen extends State<ExpenssScreen> {
  DateTime selectedDate = DateTime.now();
  final CategoryType _selectedCategoryType = CategoryType.expense;
  CategoryModel? _selectedcCategoryModel;
  String? categoeyid;
  final discriptionediting = TextEditingController();
  final amountcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.expenseCategoryList;
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                //------------------------------------------Top colunm and bar text------------------------------------------------------------------------------------------------------------------------------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Container(
                        alignment: Alignment.center,
                        child: textBig(
                          text: 'Expense',
                          size: 20,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //---------------------------------------------------text and calender---------------------------------------------------------------------------------------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: textBig(
                              text: 'How much?',
                              weight: FontWeight.w500,
                              size: 20),
                        ),

                        //---------------------------------------------------------------calender---------------------------------------------------------------------------------------------------------

                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: TextButton.icon(
                            onPressed: () async {
                              final selectedDatetemp = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.utc(2020, 12, 12),
                                lastDate: DateTime.utc(2026, 12, 12),
                              );
                              if (selectedDatetemp == null) {
                                return;
                              } else {
                                setState(() {
                                  selectedDate = selectedDatetemp;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              DateFormat.MMMd().format(selectedDate),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    //--------------------------------------------------------------------------------------------amount----------------------------------------------------------------------------------------------
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: amountcontroller,
                          style: const TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              focusColor: Colors.white,
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.currency_rupee_rounded,
                                color: Colors.white,
                                size: 60,
                              )),
                        )),
                  ],
                ),
                // --------------------------------------------------------------------------------------------------new stack and discription from-------------------------------------------------------------------------------------------------------------------------
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25))),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(23),
                          child: TextFormField(
                              controller: discriptionediting,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                labelText: 'Description',
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton(
                                value: categoeyid,
                                hint: textBigB(
                                    text: 'Select Category',
                                    size: 15,
                                    weight: FontWeight.bold),
                                items: CategoryDB
                                    .instance.expenseCategoryList.value
                                    .map((e) {
                                  return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: e.id,
                                      onTap: () {
                                        _selectedcCategoryModel = e;
                                      },
                                      child: ListTile(
                                        title: Text(
                                          e.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        leading: Card(
                                          color: null,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.asset(
                                                  e.image.toString())),
                                        ),
                                      ));
                                }).toList(),
                                onChanged: (selectedvalue) {
                                  setState(() {
                                    categoeyid = selectedvalue;
                                  });
                                },
                                isExpanded:
                                    true, //make true to take width of parent widget
                                underline: Container(), //empty line
                                dropdownColor: Colors.white,
                                iconEnabledColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        //-------------------------------------------------------------------------------------------------------------------button-------------------------------------------------------------------------------------------------------------------------------------------
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: botton(
                              color: Colors.red,
                              onPressed: () {
                                addTransaction();

                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Conguatulation',
                                    message: 'Your Expense Transction added',
                                    contentType: ContentType.success,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              },
                              titel: 'Continue'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final discription = discriptionediting.text;
    final parsedAmount = int.tryParse(amountcontroller.value.text);
    if (parsedAmount == null) {
      return;
    }

    final model = TransactionModel(
      amount: parsedAmount,
      category: _selectedcCategoryModel!,
      description: discription,
      type: _selectedCategoryType,
      calender: selectedDate,
    );

    TransactionDb.instance.addTransaction(model);

    transactionlist.value;
    Navigator.of(context).pop();
    TransactionDb.instance.refreshUI();
    CategoryDB.instance.refreshUI();
  }
}
