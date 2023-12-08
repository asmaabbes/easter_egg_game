import 'package:easter_egg/screens/puzzle/puzzle_starter_screen.dart';
import 'package:easter_egg/utils/providers.dart';
import 'package:easter_egg/utils/states/image_splitter_state.dart';
import 'package:easter_egg/widgets/start_game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    final tween = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.9, 0.0),
    );

    _animation = tween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Lottie.asset(
                  "assets/animations/sun.json",
                  height: 200,
                  width: 200,
                ),
                GestureDetector(
                  onTap: () {
                    _controller.forward();
                    setState(() {
                      _controller.addStatusListener((status) {
                        if (status == AnimationStatus.completed) {
                          setState(() {
                            _isPlaying = true;
                          });
                        }
                      });
                    });
                  },
                  child: SlideTransition(
                    position: _animation,
                    child: Lottie.asset(
                      "assets/animations/cloud.json",
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
              ],
            ),
            _isPlaying
                ? Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          "assets/animations/player.json",
                          height: 300,
                          width: 300,
                        ),
                        _isPlaying
                            ? StartGameButton(
                                text: 'Start Game',
                                onTap: () {
                                  final state =
                                      ref.read(imageSplitterNotifierProvider);
                                  if (state is! ImageSplitterComplete) {
                                    ref
                                        .read(imageSplitterNotifierProvider
                                            .notifier)
                                        .getInitialImages(puzzleSize: 3);
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PuzzleStarterScreen(),
                                    ),
                                  );
                                },
                                width: MediaQuery.of(context).size.width * 0.6,
                                padding: const EdgeInsets.all(10),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
