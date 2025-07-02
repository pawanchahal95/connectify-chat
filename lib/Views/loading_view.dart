import 'package:flutter/material.dart';

class ElegantLoadingScreen extends StatelessWidget {
  final String? message;
  const ElegantLoadingScreen({super.key, this.message = "Please wait..."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFe0f7fa),
          Color(0xFFfce4ec),
        ],
      ).createShader(Rect.fromLTWH(0, 0, 500, 800)).transform(Offset.zero),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFa1c4fd),
              Color(0xFFc2e9fb),
              Color(0xFFfcb69f),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gradient Circle with Shadow
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFff9a9e), Color(0xFFfad0c4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // Subtle heading
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // Animated loader
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),

              const SizedBox(height: 30),

              // Optional subtext
              const Text(
                "Getting things ready for you...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Shader {
  transform(Offset zero) {}
}
