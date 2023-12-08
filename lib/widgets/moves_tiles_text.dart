import 'package:flutter/material.dart';

class MovesTilesText extends StatelessWidget {
  final int moves;
  final int tiles;
  final double fontSize;

  const MovesTilesText({
    Key? key,
    required this.moves,
    required this.tiles,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: moves.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const TextSpan(text: ' Moves'),
            ],
          ),
        ),
        const Icon(
          Icons.directions_run_rounded,
          color: Colors.black,
          size: 40,
        )
      ],
    );
  }
}
