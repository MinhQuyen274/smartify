import 'package:flutter/material.dart';

class WalkthroughController extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;

  final List<String> walkthroughImages = [
    'assets/tutorial/2_Light_walkthrough 1.png',
    'assets/tutorial/3_Light_walkthrough 2.png',
    'assets/tutorial/4_Light_walkthrough 3.png',
  ];

  int get currentPage => _currentPage;
  bool get isLastPage => _currentPage == walkthroughImages.length - 1;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLast() {
    pageController.animateToPage(
      walkthroughImages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
