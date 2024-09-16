import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_navigation/presentation/home_page.dart';
import 'package:go_router_navigation/presentation/navigation/navigation_helper.dart';
import 'package:go_router_navigation/presentation/settings_page.dart';
import 'package:go_router_navigation/presentation/transitions_page.dart';
import 'package:go_router_navigation/utils/page_utils.dart';
import 'package:go_router_navigation/presentation/pop_example_page.dart';
part 'bottom_bar_page.g.dart';

@TypedStatefulShellRoute<BottomNavigationRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeTabBranchData>(
      routes: <TypedRoute<RouteData>>[
        typedGoRouteForHomePage,
      ],
    ),
    TypedStatefulShellBranch<TransitionsTabBranchData>(
      routes: <TypedRoute<RouteData>>[
        typedGoRouteForTransitionsPage,
      ],
    ),
    TypedStatefulShellBranch<SettingsTabBranchData>(
      routes: <TypedRoute<RouteData>>[
        typedGoRouteForSettingsPage,
      ],
    ),
  ],
)
class BottomNavigationRouteData extends StatefulShellRouteData {
  const BottomNavigationRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => navigationShell;

  static const String $restorationScopeId = 'bottom_bar_route';
  static String bottomNavigationPageRestorationId = 'bottom_bar_page';

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) =>
      getPage(
        child: BottomNavigationPage(child: navigationShell),
        state: state,
        restorationId: bottomNavigationPageRestorationId,
      );
}

class HomeTabBranchData extends StatefulShellBranchData {
  const HomeTabBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = GlobalKey<NavigatorState>();
  static const String $restorationScopeId = 'home';
}

class TransitionsTabBranchData extends StatefulShellBranchData {
  const TransitionsTabBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = GlobalKey<NavigatorState>();
  static const String $restorationScopeId = 'transitions';
}

class SettingsTabBranchData extends StatefulShellBranchData {
  const SettingsTabBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = GlobalKey<NavigatorState>();
  static const String $restorationScopeId = 'settings';
}

/// This page has the following custom pop logic
/// (behavior on back button and back gesture):
///
/// 1. If the currently active nested page has its own navigation stack
///    with more than one page, the top page on that stack is popped (removed).
///
/// 2. If the home tab is currently active and has no nested pages to pop,
///    the app closes.
///
/// 3. If another tab is active and it's not the most recently visited tab,
///    the app navigates back to the previously visited tab.
///
/// 4. If another tab is active and it's the most recently visited tab,
///    the app navigates to the home tab. This situation typically occurs
///    only after state restoration (e.g., when the app is reopened after being
///    terminated).
class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  State<StatefulWidget> createState() {
    return BottomNavigationPageState();
  }
}

/// The common way of overriding pop behavior is PopScope widget.
/// But PopScope widget doesn't work if the bottom navigation page
/// is the only page in stack, for example,
/// the current path is '/home'  or '/settings'.
/// 'onPopInvoked' method of 'MaterialPage' class don't trigger as well
/// in this case, that's why 'WidgetsBindingObserver' is used.
final class BottomNavigationPageState extends State<BottomNavigationPage>
    with WidgetsBindingObserver {
  static const _firstTabIndex = 0;

  /// The stack of visited tabs indexes
  final List<int> _visitedTabIndexHistory = [];

  @override
  void initState() {
    super.initState();
    if (widget.child.currentIndex != _firstTabIndex) {
      /// If the app was restored, the active tab
      /// may be not the home tab, but we want to return to it
      /// in the end anyway, so we make sure that it's the first one.
      _visitedTabIndexHistory.add(_firstTabIndex);
    }
    _visitedTabIndexHistory.add(widget.child.currentIndex);

    /// Add an observer to register 'didPopRoute' method
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// This method from 'WidgetsBindingObserver' allows
  /// to override popping mechanics.
  /// If it returns true, then the navigator assumes that the pop event
  /// is handled and doesn't perform any other action.
  @override
  Future<bool> didPopRoute() {
    return Future.value(_handlePop());
  }

  void _updateVisitedTabHistory(index) {
    /// If we navigate to the first tab, reset the history of visited tabs.
    if (index == _firstTabIndex) {
      _visitedTabIndexHistory.clear();
    }
    _visitedTabIndexHistory.add(index);
  }

  bool _handlePop() {
    if (_shouldUseDefaultPop()) {
      return false;
    }

    /// Remove the last entry in the visited tab history.
    _visitedTabIndexHistory.removeLast();
    final index = _visitedTabIndexHistory.last;

    /// Go to the previous tab.
    widget.child.goBranch(
      index,
      initialLocation: index == widget.child.currentIndex,
    );
    return true;
  }

  bool _shouldUseDefaultPop() {
    /// Use default pop mechanics in the following cases:
    /// 1. Router has something to pop, meaning that nested stack
    ///    contains more than one route.
    /// 2. Current tab is the home tab. In this case the default behavior
    ///    is closing the app.
    return NavigationHelper.router.canPop() ||
        _visitedTabIndexHistory.last == _firstTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Navigator Page'),
      ),
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.child.currentIndex,
        onTap: (index) {
          setState(() {
            _updateVisitedTabHistory(index);
          });
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.move_up),
            label: 'transitions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
      ),
    );
  }
}
