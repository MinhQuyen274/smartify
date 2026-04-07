import 'package:flutter/material.dart';

class OnboardingDevicePreview extends StatelessWidget {
  const OnboardingDevicePreview({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final previewWidth = constraints.maxWidth
            .clamp(220.0, 286.0)
            .toDouble();
        return Center(
          child: SizedBox(
            width: previewWidth,
            child: AspectRatio(
              aspectRatio: 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0D14),
                  borderRadius: BorderRadius.circular(42),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 30,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: previewWidth * 0.34,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFF090A0F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
