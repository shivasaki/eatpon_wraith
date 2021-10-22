import 'dart:math';

import 'package:eatpon_wraith/import.dart';

class Item extends StatelessWidget {
  final displayItem;
  final bool itemIsRaw;
  Item(this.displayItem, this.itemIsRaw);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ItemModel>(
          create: (_) => ItemModel(),
        ),
        ChangeNotifierProvider<ItemCount>(
          create: (_) => ItemCount(),
        ),
      ],
      child: _Item(displayItem, itemIsRaw),
    );
  }
}

class _Item extends StatelessWidget {
  final displayItem;
  final bool itemIsRaw;
  _Item(this.displayItem, this.itemIsRaw);

  @override
  Widget build(BuildContext context) {
    var data;
    var docRef;
    if (itemIsRaw) {
      data = displayItem;
      docRef = displayItem['docRef'] ?? null;
    } else {
      data = displayItem.data();
      docRef = displayItem.reference ?? null;
    }

    final dataPrice = data["price"] ?? null;
    final dataPoint = data["point"] ??
        (dataPrice != null ? (dataPrice * 0.08).round() : null);

    final item = {
      'docRef': docRef,
      'price': dataPrice,
      'point': dataPoint,
      'position': null,
      'title': data['title'] ?? '',
      'options': data['options'] ?? [],
    };

    final addCart = (int count) {
      for (int i = 0; i < count; i++) {
        context.read<CartModel>().addPrice(item['price']);
        context.read<CartModel>().addPoint(item['point']);
        Map mergedItem = item;
        mergedItem.addAll(
          Map<String, dynamic>.from(
            {
              'options': context.read<ItemModel>().options.toList(),
            },
          ),
        );
        context.read<CartModel>().addItem(mergedItem);
      }
    };

    final itemCounter = context.watch<ItemCount>();
    int itemCount = context.watch<ItemCount>().count;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          (data['title'] ?? '-'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Color(0xffffffff),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Color(0xffc4c4c4),
                child: RandomImage(),
              ),
            ),
            Visibility(
              visible: data['description'] != null,
              child: Container(
                padding: EdgeInsets.only(left: 12, top: 12, right: 12),
                child: Text(
                  data['description'] ?? '',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: OptionsColumn(item),
              ),
            ),
            Container(
              height: 144,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: 144,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
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
                                    text: (dataPrice * itemCount ?? '-')
                                        .toString(),
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
                                    text: (dataPoint * itemCount ?? '-')
                                            .toString() +
                                        'P',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 6),
                      child: Row(
                        children: [
                          _DecrementIconButton(),
                          Container(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              itemCount.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              itemCounter.increment(1);
                            },
                            icon: Icon(Icons.add_circle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        padding: EdgeInsets.all(6),
                        child: OutlinedButton(
                          onPressed: () {
                            addCart(itemCount);
                            Navigator.pushNamed(context, '/confirm');
                          },
                          child: Text(
                            '注文確認へ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 52,
                        padding: EdgeInsets.all(6),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            addCart(itemCount);
                            Navigator.pushNamed(context, '/');
                          },
                          child: Text(
                            'カートに追加',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecrementIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemCounter = context.watch<ItemCount>();
    if (itemCounter.count <= 1) {
      return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.remove_circle,
          color: Color(0xff999999),
        ),
      );
    }
    return IconButton(
      onPressed: () {
        itemCounter.increment(-1);
      },
      icon: Icon(Icons.remove_circle),
    );
  }
}
