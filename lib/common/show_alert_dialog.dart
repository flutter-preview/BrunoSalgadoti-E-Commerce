import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
   const ShowAlertDialog({Key? key,
     required this.titleText,
     required this.bodyText,
     required this.actions,
     this.content,
     this.titleColor = Colors.red,
     this.titleSize = 22,
     this.titleWeight = FontWeight.w600,
     this.bodyColor = Colors.black,
     this.bodySize = 14,
     this.bodyWeight = FontWeight.w600,
  }) : super(key: key);

  final String? titleText;
  final String bodyText;
  final List<Widget> actions;
  final Widget? content;
  final Color? titleColor;
  final double? titleSize;
  final FontWeight? titleWeight;
  final Color? bodyColor;
  final double? bodySize;
   final FontWeight? bodyWeight;

  @override
  Widget build(BuildContext context) {
     return AlertDialog(
            title:  Text(
              titleText!,
              style: TextStyle(
                color: titleColor,
                fontWeight: titleWeight,
                fontSize: titleSize,
              ),
              textAlign: TextAlign.center,
            ),
             content: content ?? SingleChildScrollView(
              child: ListBody(
                children:  <Widget>[
                  Text(
                    bodyText,
                    style: TextStyle(
                      color: bodyColor,
                      fontWeight: bodyWeight,
                      fontSize: bodySize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: actions,
          );
        }
  }

