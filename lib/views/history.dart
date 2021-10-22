import 'package:eatpon_wraith/import.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableId = context.watch<CartModel>().tableId;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/carts')
          .where("table_id", isEqualTo: tableId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        for (QueryDocumentSnapshot doc in snapshot.data.docs) {
          final docRef = doc.reference ?? null;
          final data = doc.data();
          final dataPrice = data["price"] ?? null;
          final dataPoint = data["point"] ??
              (dataPrice != null ? (dataPrice * 0.08).round() : null);
          final item = {
            'docRef': docRef,
            'price': dataPrice,
            'point': dataPoint,
            'position': null,
            'title': data['title'] ?? '',
            'options': data['options'],
          };
          print(data);
          context.watch<HistoryCartModel>().addPrice(item['price']);
          context.watch<HistoryCartModel>().addPoint(item['point']);
          Map mergedItem = item;
          mergedItem.addAll(Map<String, dynamic>.from(
              {'options': context.watch<ItemModel>().options.toList()}));
          context.watch<HistoryCartModel>().addItem(mergedItem);
        }
        return _History();
      },
    );
  }
}

class _History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tableId = context.watch<CartModel>().tableId;
    if (tableId == null) {
      return Text('QRコードを読み取ってください');
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
          '注文履歴',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Color(0xffc4c4c4),
        child: _CartItems(),
      ),
    );
  }
}

class _CartItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<HistoryCartModel>();
    if (cart == null) return Text('e10988');
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
                              IconButton(
                                onPressed: () {
                                  return null;
                                },
                                icon: Icon(Icons.remove_circle),
                              ),
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
