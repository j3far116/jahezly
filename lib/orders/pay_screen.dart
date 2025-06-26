import 'package:flutter/material.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('نموذج الدفع')],
        ),
      ),
    );
  }
}
