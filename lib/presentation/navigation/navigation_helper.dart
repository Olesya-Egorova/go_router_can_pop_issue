import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_navigation/presentation/bottom_bar_page.dart';
import 'package:go_router_navigation/presentation/home_page.dart';

class NavigationHelper {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  static String goRouterRestorationScopeId = 'go_router';

  static GoRouter router = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: typedGoRouteForHomePage.path,
    routes: [
      $bottomNavigationRouteData
    ],
    debugLogDiagnostics: true,
    restorationScopeId: goRouterRestorationScopeId,
  );
}
