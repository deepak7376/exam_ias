import 'dart:html' as html;

/// Web-specific implementation
/// This file is only used when dart.library.html is available (web platform)
String getWebOrigin() {
  return html.window.location.origin;
}

