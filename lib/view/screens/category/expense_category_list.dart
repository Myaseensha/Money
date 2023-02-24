import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../../provider/provider_category.dart';

import '../basescreen/decoration.dart';
import 'category_delet.dart';
import 'category_edit.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Providerinstence>(context).refreshUI;
    return Consumer<Providerinstence>(builder: (context, value, child) {
      return ListView.separated(
        itemBuilder: (context, index) {
          final category = value.expenseCategoryList[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Card(
              child: Slidable(
                startActionPane:
                    ActionPane(motion: const StretchMotion(), children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(5),
                    onPressed: (context) {
                      editCategoryAddPopup(context,
                          categoryMode: category, index: index);
                    },
                    backgroundColor: Colors.green,
                    icon: Icons.edit,
                  ),
                ]),
                endActionPane:
                    ActionPane(motion: const StretchMotion(), children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(5),
                    onPressed: (context) {
                      categorydelete(category, context);
                    },
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                  ),
                ]),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(category.image.toString())),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 1.0),
                      child: textBig(
                          text: category.name,
                          size: 20,
                          color: Colors.black,
                          weight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
        itemCount: value.expenseCategoryList.length,
      );
    });
  }
}
