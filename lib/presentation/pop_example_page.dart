import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_navigation/presentation/bottom_bar_page.dart';
import 'package:go_router_navigation/presentation/navigation/navigation_helper.dart';
import 'package:go_router_navigation/utils/page_utils.dart';

const typedGoRouteForPopExamplePage =
  TypedGoRoute<PopExamplePageRoute>(path: 'popExample');

@immutable
class PopExamplePageRoute extends GoRouteData {

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
    getPage(
      child: const PopExamplePage(),
      state: state,
    );
}

class PopExamplePage extends StatefulWidget {
  const PopExamplePage({super.key});

  void _onBtnClick(BuildContext context) {
    PopExamplePageRoute().push(context);
  }

  void _onBackBtnClick(BuildContext context) {
    var router = NavigationHelper.router;
    // there is a bug: infinite loop
    while (router.canPop()) {
      router.pop();
    }
  }

  @override
  State<StatefulWidget> createState() {
    return PopExamplePageState();
  }
}

final class PopExamplePageState extends State<PopExamplePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Center(
        child: Column(
          children: [
            const Text('Pop example'),
            ElevatedButton(
              onPressed: () {
                widget._onBtnClick(context);
              },
              child: const Text("Next screen"),
            ),
            ElevatedButton(
              onPressed: () {
                widget._onBackBtnClick(context);
              },
              child: const Text("Back to root"),
            ),
          ],
        ),
      ),
    );
  }
}
