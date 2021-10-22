import 'package:eatpon_wraith/import.dart';
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  List items = [];
  int totalPrice = 0;
  int totalPoint = 0;
  int itemsLength = 0;
  String tableId;

  void addPrice(data) {
    totalPrice += data;
    notifyListeners();
  }

  void addPoint(data) {
    totalPoint += data;
    notifyListeners();
  }

  void addItem(data) {
    items.add(data);
    itemsLength += 1;
    notifyListeners();
  }

  void deleteItem(index) {
    final _item = items[index];
    addPoint(-(_item['point'] ?? 0));
    addPrice(-(_item['price'] ?? 0));
    items.removeAt(index);
    itemsLength -= 1;
    notifyListeners();
  }

  void deleteValue() {
    items = [];
    totalPrice = 0;
    totalPoint = 0;
    itemsLength = 0;
  }

  void setTableId(String data) {
    tableId = data;
  }
}

class HistoryCartModel extends ChangeNotifier {
  List items = [];
  int totalPrice = 0;
  int totalPoint = 0;
  int itemsLength = 0;

  void addPrice(data) {
    totalPrice += data;
    notifyListeners();
  }

  void addPoint(data) {
    totalPoint += data;
    notifyListeners();
  }

  void addItem(data) {
    items.add(data);
    itemsLength += 1;
    notifyListeners();
  }

  void deleteValue() {
    items = [];
    totalPrice = 0;
    totalPoint = 0;
    itemsLength = 0;
  }
}

class ItemModel extends ChangeNotifier {
  List options = [];

  void setOptions(data) {
    options = data;
  }

  void applyOption(Map data, int i) {
    options[i].addAll(Map<String, dynamic>.from(data));
  }

  void updateOption(Map data, int i) {
    options[i].addAll(Map<String, dynamic>.from(data));
    notifyListeners();
  }

  void toggleVisible(int i) {
    bool oppositeOfSelected = options[i]['visible'] == true ? false : true;
    options.forEach((option) {
      option['visible'] = false;
    });
    options[i]['visible'] = oppositeOfSelected;
    notifyListeners();
  }
}

class ItemCount extends ChangeNotifier {
  int count = 1;
  void increment(int amount) {
    count += amount;
    notifyListeners();
  }
}
