import 'package:eatpon_wraith/import.dart';

class ItemsStack extends StatelessWidget {
  final QuerySnapshot docs;
  ItemsStack(this.docs);

  @override
  Widget build(BuildContext context) {
    List<Widget> _categoryViews = [];

    for (QueryDocumentSnapshot doc in docs.docs) {
      _categoryViews.add(_CategoryViews(doc));
    }

    return Stack(
      children: [
        TabBarView(
          children: _categoryViews,
        ),
      ],
    );
  }
}

class _CategoryViews extends StatelessWidget {
  final QueryDocumentSnapshot category;
  _CategoryViews(this.category);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: category.reference.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          List<Widget> items = [];

          for (QueryDocumentSnapshot item in snapshot.data.docs) {
            items.add(_Item(item));
          }

          return ListView(
            children: [
              Container(
                color: Color(0xfff0f0f0),
                child: GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.all(15),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  crossAxisCount: 2,
                  childAspectRatio: 0.82,
                  children: items,
                ),
              ),
              Container(
                color: Color(0xfff0f0f0),
                height: 100,
              ),
            ],
          );
        });
  }
}

class _Item extends StatelessWidget {
  final DocumentSnapshot item;
  _Item(this.item);

  @override
  Widget build(BuildContext context) {
    final data = item.data();

    String dataPoint = '-';
    if (data['point'] != null) {
      dataPoint = data['point'].toString();
    } else if (data['price'] != null) {
      dataPoint = (data['price'] * 0.08).round().toString();
    }

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Item(item, false);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffc4c4c4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: RandomImage(),
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  padding: EdgeInsets.all(11),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        child: Text.rich(
                          TextSpan(
                            text: (data['title'] ?? '-').toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '¥',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: (data['price'] ?? '-').toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'ポイント：',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff666666),
                              ),
                            ),
                            TextSpan(
                              text: dataPoint + 'P',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
