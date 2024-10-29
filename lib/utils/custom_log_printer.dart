import 'dart:developer';

class CustomLogPrinter {
  static CustomLogPrinter instance = CustomLogPrinter();
  void printLog(String val) {
    try {
      log(val);
    } catch (e) {
      log("printDebugLog Exception ==>$e");
    }
  }

  printDebugLog(String val, dynamic er, dynamic st) {
    try {
      log(val, name: val, error: er, stackTrace: st);
    } catch (e) {
      log("printDebugLog Exception ==>$e");
    }
  }
}
