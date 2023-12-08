import 'package:easter_egg/utils/image_splitter.dart';
import 'package:easter_egg/utils/notifiers/image_splitter_notifier.dart';
import 'package:easter_egg/utils/notifiers/puzzle_notifier.dart';
import 'package:easter_egg/utils/notifiers/puzzle_type_notifier.dart';
import 'package:easter_egg/utils/notifiers/timer_notifier.dart';
import 'package:easter_egg/utils/puzzle_solver.dart';
import 'package:easter_egg/utils/states/image_splitter_state.dart';
import 'package:easter_egg/utils/states/puzzle_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final imageSplitterProvider = Provider<ImageSplitter>(
  (ref) => ImageSplitter(),
);

final puzzleNotifierProvider = StateNotifierProvider.family<PuzzleNotifier,
    PuzzleState, PuzzleSolverClient>(
  (ref, solverClient) => PuzzleNotifier(solverClient),
);

final imageSplitterNotifierProvider =
    StateNotifierProvider<ImageSplitterNotifier, ImageSplitterState>(
  (ref) => ImageSplitterNotifier(
    ref.watch(imageSplitterProvider),
  ),
);

final timerNotifierProvider = StateNotifierProvider<TimerNotifier, String>(
  ((ref) => TimerNotifier()),
);

final puzzleTypeNotifierProvider =
    StateNotifierProvider<PuzzleTypeNotifier, PuzzleType>(
  (ref) => PuzzleTypeNotifier(),
);

