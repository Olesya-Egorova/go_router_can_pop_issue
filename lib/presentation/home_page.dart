import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_navigation/presentation/bottom_bar_page.dart';
import 'package:go_router_navigation/presentation/pop_example_page.dart';
import 'package:go_router_navigation/utils/page_utils.dart';

const typedGoRouteForHomePage = TypedGoRoute<HomeRoute>(
  path: '/home',
  routes: [
    typedGoRouteForPopExamplePage
  ],
);

@immutable
class HomeRoute extends GoRouteData {

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
    getPage(child: const HomePage(), state: state);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Home page"),
          ElevatedButton(
            onPressed: () => _onPopExampleBtnClick(context),
            child: const Text("Open back example"),
          ),
        ],
      ),
    );
  }

  void _onPopExampleBtnClick(BuildContext context) {
    PopExamplePageRoute().go(context);
  }
}
