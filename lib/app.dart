import 'package:flutter/material.dart';
import 'package:go_router_navigation/presentation/navigation/navigation_helper.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: NavigationHelper.router,
      restorationScopeId: 'app',
    );
  }
}
