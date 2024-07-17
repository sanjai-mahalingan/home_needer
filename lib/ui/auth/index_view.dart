import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexView extends ConsumerStatefulWidget {
  const IndexView({super.key});

  @override
  ConsumerState<IndexView> createState() => _IndexView();
}

class _IndexView extends ConsumerState<IndexView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Index View'),
      ),
    );
  }
}
