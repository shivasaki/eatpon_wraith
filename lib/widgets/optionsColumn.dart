import 'package:eatpon_wraith/import.dart';

class OptionsColumn extends StatelessWidget {
  final item;
  OptionsColumn([this.item, Key key]) : super(key: key);

  Widget build(BuildContext context) {
    ItemModel _item = Provider.of<ItemModel>(context);
    _item.setOptions(item['options']);
    List options = _item.options;

    if (options == null || options.length == 0) {
      return Column();
    }

    return ListView.builder(
      padding: EdgeInsets.all(4),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int i) {
        return _Option(options[i], i);
      },
      itemCount: options.length,
    );
  }
}

class _Option extends StatelessWidget {
  final option;
  final int optionIndex;
  _Option([this.option, this.optionIndex, Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItemModel _item = context.watch<ItemModel>();
    List options = _item.options;

    List<Widget> optionsGrid = [];
    String title;
    bool _visible = options[optionIndex]['visible'] ?? false;
    int selectedIndex = 0;

    if (option['defaultIndex'] != null) {
      selectedIndex = option['defaultIndex'];
      if (option['selectedIndex'] != null) {
        selectedIndex = option['selectedIndex'];
      } else {
        context.watch<ItemModel>().applyOption(
            {'selectedIndex': option['defaultIndex']}, optionIndex);
      }
    }

    option['choices'].asMap().forEach(
      (choiceIndex, value) {
        ButtonStyle _btnStyle;
        if (selectedIndex == choiceIndex) {
          title = value;
          _btnStyle =
              TextButton.styleFrom(side: BorderSide(color: Colors.black));
        }

        optionsGrid.add(
          TextButton(
            style: _btnStyle,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffc4c4c4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  height: 64,
                  width: 64,
                  child: RandomImage(),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  width: 102,
                  height: 64,
                  padding:
                      EdgeInsets.only(left: 8, top: 6, right: 8, bottom: 6),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              context
                  .read<ItemModel>()
                  .updateOption({'selectedIndex': choiceIndex}, optionIndex);
              context.read<ItemModel>().toggleVisible(optionIndex);
            },
          ),
        );
      },
    );

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                color: Color(0xffc4c4c4),
                child: RandomImage(),
              ),
              Expanded(
                child: Container(
                  height: 44,
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(title),
                ),
              ),
              Container(
                height: 44,
                width: 88,
                child: OutlinedButton(
                  child: Text('変更'),
                  onPressed: () => {
                    context.read<ItemModel>().toggleVisible(optionIndex),
                  },
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _visible,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 12),
                margin: EdgeInsets.only(right: 0),
                color: Color(0xfff0f0f0),
                child: Text(
                  'お選びください',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Color(0xfff0f0f0),
                child: GridView.count(
                  primary: false,
                  padding: EdgeInsets.all(10),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 166 / 64,
                  children: optionsGrid,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
