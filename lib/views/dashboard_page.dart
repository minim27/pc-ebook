import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/controllers/dashboard_controller.dart';

import '../utils/my_colors.dart';
import '../widgets/my_scaffold.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.dashboardSelected,
  });

  final int dashboardSelected;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final dashboardC = Get.put(DashboardController());

  @override
  void initState() {
    dashboardC.dashboardSelected.value = widget.dashboardSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => MyScaffold(
          body: dashboardC.pageList
              .elementAt(dashboardC.dashboardSelected.value!),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: MyColors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: dashboardC.dashboardSelected.value!,
              items: List.generate(
                dashboardC.menuDashboard.length,
                (index) => BottomNavigationBarItem(
                  icon: Image.asset(
                    dashboardC.menuDashboard[index]["icon"],
                    scale: 4,
                  ),
                  activeIcon: Image.asset(
                    dashboardC.menuDashboard[index]["iconActive"],
                    scale: 4,
                  ),
                  label: dashboardC.menuDashboard[index]["label"],
                ),
              ),
              onTap: (index) => dashboardC.changeMenu(index: index),
            ),
          ),
        ));
  }
}
