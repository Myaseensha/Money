import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/provider_category.dart';
import '../../../models/category_model/category_model.dart';

Future<void> editCategoryAddPopup(
  BuildContext context,
  // ignore: non_constant_identifier_names
  {
  required CategoryModel categoryMode,
  required int index,
}) async {
  final nameController = TextEditingController(text: categoryMode.name);
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Edit your category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category item is Empty';
                  } else {
                    return null;
                  }
                },
                controller: nameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 242, 214, 246),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.purple,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2),
                  ),
                  hintText: 'Category Item',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: () {
                final name = nameController.text.trim();
                if (formKey.currentState!.validate()) {
                  final category = CategoryModel(
                    image: 'assets/image/category.webp',
                    name: name,
                    type: categoryMode.type,
                  );
                  Provider.of<Providerinstence>(context, listen: false)
                      .updateCategory(index, category);
                  Provider.of<Providerinstence>(
                    context,
                  ).refreshUI();
                  Navigator.of(ctx).pop();
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
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      );
    },
  );
}
