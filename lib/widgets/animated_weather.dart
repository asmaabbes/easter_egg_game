import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedWeather extends StatelessWidget {
  const AnimatedWeather({
    Key? key,
    required this.boardSize,
    required Function(Artboard artboard) onInit,
    required RiveAnimationController riveController,
    EdgeInsets padding = const EdgeInsets.only(right: 56.0, bottom: 56),
  })  : _riveController = riveController,
        super(key: key);

  final double boardSize;
  final RiveAnimationController _riveController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: boardSize * 0.9,
        height: boardSize * 0.9,
        child: RiveAnimation.asset(
          'assets/animations/weathericon.riv',
          fit: BoxFit.contain,
          controllers: [_riveController],
        ),
      ),
    );
  }
}
