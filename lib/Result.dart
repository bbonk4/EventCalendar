class Result<T> {

  bool get passed {
    var res = data != null && errorMessages.isEmpty;
    if (res) {
      if (data is String) {
        res = (data as String).isNotEmpty;
      }
    }

    return res;
  }

  T data;
  List<String> errorMessages = <String>[];
}