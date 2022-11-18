import 'dart:convert';

import 'package:debounce/controller/connector.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';

class SignatureHelper {
  static Future<String?> sign(dynamic data) async {
    ConnectController connector = Get.find();
    if (!connector.isConnected) return null;

    try {
      final signature = await Web3Provider(ethereum).getSigner().signMessage(jsonEncode(data));
      return signature;
    } catch (err) {
      print("sing err $err");
    }

    return null;
  }
}
