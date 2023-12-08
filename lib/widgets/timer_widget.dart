import 'package:easter_egg/utils/providers.dart';
import 'package:easter_egg/widgets/theme_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerWidget extends ConsumerWidget {
  const TimerWidget({
    Key? key,
    required this.fontSize,
  }) : super(key: key);

  final double fontSize;

  @override
  Widget build(BuildContext context, ref) {
    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;

    bool isDarkMode = platformBrightness == Brightness.dark;
    final ThemeChangeObserver _observer = ThemeChangeObserver();
    _observer.onThemeChangedCallback = () {
      ref.read(timerNotifierProvider.notifier).addFiveMinutes();
    };
    WidgetsBinding.instance.addObserver(_observer);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer(
          builder: (context, ref, child) {
            String state = ref.watch(timerNotifierProvider);
            return Text(
              state,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        isDarkMode
            ? const Icon(Icons.nightlight_rounded)
            : Icon(
                Icons.light_mode_rounded,
                color: Colors.black,
                size: fontSize,
              ),
      ],
    );
  }
}
