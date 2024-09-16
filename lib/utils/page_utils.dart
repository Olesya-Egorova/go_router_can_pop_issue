import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page getPage({
  required Widget child,
  required GoRouterState state,
  String? restorationId,
}) {
  return MaterialPage(
    key: state.pageKey,
    child: child,
    restorationId: restorationId,
  );
}
