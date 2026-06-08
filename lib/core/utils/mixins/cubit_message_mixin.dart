import 'dart:async';

//* Provides a message stream for one-time UI notifications (e.g. snackbars)
mixin CubitMessageMixin {
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;
  void emitMessage(String msg) {
    if (!_messageController.isClosed) {
      _messageController.add(msg);
    }
  }

  void closeMessages() {
    _messageController.close();
  }
}
