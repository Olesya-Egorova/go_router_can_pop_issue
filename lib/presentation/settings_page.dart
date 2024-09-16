import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_navigation/utils/page_utils.dart';

const typedGoRouteForSettingsPage = TypedGoRoute<SettingsRoute>(
  path: '/settings',
);

@immutable
class SettingsRoute extends GoRouteData {

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
    getPage(child: const SettingsPage(), state: state);
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Settings page"),
    );
  }
}
