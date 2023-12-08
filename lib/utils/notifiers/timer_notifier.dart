import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerNotifier extends StateNotifier<String> {
  TimerNotifier() : super('00:10:00');

  Timer? _timer;
  var _initialDuration = const Duration(minutes: 10);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  startTimer() {
    _timer?.cancel(); // Cancel any existing timer

    state = getDurationString(_initialDuration); // Set initial duration

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_initialDuration.inSeconds > 0) {
        _initialDuration -= const Duration(seconds: 1);
        state = getDurationString(_initialDuration);
      } else {
        stopTimer();
      }
    });
  }

  stopTimer() {
    _timer?.cancel();
  }

  String getTimer(){
    return getDurationString(_initialDuration);
  }

  addFiveMinutes() {
    _initialDuration += const Duration(minutes: 5);
    state = getDurationString(_initialDuration);
  }

  String getDurationString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
