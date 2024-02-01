import 'dart:math' show pi, sin, cos;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rotating Polygon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Polygon extends CustomPainter {
  final int sides;

  Polygon({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final path = Path();

    final center = Offset(size.width / 2, size.height / 2);

    final angle = 2 * pi / sides;

    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2;

    /*
      x = center.x + radius * cos(angle)
      y = center.y + radius * sin(angle)
    */

    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );

    for (var angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is Polygon && oldDelegate.sides != sides;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _sidesAnimationController;
  late Animation _sidesAnimation;

  @override
  void initState() {
    super.initState();

    _sidesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _sidesAnimation =
        IntTween(begin: 3, end: 10).animate(_sidesAnimationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sidesAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    _sidesAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF373D20),
      body: Center(
        child: AnimatedBuilder(
            animation: Listenable.merge(
              [
                _sidesAnimationController,
              ],
            ),
            builder: (context, child) {
              return CustomPaint(
                painter: Polygon(sides: _sidesAnimation.value),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).width,
                ),
              );
            }),
      ),
    );
  }
}
