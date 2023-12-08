import 'package:easter_egg/res/puzzle_constants.dart';
import 'package:easter_egg/utils/providers.dart';
import 'package:easter_egg/utils/puzzle_solver.dart';
import 'package:easter_egg/utils/states/image_splitter_state.dart';
import 'package:easter_egg/utils/states/puzzle_state.dart';
import 'package:easter_egg/widgets/countdown_overlay.dart';
import 'package:easter_egg/widgets/failed_dialog.dart';
import 'package:easter_egg/widgets/game_button_widget.dart';
import 'package:easter_egg/widgets/moves_tiles_text.dart';
import 'package:easter_egg/widgets/moves_tiles_widget.dart';
import 'package:easter_egg/widgets/puzzle_widget.dart';
import 'package:easter_egg/widgets/success_dialog.dart';
import 'package:easter_egg/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/puzzle_data.dart';

class PhotoScreen extends ConsumerStatefulWidget {
  const PhotoScreen({
    required this.solverClient,
    required this.initialPuzzleData,
    required this.puzzleSize,
    required this.puzzleType,
    required this.riveController,
    Key? key,
  }) : super(key: key);

  final PuzzleSolverClient solverClient;
  final PuzzleData initialPuzzleData;
  final int puzzleSize;
  final String puzzleType;
  final RiveAnimationController riveController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends ConsumerState<PhotoScreen>
    with SingleTickerProviderStateMixin {
  late final PuzzleSolverClient _solverClient;
  late final int _puzzleSize;
  late final PuzzleData _initialPuzzleData;
  bool _isStartPressed = false;
  bool isVibrating = false;
  List<Image>? _previousImages;
  final Uri _url = Uri.parse(
      'https://www.climate-chance.org/agenda/conference-dubai-2023-changements-climatiques-cop-28/');
  bool showMessageFlag = true;

  @override
  void initState() {
    _solverClient = widget.solverClient;
    _puzzleSize = widget.puzzleSize;
    _initialPuzzleData = widget.initialPuzzleData;
    startAccelerometer();

    super.initState();
  }

  void startAccelerometer() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      double totalAcceleration = event.x.abs() + event.y.abs() + event.z.abs();
      double vibrationThreshold = 25.0;
      if (totalAcceleration > vibrationThreshold) {
        setState(() {
          isVibrating = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(puzzleNotifierProvider(_solverClient),
        (previous, PuzzleState next) {
      if (next is PuzzleSolved) {
        showSuccessDialog(context);
      }
      if (next is PuzzleInitializing) {
        setState(() {
          _isStartPressed = true;
        });
      }
    });

    ref.listen(imageSplitterNotifierProvider, (previous, next) {
      if (next is ImageSplitterComplete) {
        setState(() {
          _previousImages = next.images;
        });
      }
    });

    void _showMessage(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            title: const Center(child: Text('COP 28 UAE')),
            content: Lottie.asset(
              'assets/animations/climat.json',
              height: 100,
              width: 50,
            ),
            actions: <Widget>[
              const Text(
                'Conférence de Dubaï 2023 sur les changements climatiques',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: () async {
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      child: const Text('Apprendre encore plus'),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      );
    }

    var fontSize = 48.0;
    var boardSize = 300.0;

    var spacing = 2;
    var eachBoxSize = (boardSize / _puzzleSize) - (spacing * (_puzzleSize - 1));

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Puzzle Challenge',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                MovesTilesWidget(
                  solverClient: _solverClient,
                  fontSize: 22,
                ),
                const SizedBox(height: 8),
                const TimerWidget(fontSize: 24),
                const SizedBox(height: 32),
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(imageSplitterNotifierProvider);

                    return state.maybeWhen(
                      () => PuzzleWidget(
                        solverClient: _solverClient,
                        boardSize: boardSize,
                        eachBoxSize: eachBoxSize,
                        initialPuzzleData: _initialPuzzleData,
                        fontSize: fontSize,
                        images: _previousImages,
                        kInitialSpeed: kInitialSpeed,
                        borderRadius: 16,
                      ),
                      complete: (image, images, palette) {
                        _previousImages = images;

                        return PuzzleWidget(
                          solverClient: _solverClient,
                          boardSize: boardSize,
                          eachBoxSize: eachBoxSize,
                          initialPuzzleData: _initialPuzzleData,
                          fontSize: fontSize,
                          images: images,
                          kInitialSpeed: kInitialSpeed,
                          borderRadius: 16,
                        );
                      },
                      orElse: () => PuzzleWidget(
                        solverClient: _solverClient,
                        boardSize: boardSize,
                        eachBoxSize: eachBoxSize,
                        initialPuzzleData: _initialPuzzleData,
                        fontSize: fontSize,
                        images: _previousImages,
                        kInitialSpeed: kInitialSpeed,
                        borderRadius: 16,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GameButtonWidget(
                  solverClient: _solverClient,
                  initialPuzzleData: _initialPuzzleData,
                  padding: const EdgeInsets.only(top: 10.0, bottom: 9.0),
                  width: 130,
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Lottie.asset(
                      'assets/animations/party.json',
                      animate: isVibrating ? true : false,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/fans.json',
                              animate: isVibrating ? true : false,
                              width: MediaQuery.of(context).size.width / 3,
                            ),
                            Lottie.asset(
                              'assets/animations/fans.json',
                              animate: isVibrating ? true : false,
                              width: MediaQuery.of(context).size.width / 3,
                            ),
                            Lottie.asset(
                              'assets/animations/fans.json',
                              animate: isVibrating ? true : false,
                              width: MediaQuery.of(context).size.width / 3,
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              color: Colors.green.shade100,
                              height: 200,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final state = ref.watch(
                                    puzzleNotifierProvider(_solverClient));
                                return state.when(
                                  () => Lottie.asset(
                                    'assets/animations/runner.json',
                                    animate: false,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                  initializing: () => Lottie.asset(
                                    'assets/animations/runner.json',
                                    animate: false,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                  scrambling: (_) => Lottie.asset(
                                    'assets/animations/runner.json',
                                    animate: false,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                  current: (puzzleData) => Column(
                                    children: [
                                      Lottie.asset(
                                        'assets/animations/runner.json',
                                        animate: puzzleData.moves != 0
                                            ? true
                                            : false,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                      ),
                                      puzzleData.moves == 28
                                          ? Builder(
                                              builder: (BuildContext context) {
                                                if (showMessageFlag) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    _showMessage(context);
                                                  });
                                                  showMessageFlag = false;
                                                }
                                                return Container();
                                              },
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                  computingSolution: (puzzleData) =>
                                      Lottie.asset(
                                    'assets/animations/runner.json',
                                    animate: true,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                  autoSolving: (puzzleData) => Lottie.asset(
                                    'assets/animations/runner.json',
                                    animate: true,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                  solved: (puzzleData) => MovesTilesText(
                                    moves: puzzleData.moves,
                                    tiles: puzzleData.tiles,
                                    fontSize: fontSize,
                                  ),
                                  error: (_) => Lottie.asset(
                                    'assets/animations/runner.json',
                                    animate: false,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        CountdownOverlay(
          isStartPressed: _isStartPressed,
          onFinish: () {
            ref.read(timerNotifierProvider.notifier).startTimer();
            setState(
              () {
                _isStartPressed = false;
              },
            );
          },
          initialSpeed: kInitialSpeed,
        ),
      ],
    );
  }
}
