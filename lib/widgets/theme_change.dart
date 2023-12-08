import 'package:flutter/material.dart';

class ThemeChangeObserver extends WidgetsBindingObserver {
  VoidCallback? onThemeChangedCallback;

  @override
  void didChangePlatformBrightness() {
    if (onThemeChangedCallback != null) {
      onThemeChangedCallback!();
    }
  }
}