/// A robust cache system for GoRouter `extra` payloads.
/// 
/// WHY THIS IS NEEDED: GoRouter is fundamentally designed for Web URLs. When
/// navigating "Back" (or rebuilding the stack), GoRouter recreates previous 
/// routes. Because we explicitly banned `pathParameters` in favor of flat routes,
/// GoRouter relies entirely on `extra` which is volatile and lost on rebuilds 
/// or web back-button presses. This cache acts as our own bulletproof preserver.
class RouterPayloadCache {
  static final Map<String, dynamic> _cache = {};

  static T? get<T>(String routeName, Object? incomingExtra) {
    if (incomingExtra != null && incomingExtra is T) {
      _cache[routeName] = incomingExtra;
      return incomingExtra as T;
    }
    return _cache[routeName] as T?;
  }
}
