import 'package:flutter_bloc/flutter_bloc.dart';

// Prevents emitting state after cubit is closed
mixin SafeEmitMixin<S> on BlocBase<S> {
  @override
  void emit(S state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
