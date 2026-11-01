// core/extensions/context_extensions.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_system/core/routes/route_names.dart';

extension SafePop on BuildContext {
  /// Pops if possible, otherwise goes to Home.
  void safePop() {
    if (canPop()) {
      pop();
    } else {
      goNamed(RouteNames.homeName);
    }
  }

  /// Pops if possible, otherwise goes to a specific route.
  void safePopTo(String fallbackRouteName) {
    if (canPop()) {
      pop();
    } else {
      goNamed(fallbackRouteName);
    }
  }
}
