import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/views/favorite/favorite_page.dart';
import 'package:pc_book_dika_desandra_ardiansyah/views/home/home_page.dart';

import '../utils/my_icons.dart';

class DashboardController extends GetxController {
  List<Map<String, dynamic>> menuDashboard = [
    {
      "icon": MyIcons.icHome,
      "iconActive": MyIcons.icHomeActive,
      "label": "Home",
    },
    {
      "icon": MyIcons.icBookmark,
      "iconActive": MyIcons.icBookmarkActive,
      "label": "Favorite",
    },
  ];

  List pageList = [
    const HomePage(),
    const FavoritePage(),
  ];

  var dashboardSelected = Rxn<int>();

  changeMenu({required int index}) => dashboardSelected.value = index;
}
