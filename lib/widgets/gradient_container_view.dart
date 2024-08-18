import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GradientContainerView extends ConsumerStatefulWidget {
  const GradientContainerView(
      {super.key,
      required this.userId,
      required this.title,
      required this.content,
      required this.icon});
  final String userId;
  final String title;
  final String content;
  final Icon icon;

  @override
  ConsumerState<GradientContainerView> createState() =>
      _GradientContainerView();
}

class _GradientContainerView extends ConsumerState<GradientContainerView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 230, 166, 111),
                Color.fromARGB(255, 235, 116, 70),
                Color.fromARGB(255, 202, 89, 44)
              ]),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.icon,
                const Text('No Of business'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.content,
              style: const TextStyle(fontSize: 10),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
