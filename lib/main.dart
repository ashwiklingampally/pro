import 'package:flutter/material.dart';
import 'package:pro/SignUp.dart';

void main() => runApp(new FormValidation());

class FormValidation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Pro task",
      home: SignUp(),
    );
  }
}
