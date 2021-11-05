class CekAuthorization {
  static String whoIs(String type) {
    return type;
    // if (type == 1) {
    //   return "Penduduk";
    // } else if (type == 2) {
    //   return "Amil";
    // } else if (type == 3) {
    //   return "Admin Aduan";
    // } else if (type == 4) {
    //   return "Admin Pelayanan";
    // } else if (type == 5) {
    //   return "Admin Bantuan";
    // } else if (type == 6) {
    //   return "Admin Zakat";
    // } else if (type == 7) {
    //   return "Super Admin";
    // }
  }

  static bool isAmil(String type) {
    if (type == "Amil") {
      return true;
    } else {
      return false;
    }
  }

  static bool isAdminOrAduan(String type) {
    if (type == "Super Admin" || type == "Admin Aduan") {
      return true;
    } else {
      return false;
    }
  }

  static bool isNotAdmin(String type) {
    if (type != "Super Admin") {
      return true;
    } else {
      return false;
    }
  }
}
