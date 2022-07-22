import 'package:flutter/material.dart';

class DialogManager {
  // Display a standard dialog
  void displayDialog(
      {required BuildContext context, required String title, required Widget content, required List<Widget> actions}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: content,
            actions: actions,
          );
        });
  }

  // Display a dialog for confirming a user action
  void displayConfirmationDialog(
      {required BuildContext context,
      String title = "Please confirm",
      String description = "Confirm the next step please.",
      required Function onConfirmation,
      required Function onCancellation}) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                  onPressed: () {
                    onCancellation();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirmation();
                  },
                  child: Text("Yes", style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white)))
            ],
          );
        });
  }

  // Display a dialog for informing the user
  void displayInformationDialog(
      {required BuildContext context,
      String title = "Please confirm",
      String description = "Confirm the next step please.",
      Function? onConfirmation}) {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirmation != null) {
                      onConfirmation();
                    }
                  },
                  child: Text("OK", style: Theme.of(context).textTheme.headline2!.copyWith(color: Colors.white)))
            ],
          );
        });
  }

  // Display a ModalBottomSheet
  void displayModalBottomSheet({required BuildContext context, required String title, required List<Widget> options}) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
        builder: (context) {
          return SizedBox(
            height: options.length * 75.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                ...options
              ],
            ),
          );
        });
  }

  // Display a SnackBar with a message
  void displaySnackBar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Display a loading dialog
  void displayLoadingDialog({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: const SimpleDialog(
                children: [
                  Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                ],
              ));
        });
  }

  // Close a dialog
  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
