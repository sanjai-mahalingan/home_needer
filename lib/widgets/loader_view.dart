import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderView extends StatelessWidget {
  const LoaderView({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: LoadingAnimationWidget.dotsTriangle(
            color: Colors.amberAccent.shade700, size: size));
  }
}
