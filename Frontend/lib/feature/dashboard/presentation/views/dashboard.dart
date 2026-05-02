import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/dashboard_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.child, required this.state});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: DashboardUtils.scaffoldKey,
      body: child,
    );
  }
}
