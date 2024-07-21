import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_needer/ui/initial_view.dart';
import 'package:home_needer/widgets/side_nav_view.dart';

class IndexView extends ConsumerStatefulWidget {
  const IndexView({super.key});

  @override
  ConsumerState<IndexView> createState() => _IndexView();
}

class _IndexView extends ConsumerState<IndexView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userSession);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Needer'),
      ),
      drawer: Drawer(
        child: SideNav(user: user),
      ),
      body: const Center(
        child: Text('Index View'),
      ),
    );
  }
}
