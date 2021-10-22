import 'package:eatpon_wraith/import.dart';

class Items extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<QuerySnapshot> initTableAndGetCategories(String tablId) async {
    await FirebaseFirestore.instance
        .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/tables')
        .doc(tablId)
        .update({
      'customers': [auth.currentUser.uid]
    });

    Query categories = FirebaseFirestore.instance
        .collection('stores/tI3kW1PwkdcnO3y7C3rynWVeeOD2/menuCategories')
        .where('hidden', isEqualTo: false)
        .orderBy('position');

    return await categories.get();
  }

  @override
  Widget build(BuildContext context) {
    final tableId = context.watch<CartModel>().tableId;
    if (tableId == null) {
      return Text('QRコードを読み取ってください');
    }
    return FutureBuilder(
      future: initTableAndGetCategories(context.watch<CartModel>().tableId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.error != null) {
          print(snapshot.error.toString());
          return Center(
            child: Text('error'),
          );
        }
        List<Tab> categories = snapshot.data.docs
            .map<Tab>((category) => Tab(text: category.get('displayName')))
            .toList();

        final cart = context.watch<CartModel>();

        return DefaultTabController(
          length: categories.length,
          child: Builder(
            builder: (BuildContext context) {
              final TabController tabController =
                  DefaultTabController.of(context);
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {}
              });
              return Scaffold(
                appBar: AppBar(
                  toolbarHeight: 80,
                  // automaticallyImplyLeading: false,
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          // context.watch<CartModel>().tableId ?? '-',
                          'eightgood事務所',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        '0P',
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  bottom: TabBar(
                    tabs: categories,
                  ),
                ),
                drawer: Drawer(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.close),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text(
                          "注文履歴",
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/history');
                        },
                        leading: Icon(Icons.map),
                      ),
                      ListTile(
                        title: Text(
                          "注文",
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        leading: Icon(Icons.receipt),
                      ),
                      ListTile(
                        title: Text(
                          "アカウント",
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        leading: Icon(Icons.person),
                      ),
                      ListTile(
                        title: Text(
                          auth.currentUser.uid ?? '-',
                          style: TextStyle(
                            color: Color(0xff666666),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Navigator.pushNamed(context, '/login');
                        },
                        leading: Icon(Icons.person),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Container(
                            padding: EdgeInsets.all(14),
                            child: Text('Eatponにログイン'),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            print(context.read<CartModel>().tableId);
                          },
                          child: Container(
                            padding: EdgeInsets.all(14),
                            child: Text('Eatponに新規登録'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: ItemsStack(snapshot.data),
                bottomSheet: Container(
                  color: Colors.transparent,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '支払い金額',
                                        style: TextStyle(
                                          color: Color(0xff666666),
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '¥' + cart.totalPrice.toString(),
                                        style: TextStyle(
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      padding: EdgeInsets.all(2),
                                      margin: EdgeInsets.all(4),
                                      child: Text(
                                        (cart.itemsLength ?? '-').toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '¥',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextSpan(
                                            text: cart.totalPrice.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 52,
                            padding: EdgeInsets.all(8),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
