import 'package:flutter/material.dart';

class HeadLogin extends StatelessWidget {
  const HeadLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 48),
        Text(
          "Demarco",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
