import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/local_databases/tables/config/ldb_config_table.dart';
import 'package:pc_book_dika_desandra_ardiansyah/views/dashboard_page.dart';

import '../../local_databases/sql/ldb_sql_query.dart';

class OnboardingController extends GetxController {
  var pageIController = PageController();
  var pageTController = PageController();

  var pageSelected = 0.obs;

  skip() => Get.offAll(const DashboardPage(dashboardSelected: 0));

  back() {
    if (pageSelected.value > 0) {
      pageSelected.value--;
      pageIController.animateToPage(
        pageSelected.value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      pageTController.animateToPage(
        pageSelected.value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  next() async {
    if (pageSelected.value < 2) {
      pageSelected.value++;
      pageIController.animateToPage(
        pageSelected.value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      pageTController.animateToPage(
        pageSelected.value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      await LDBSQLQuery.sqlQuery(
        query:
            '''insert into ${LDBConfigTable.tableName} (${LDBConfigTable.name},${LDBConfigTable.value}) values("isNew","false")''',
      );
      Get.offAll(const DashboardPage(dashboardSelected: 0));
    }
  }
}
