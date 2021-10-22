import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In & Out'),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return TextButton(
              child: const Text('Sign out'),
              onPressed: () async {
                final User user = _auth.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ログインしていません'),
                    ),
                  );
                  return;
                }
                _signOut();
                final String uid = user.uid;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(uid + ' has successfully signed out.'),
                  ),
                );
              },
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _EmailPasswordForm(),
          ],
        );
      }),
    );
  }

  void _signOut() async {
    await _auth.signOut();
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: const Text(
                    'おかえりなさい',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'メールアドレス'),
                  validator: (String value) {
                    if (value.isEmpty) return '入力してください';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'パスワード'),
                  validator: (String value) {
                    if (value.isEmpty) return '入力してください';
                    return null;
                  },
                  obscureText: true,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: SignInButton(
                    Buttons.Email,
                    text: "つぎへ",
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _signInWithEmailAndPassword();
                        Navigator.pushNamed(context, '/');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${user.email} でログイン"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("無効な組み合わせ"),
        ),
      );
    }
  }
}
