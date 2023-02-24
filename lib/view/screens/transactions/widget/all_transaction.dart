import 'package:app_money/models/category_model/category_model.dart';
import 'package:app_money/models/transaction_model/transaction_model.dart';
import 'package:app_money/provider/provider_transaction.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../basescreen/decoration.dart';

import '../transction_delet.dart';
import '../update_transaction.dart';

double currentBalance = 0;
double totalIncome = 0;
double totalExpense = 0;

// ignore: must_be_immutable
class RecentTransaction extends StatefulWidget {
  RecentTransaction({super.key, required this.result});
  List<TransactionModel> result = [];
  @override
  State<RecentTransaction> createState() => _RecentTransactionState();
}

class _RecentTransactionState extends State<RecentTransaction> {
  @override
  Widget build(BuildContext context) {
    getBalance();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ProviderTransaction>(context, listen: false)
          .refreshUI();
    });
    return Consumer<ProviderTransaction>(
      builder: (context, value, child) {
        return value.transactionlist.isEmpty
            ? Center(
                child: Lottie.asset('assets/image/nodata.json'),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: widget.result.length,
                itemBuilder: (BuildContext context, int index) {
                  final value = widget.result[index];
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Slidable(
                        startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: BorderRadius.circular(15),
                                onPressed: (context) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Update(model: value, index: index),
                                  ));
                                },
                                backgroundColor: Colors.green,
                                icon: Icons.edit,
                              ),
                            ]),
                        endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: BorderRadius.circular(15),
                                onPressed: (context) {
                                  transactiondelet(
                                      widget.result[index].id, context);
                                },
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                              ),
                            ]),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child:
                                  Image.asset(value.category.image.toString()),
                            ),
                            title: textBig(
                                text: value.category.name,
                                size: 18,
                                color: Colors.black,
                                weight: FontWeight.w600),
                            trailing: Text(
                              'RS ${value.amount}',
                              style: TextStyle(
                                color: value.type == CategoryType.income
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: textBigG(
                                text: value.description,
                                align: TextAlign.start,
                                size: 13),
                          ),
                        ),
                      ));
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 0,
                  );
                },
              );
      },
    );
  }

  void getBalance() async {
    currentBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    for (var element
        in Provider.of<ProviderTransaction>(context).transactionlist) {
      if (element.type == CategoryType.income) {
        setState(() {
          currentBalance = currentBalance + element.amount;
          totalIncome = totalIncome + element.amount;
        });
      } else {
        setState(() {
          currentBalance = currentBalance - element.amount;
          totalExpense = totalExpense + element.amount;
        });
      }
    }
  }
}
