import 'package:app_money/db/category/category_db.dart';
import 'package:app_money/screens/basescreen/decoration.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import '../../models/category_model/category_model.dart';

ValueNotifier<CategoryType> selectedCategory =
    ValueNotifier(CategoryType.income);
Future<void> addPop(BuildContext context) async {
  final nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: textBigB(
            text: 'Add Category',
            weight: FontWeight.w600,
            size: 20,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: nameEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Category',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: const [
                  RadioButton(
                    titel: 'Income',
                    type: CategoryType.income,
                  ),
                  RadioButton(
                    titel: 'Expanse',
                    type: CategoryType.expense,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
              ),
              child: ElevatedButton(
                onPressed: () {
                  final name = nameEditingController.text;
                  final type = selectedCategory.value;
                  final category = CategoryModel(
                      name: name,
                      type: type,
                      image: 'assets/image/category.webp');
                  CategoryDB().insertCategory(category);
                  Navigator.of(context).pop();

                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Conguatulation',
                      message: 'Your Category added',
                      contentType: ContentType.success,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                },
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Add'),
                ),
              ),
            ),
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String titel;
  final CategoryType type;

  const RadioButton({
    super.key,
    required this.titel,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategory,
          builder: (context, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategory.value = value;
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                selectedCategory.notifyListeners();
              },
            );
          },
        ),
        Text(titel)
      ],
    );
  }
}
