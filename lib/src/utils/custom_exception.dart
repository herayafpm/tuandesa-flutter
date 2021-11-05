class CustomException {
  static Map<String, dynamic> data(text) {
    var jsonObject = {"status": false, "messages": text, "data": []};
    return jsonObject;
  }
}
