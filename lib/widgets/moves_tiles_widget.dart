import 'package:easter_egg/utils/providers.dart';
import 'package:easter_egg/utils/puzzle_solver.dart';
import 'package:easter_egg/widgets/moves_tiles_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovesTilesWidget extends StatelessWidget {
  const MovesTilesWidget({
    Key? key,
    required PuzzleSolverClient solverClient,
    this.fontSize = 24,
  })  : _solverClient = solverClient,
        super(key: key);

  final PuzzleSolverClient _solverClient;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(puzzleNotifierProvider(_solverClient));

        return state.when(
          () => MovesTilesText(
            moves: 0,
            tiles: 0,
            fontSize: fontSize,
          ),
          initializing: () => MovesTilesText(
            moves: 0,
            tiles: 0,
            fontSize: fontSize,
          ),
          scrambling: (_) => MovesTilesText(
            moves: 0,
            tiles: 0,
            fontSize: fontSize,
          ),
          current: (puzzleData) => MovesTilesText(
            moves: puzzleData.moves,
            tiles: puzzleData.tiles,
            fontSize: fontSize,
          ),
          computingSolution: (puzzleData) => MovesTilesText(
            moves: puzzleData.moves,
            tiles: puzzleData.tiles,
            fontSize: fontSize,
          ),
          autoSolving: (puzzleData) => MovesTilesText(
            moves: puzzleData.moves,
            tiles: puzzleData.tiles,
            fontSize: fontSize,
          ),
          solved: (puzzleData) => MovesTilesText(
            moves: puzzleData.moves,
            tiles: puzzleData.tiles,
            fontSize: fontSize,
          ),
          error: (_) => MovesTilesText(
            moves: 0,
            tiles: 0,
            fontSize: fontSize,
          ),
        );
      },
    );
  }
}
