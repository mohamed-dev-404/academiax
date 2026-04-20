// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

html.EventListener? _beforeUnloadListener;

void addPreventDefaultWarning() {
  _beforeUnloadListener = (html.Event event) {
    final beforeUnloadEvent = event as html.BeforeUnloadEvent;
    beforeUnloadEvent.returnValue =
        'Are you sure you want to leave? Your quiz progress will be lost.';
  };
  html.window.addEventListener('beforeunload', _beforeUnloadListener!);
}

void removePreventDefaultWarning() {
  if (_beforeUnloadListener != null) {
    html.window.removeEventListener('beforeunload', _beforeUnloadListener!);
    _beforeUnloadListener = null;
  }
}
