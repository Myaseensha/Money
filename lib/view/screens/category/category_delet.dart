import 'package:app_money/view/home/screen_home.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/provider_category.dart';
import '../basescreen/decoration.dart';

void categorydelete(value, context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(206, 147, 216, 1),
          content: textBig(text: 'Do you want remove', size: 20),
          actions: [
            MaterialButton(
              color: Colors.purple,
              onPressed: () {
                Navigator.of(context).pop(MaterialPageRoute(
                    builder: (BuildContext context) => const ScreenHome()));
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: "It's OK",
                    message: "Don't play with your Category",
                    contentType: ContentType.warning,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              color: Colors.white,
              onPressed: () {
                Provider.of<Providerinstence>(context, listen: false)
                    .deleteCategory(value.id.toString());
                Navigator.of(context).pop(MaterialPageRoute(
                    builder: (BuildContext context) => const ScreenHome()));
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Nop!',
                    message: 'Your Transction Removed!',
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.purple),
              ),
            )
          ],
        );
      });
}
