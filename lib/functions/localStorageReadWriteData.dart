import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageReadWriteData implements LocalStorage {
  @override
  late ValueNotifier<Error> onError;

  @override
  late Future<bool> ready;

  @override
  Future<void> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(String key) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  getItem(String key) {
    // TODO: implement getItem
    final value = getItem('isisUserLoggedInUsingMasterPassword');
    return value;
    throw UnimplementedError();
  }

  @override
  Future<void> setItem(String key, value,
      [Object Function(Object nonEncodable)? toEncodable]) {
    // TODO: implement setItem
    throw UnimplementedError();
  }

  @override
  // TODO: implement stream
  Stream<Map<String, dynamic>> get stream => throw UnimplementedError();
}
