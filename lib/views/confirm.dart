import 'package:eatpon_wraith/import.dart';

class ConfirmOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableId = context.watch<CartModel>().tableId;
    if (tableId == null) {
      // Navigator.pushNamed(context, '/no_id');
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Text(
          'ご注文内容の確認',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Color(0xffc4c4c4),
        child: CartItems(),
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    if (cart == null) return null;
    if (cart.items == null || cart.items == []) return null;
    List<Widget> _cartItems = [];
    final dataPrice = cart.totalPrice ?? null;
    final dataPoint = cart.totalPoint ??
        (dataPrice != null ? (dataPrice * 0.08).round() : null);
    cart.items.asMap().forEach(
      (itemIndex, item) {
        List<Widget> _itemOptions = [];
        _itemOptions.add(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              item['title'] ?? '-',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
        item['options'].asMap().forEach(
          (optionIndex, option) {
            final optionTitle = option['choices'][option['selectedIndex']];
            _itemOptions.add(
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  optionTitle ?? '-',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff737373),
                  ),
                ),
              ),
            );
          },
        );
        _cartItems.add(
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: _itemOptions,
                        ),
                      ),
                      Container(
                        height: 44,
                        width: 88,
                        child: OutlinedButton(
                          child: Text('変更'),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  final dataPrice = item["price"] ?? null;
                                  final dataPoint = item["point"] ??
                                      (dataPrice != null
                                          ? (dataPrice * 0.08).round()
                                          : null);
                                  final itemForRoute = {
                                    'price': dataPrice,
                                    'point': dataPoint,
                                    'position': null,
                                    'title': item['title'] ?? '',
                                    'options': item['options'] ?? [],
                                  };
                                  return Item(itemForRoute, true);
                                },
                              ),
                            )
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¥' + (item['price'] ?? '-').toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'ポイント：',
                                      style: TextStyle(
                                        color: Color(0xff666666),
                                      ),
                                    ),
                                    TextSpan(
                                      text: (item['point'] ??
                                                  (item['price'] != null
                                                      ? item['price'] * 0.08
                                                      : '-'))
                                              .toString() +
                                          'P',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _DecrementIconButton(itemIndex),
                              Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  return null;
                                },
                                icon: Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xffD8D8D8),
                  padding: EdgeInsets.only(left: 16, right: 16),
                  height: 1,
                )
              ],
            ),
            color: Color(0xffffffff),
          ),
        );
      },
    );

    _cartItems.add(
      Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '¥',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: (dataPrice ?? '-').toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: '獲得ポイント：',
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: (dataPoint ?? '-').toString() + 'P',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 52,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(16),
              child: SendCartButton(),
            ),
          ],
        ),
      ),
    );

    return ListView(
      shrinkWrap: true,
      children: _cartItems,
    );
  }
}

class SendCartButton extends StatelessWidget {
  void sendCart(List items, int price, int point, String tableId) async {
    await FirebaseFirestore.instance
        .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/carts')
        .add({
      'items': items,
      'totalPrice': price,
      'totalPoint': point,
      'cretedAt': Timestamp.fromDate(DateTime.now()),
      'table_id': tableId ?? 'e90042',
    });
  }

  void updateTable(int price, int point, String tableId) async {
    await FirebaseFirestore.instance
        .doc('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/tables/' + tableId)
        .update({
      'totalPrice': FieldValue.increment(price),
      'totalPoint': FieldValue.increment(point),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
      'table_id': tableId ?? '!e90042',
    });
  }

  List mapItems(items) {
    return items
        .map((item) => {'docRef': item['docRef'], 'options': item['options']})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          updateTable(
            context.read<CartModel>().totalPrice,
            context.read<CartModel>().totalPoint,
            context.read<CartModel>().tableId,
          );
          sendCart(
            mapItems(context.read<CartModel>().items),
            context.read<CartModel>().totalPrice,
            context.read<CartModel>().totalPoint,
            context.read<CartModel>().tableId,
          );
          context.read<CartModel>().deleteValue();
          Navigator.pushNamed(context, '/');
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Text('注文する'),
                alignment: Alignment.center,
              ),
            ),
          ],
        ));
  }
}

class _DecrementIconButton extends StatelessWidget {
  final int index;
  _DecrementIconButton(this.index);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<CartModel>().deleteItem(index);
      },
      icon: Icon(Icons.remove_circle),
    );
  }
}
