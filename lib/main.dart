import 'package:flutter/material.dart';

import 'SignUp.dart';

void main() => runApp(new FormValidation());

class FormValidation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pro task",
      home: SignUp(),
    );
  }
}
