import 'package:flutter/material.dart';

/// An abstract utility class designed to facilitate UI synchronization.
/// It acts as a lightweight global bus to trigger data refreshes across
/// different screens or components without complex state management.
abstract class MaterialRefreshTrigger {
  /// A global notifier that tracks refresh requests.
  /// Any widget listening to this [ValueNotifier] will rebuild when the value changes.
  static final ValueNotifier<bool> shouldRefresh = ValueNotifier(false);

  /// Triggers a refresh event by toggling the boolean value.
  /// This change notifies all active listeners to re-execute their fetch logic.
  static void requestRefresh() {
    //* Toggling the value ensures the notifier fires even if the UI state is identical.
    shouldRefresh.value = !shouldRefresh.value;
  }
}
