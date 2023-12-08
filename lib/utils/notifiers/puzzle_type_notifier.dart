import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PuzzleType {
  photo,
}

class PuzzleTypeNotifier extends StateNotifier<PuzzleType> {
  PuzzleTypeNotifier() : super(PuzzleType.photo);
}
