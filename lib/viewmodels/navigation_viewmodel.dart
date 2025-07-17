import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationViewModel extends StateNotifier<int> {
  NavigationViewModel() : super(0);

  final PageController pageController = PageController();

  void setIndex(int index) {
    state = index;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

final navigationViewModelProvider =
    StateNotifierProvider<NavigationViewModel, int>(
      (ref) => NavigationViewModel(),
    );
