import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';
import 'notification_providers.dart';

/// Listens for notification taps and opens the matching pantry item.
class NotificationTapListener extends ConsumerStatefulWidget {
  const NotificationTapListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<NotificationTapListener> createState() =>
      _NotificationTapListenerState();
}

class _NotificationTapListenerState
    extends ConsumerState<NotificationTapListener> {
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    final service = ref.read(notificationServiceProvider);
    _subscription = service.taps.listen(_openItem);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await service.initialize();
      final payload = service.initialPayload;
      if (!mounted || payload == null) return;
      service.clearInitialPayload();
      _openItem(payload);
    });
  }

  void _openItem(String itemId) {
    if (!mounted || itemId.isEmpty) return;
    ref.read(routerProvider).push(Routes.item(itemId));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
