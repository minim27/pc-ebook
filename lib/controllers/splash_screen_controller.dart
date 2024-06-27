import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/local_databases/tables/config/ldb_config_table.dart';
import 'package:pc_book_dika_desandra_ardiansyah/views/dashboard_page.dart';

import '../local_databases/sql/ldb_sql_query.dart';
import '../views/onboarding/onboarding_page.dart';

class SplashScreenController extends GetxController {
  animatedSplashScreen() async {
    await Future.delayed(const Duration(seconds: 3)).then((value) async {
      var data = await LDBSQLQuery.sqlQuery(
          query:
              '''select value from ${LDBConfigTable.tableName} where name="isNew"''');

      if (data.isEmpty) {
        Get.offAll(const OnboardingPage());
      } else {
        Get.offAll(const DashboardPage(dashboardSelected: 0));
      }
    });
  }
}
