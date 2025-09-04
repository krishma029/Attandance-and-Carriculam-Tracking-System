import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _waveController;
  late AnimationController _logoController;
  late AnimationController _progressController;

  late Animation<double> _logoSlideAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoSlideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _cardSlideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _waveAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _waveController,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _startAnimations();

    Timer(const Duration(milliseconds: 3500), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _startAnimations() async {
    _mainController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _waveController.dispose();
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF2B2), // Light green background
      body: Stack(
        children: [
          // Green animated background wave
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: GreenWavePainter(_waveAnimation.value),
                size: Size.infinite,
              );
            },
          ),

          SafeArea(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Transform.translate(
                          offset: Offset(0, _logoSlideAnimation.value),
                          child: Opacity(
                            opacity: _logoFadeAnimation.value,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.15),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: AnimatedBuilder(
                                    animation: _logoController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: 1 + (_logoController.value * 0.1),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/logo1.png',
                                            height: 80,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Opacity(
                                  opacity: _textFadeAnimation.value,
                                  child: const Text(
                                    'Trackademy',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF218838),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom Info Card + Progress
                    Expanded(
                      flex: 1,
                      child: Transform.translate(
                        offset: Offset(0, _cardSlideAnimation.value),
                        child: Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 20,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.check_circle_outline,
                                              color: Color(0xFF218838), size: 24),
                                          SizedBox(width: 8),
                                          Text(
                                            'Attendance Simplified',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2F3E2C),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Automate and visualize your institution’s attendance system.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    return Column(
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: _progressAnimation.value,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF7DC37D),
                                                    Color(0xFF218838),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Setting up your workspace...',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Green wave painter
class GreenWavePainter extends CustomPainter {
  final double animationValue;

  GreenWavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFB4E197),
          Color(0xFFDFF2B2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    path.moveTo(0, size.height * 0.8);

    for (double i = 0; i <= size.width; i++) {
      final wave1 = math.sin((i / size.width * 2 * math.pi) + animationValue) * 20;
      final wave2 = math.sin((i / size.width * 4 * math.pi) + animationValue * 0.5) * 10;
      path.lineTo(i, size.height * 0.8 + wave1 + wave2);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GreenWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
