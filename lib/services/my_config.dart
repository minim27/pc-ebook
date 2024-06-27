class MyConfig {
  static const bool prod = true;

  static String url = "";

  static String get apiURL {
    if (MyConfig.prod) {
      url = "https://gutendex.com";
    } else {
      url = "";
    }

    return url;
  }

  static const localDBName = "pc_ebook.db";
  static const localDBVer = 1;
}
