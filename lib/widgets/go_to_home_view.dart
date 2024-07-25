import 'package:flutter/material.dart';

class GoToHomeView extends StatelessWidget {
  GoToHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, 'indexView');
      },
      icon: const Icon(
        Icons.home,
        color: Colors.white,
      ),
    );
  }
}
