import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'home/home_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'analytics/analytics_screen.dart';
import 'support/support_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DashboardScreen(),
    const AnalyticsScreen(),
    const SupportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.cardBackground,
              elevation: 0,
              selectedItemColor: AppColors.primaryHighlight,
              unselectedItemColor: AppColors.textSecondary.withOpacity(0.5),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  activeIcon: Icon(Icons.calendar_today),
                  label: 'Ciclo',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insights_outlined),
                  activeIcon: Icon(Icons.insights),
                  label: 'Insights',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.support_agent_outlined),
                  activeIcon: Icon(Icons.support_agent),
                  label: 'Apoio',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
