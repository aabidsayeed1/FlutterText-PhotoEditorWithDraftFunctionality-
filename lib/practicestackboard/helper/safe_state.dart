import 'dart:async';

import 'package:flutter/material.dart';

/// State security extension
mixin SafeState<T extends StatefulWidget> on State<T> {
  /// cache path
  String? tempRoute;

  /// Safe Refresh
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    await fn();
    if (mounted &&
        !context.debugDoingBuild &&
        context.owner?.debugBuilding == false) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () async {
      if (mounted) await contextReady();
    });
  }

  @override
  void setState(Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  ///context readable callback
  Future<void> contextReady() async {}
}
