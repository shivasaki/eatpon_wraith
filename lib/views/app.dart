import 'package:eatpon_wraith/import.dart';
import 'package:firebase_auth/firebase_auth.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => HistoryCartModel()),
      ],
      child: FutureBuilder(
        future: FirebaseAuth.instance.signInAnonymously(),
        builder: (context, AsyncSnapshot<UserCredential> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          return _App();
        },
      ),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatpon',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        var paths = settings.name.split('?');
        var path = paths[0];
        var queryParameters = Uri.splitQueryString(paths[1]);
        if (path == ScreenArguments.routeName) {
          context.read<CartModel>().setTableId(queryParameters['table_id']);
          return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) {
              return Items();
            },
          );
        }
      },
      routes: {
        '/': (context) => Items(),
        '/login': (context) => SignInPage(),
        '/confirm': (context) => ConfirmOrder(),
        '/no_id': (context) => Text('QRコードを読み取ってください'),
        '/history': (context) => History(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.black,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
            side: BorderSide(width: 1),
          ),
        ),
      ),
    );
  }
}

class ScreenArguments {
  static const routeName = '/init';
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
