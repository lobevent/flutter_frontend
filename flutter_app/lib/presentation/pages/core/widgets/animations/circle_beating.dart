import 'package:flutter/material.dart';

class CircleBeating extends StatefulWidget {
  final double size;
  final Color color;

  const CircleBeating({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _CircleBeatingState createState() => _CircleBeatingState();
}

class _CircleBeatingState extends State<CircleBeating> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final Color color = widget.color;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Visibility(
              visible: _animationController.value <= 0.7,
              child: Transform.scale(
                scale: Tween<double>(begin: 0.15, end: 1.0)
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(
                      0.0,
                      0.7,
                      curve: Curves.easeInCubic,
                    ),
                  ),
                )
                    .value,
                child: Opacity(
                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.0, 0.2),
                    ),
                  )
                      .value,
                  child: Ring.draw(
                    color: color,
                    size: size,
                    strokeWidth: Tween<double>(begin: size / 5, end: size / 8)
                        .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.0, 0.7),
                      ),
                    )
                        .value,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value <= 0.7,
              child: Ring.draw(
                color: color,
                size: size,
                strokeWidth: size / 8,
              ),
            ),
            Visibility(
              visible: _animationController.value <= 0.8 &&
                  _animationController.value >= 0.7,
              child: Transform.scale(
                scale: Tween<double>(begin: 1.0, end: 1.15)
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(
                      0.7,
                      0.8,
                    ),
                  ),
                )
                    .value,
                child: Ring.draw(
                  color: color,
                  size: size,
                  strokeWidth: size / 8,
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value >= 0.8,
              child: Transform.scale(
                scale: Tween<double>(begin: 1.15, end: 1.0)
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(
                      0.8,
                      0.9,
                    ),
                  ),
                )
                    .value,
                child: Ring.draw(
                  color: color,
                  size: size,
                  strokeWidth: size / 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}



class Ring extends CustomPainter {
  final Color _color;
  final double _strokeWidth;

  Ring(
      this._color,
      this._strokeWidth,
      );

  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: Ring(
            color,
            strokeWidth,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height / 2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}