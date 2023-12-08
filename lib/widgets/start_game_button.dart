import 'package:flutter/material.dart';

class StartGameButton extends StatelessWidget {
  const StartGameButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.width,
    required this.padding,
  }) : super(key: key);

  final String text;
  final Function()? onTap;
  final double width;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.orange),
        ),
        onPressed: onTap,
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
