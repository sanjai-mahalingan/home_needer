import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_needer/widgets/loader_view.dart';

class InitialView extends ConsumerStatefulWidget {
  const InitialView({super.key});

  @override
  ConsumerState<InitialView> createState() => _InitialView();
}

class _InitialView extends ConsumerState<InitialView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Needer',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Colors.teal.shade800),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'One Stop Solution for Home Needs',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.tealAccent.shade700),
            ),
            const SizedBox(
              height: 20,
            ),
            const LoaderView(size: 42),
          ],
        ),
      ),
    );
  }
}
