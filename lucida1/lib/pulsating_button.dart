import 'package:flutter/material.dart';

class PulsatingButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const PulsatingButton({
    Key? key,
    required this.isListening,
    required this.onPressed,
  }) : super(key: key);

  @override
  _PulsatingButtonState createState() => _PulsatingButtonState();
}

class _PulsatingButtonState extends State<PulsatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 12.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 72 + _animation.value,
          height: 72 + _animation.value,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(16),
            ),
            onPressed: widget.onPressed,
            child: Icon(
              widget.isListening ? Icons.mic : Icons.mic_none,
              size: 36,
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.isListening
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      spreadRadius: _animation.value,
                      blurRadius: _animation.value,
                    ),
                  ]
                : [],
          ),
        );
      },
    );
  }
}
