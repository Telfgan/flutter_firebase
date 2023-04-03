import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class Regis extends StatefulWidget{
  const Regis({Key? key}) : super(key: key);

  @override
  State<Regis> createState() => MyApp();
}

class MyApp extends State<Regis> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Регистрация',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 174, 0, 255),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage_(),
    );
  }
}

class MyHomePage_ extends StatefulWidget {
  @override
  _MyHomePage2State createState() => _MyHomePage2State();
}

//Создаем свойство, закрепляющее ключи за конкретными переменными
class _MyHomePage2State extends State<MyHomePage_> {
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username2 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController email2 = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    String? validateEmail(String? value) {
      const pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
      final regex = RegExp(pattern);

      return value!.isNotEmpty && !regex.hasMatch(value)
          ? 'Введите правильную почту'
          : null;
    }

    void signUpWithEmailAndPassword() async {
      try {
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: username2.text,
            password: password2.text);
        const snackBar = SnackBar(
          content: Text('Регистрация проведена успешно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Text('Данные введены неверно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    void signInWithEmailAndPassword() async {
      try {
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: username.text,
            password: password.text);
        print(user.user?.email);
        print(user.user?.uid);
        const snackBar = SnackBar(
          content: Text('Авторизация проведена успешно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Text('Данные введены неверно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    void signInWithAnonymously() async {
      try {
        final user = await FirebaseAuth.instance.signInAnonymously();
        print(user.user?.uid);
        const snackBar = SnackBar(
          content: Text('Авторизация инкогнито проведена успешно!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        print(e);
        const snackBar = SnackBar(
          content: Text('Ошибка'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    void SentEmailLink() async {
      try {
        var emailAuth = username.text;
        var acs = ActionCodeSettings(
            url: 'http://localhost:9999/#/?email=$emailAuth',
            handleCodeInApp: true,
            androidInstallApp: true);
        var response = await FirebaseAuth.instance
            .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs);
        const snackBar = SnackBar(
          content: Text('Ссылка отправлена'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        print(e);
        const snackBar = SnackBar(
          content: Text('Ошибка'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

     return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 750,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 120),
            decoration:
                const BoxDecoration(color: Color.fromARGB(248, 170, 0, 255)),
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Регистрация",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 21, 255, 0),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: username2,
                      autovalidateMode: AutovalidateMode.always,
                      validator: validateEmail,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Введите email',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      obscureText: true,
                      controller: password2,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Введите пароль',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: ElevatedButton(
                        onPressed: () {
                          signUpWithEmailAndPassword();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color.fromARGB(255, 0, 255, 4)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            )),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Регистрация",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}