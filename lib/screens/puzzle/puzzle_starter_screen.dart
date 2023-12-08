import 'package:easter_egg/screens/puzzle/photo_screen.dart';
import 'package:easter_egg/utils/providers.dart';
import 'package:easter_egg/utils/puzzle_solver.dart';
import 'package:easter_egg/utils/states/puzzle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import '../../models/puzzle_data.dart';

class PuzzleStarterScreen extends ConsumerStatefulWidget {
  const PuzzleStarterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends ConsumerState<PuzzleStarterScreen> {
  late final PuzzleSolverClient _solverClient;
  late RiveAnimationController _riveController;
  final int _puzzleSize = 3;
  late final PuzzleData _initialPuzzleData;

  @override
  void initState() {
    _riveController = SimpleAnimation('Idle');
    _solverClient = PuzzleSolverClient(size: _puzzleSize);
    _initialPuzzleData = ref
        .read(puzzleNotifierProvider(_solverClient).notifier)
        .generateInitialPuzzle();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(puzzleNotifierProvider(_solverClient),
        (previous, PuzzleState next) {
      if (next is PuzzleSolved) {
        ref.read(timerNotifierProvider.notifier).stopTimer();
      }
    });

    final currentPuzzleType = ref.watch(puzzleTypeNotifierProvider);

    final name = currentPuzzleType.name[0].toUpperCase() +
        currentPuzzleType.name.substring(1);

    return PhotoScreen(
      solverClient: _solverClient,
      initialPuzzleData: _initialPuzzleData,
      puzzleSize: _puzzleSize,
      puzzleType: name,
      riveController: _riveController,
    );
  }
}
