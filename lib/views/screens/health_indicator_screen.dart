import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/bmi_viewmodel.dart';
import 'package:nutripal/views/widgets/bmi_tab.dart';
import 'package:nutripal/views/widgets/tdee_tab.dart';

class HealthIndicatorScreen extends ConsumerStatefulWidget {
  const HealthIndicatorScreen({super.key});

  @override
  ConsumerState<HealthIndicatorScreen> createState() =>
      _HealthIndicatorScreenState();
}

class _HealthIndicatorScreenState extends ConsumerState<HealthIndicatorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (didPop) {
            ref.read(bmiViewModelProvider.notifier).resetToUserBMI();
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          title: Text(
            "Chỉ số sức khoẻ",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(25),
            child: TabBar(
              controller: _tabController,
              indicatorWeight: 3,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              indicatorColor: _currentIndex == 0
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).colorScheme.secondary,
              labelColor: _currentIndex == 0
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).colorScheme.secondary,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              tabs: const <Tab>[
                Tab(text: "BMI"),
                Tab(text: "TDEE"),
              ],
            ),
          ),
        ),
        body: Center(
          child: TabBarView(
            controller: _tabController,
            children: const [BMITab(), TDEETab()],
          ),
        ),
      ),
    );
  }
}
