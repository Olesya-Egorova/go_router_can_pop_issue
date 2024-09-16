import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_navigation/utils/page_utils.dart';

const typedGoRouteForTransitionsPage = TypedGoRoute<TransitionsRoute>(
  path: '/transitions',
);

@immutable
class TransitionsRoute extends GoRouteData {

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
    getPage(child: const TransitionsPage(), state: state);
}

class TransitionsPage extends StatelessWidget {
  const TransitionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text("Transitions example page"),
        ],
      ),
    );
  }
}
