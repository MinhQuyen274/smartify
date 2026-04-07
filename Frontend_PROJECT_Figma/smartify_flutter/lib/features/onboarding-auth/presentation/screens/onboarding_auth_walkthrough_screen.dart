import 'package:flutter/material.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import '../controllers/walkthrough_controller.dart';
import 'onboarding_auth_welcome_screen.dart';

class OnboardingAuthWalkthroughScreen extends StatefulWidget {
  const OnboardingAuthWalkthroughScreen({super.key});

  @override
  State<OnboardingAuthWalkthroughScreen> createState() => _OnboardingAuthWalkthroughScreenState();
}

class _OnboardingAuthWalkthroughScreenState extends State<OnboardingAuthWalkthroughScreen> {
  late WalkthroughController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WalkthroughController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller.pageController,
                  onPageChanged: _controller.onPageChanged,
                  itemCount: _controller.walkthroughImages.length,
                  itemBuilder: (context, index) {
                    return WalkthroughContent(
                      image: _controller.walkthroughImages[index],
                    );
                  },
                ),
              ),
              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _controller.walkthroughImages.length,
                  (index) => buildDot(index: index),
                ),
              ),
              const SizedBox(height: 24),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _controller.isLastPage
                    ? SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.onboardingAuthWelcome,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A64FE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Let's Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: TextButton(
                                onPressed: _controller.skipToLast,
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFF2F5FE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4A64FE),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _controller.nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A64FE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 32), // Bottom padding
            ],
          ),
        );
      },
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _controller.currentPage == index ? 32 : 8,
      decoration: BoxDecoration(
        color: _controller.currentPage == index
            ? const Color(0xFF4A64FE)
            : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class WalkthroughContent extends StatelessWidget {
  final String image;

  const WalkthroughContent({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset(
        image,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
