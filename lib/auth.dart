import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => MyApp();
}

class MyApp extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Авторизация',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 146, 1, 250),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Свойство, закрепляющее ключ за определенной переменной
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username2 = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController email2 = TextEditingController();
  bool isObscure = true;

//Валидация email инициализируется прямо из build
  @override
  Widget build(BuildContext context) {
    String? emailValidate(String? value) {
      const pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
      final regex = RegExp(pattern);

      return value!.isNotEmpty && !regex.hasMatch(value)
          ? 'Корректно введите почту'
          : null;
    }

    //Авторизация
    void signUpWithEmailAndPassword() async {
      try {
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: username2.text, password: password2.text);
        const snackBar = SnackBar(
          content: Text('Вы успешно зарегистрировались!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Text('При вводе данных произошла ошибка!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    //Регистрация
    void signInWithEmailAndPassword() async {
      try {
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: username.text, password: password.text);
        print(user.user?.email);
        print(user.user?.uid);
        const snackBar = SnackBar(
          content: Text('Вы успешно авторизовались!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Text('При вводе данных произошла ошибка!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    Future<UserCredential> signInWithGoogle() async {
      // Триггер аутентификации
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Описание запроса на авторизацию
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Создание полномочия
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      //После входа в систему, возвращаются учетные данные пользователя
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    //Авторизация инкогнито
    void signInWithAnonymously() async {
      try {
        final user = await FirebaseAuth.instance.signInAnonymously();
        print(user.user?.uid);
        const snackBar = SnackBar(
            content: Text('Авторизация инкогнито успешно произведена!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        print(e);
        const snackBar = SnackBar(content: Text('Произошла ошибка!'));
      }
    }

    //Метод, отправляющий письмо на мыло
    void SentEmailLink() async {
      try {
        var emailAuth = username.text;
        var acs = ActionCodeSettings(
            url: 'http://localhost:1234/#/?email=$emailAuth',
            handleCodeInApp: true,
            androidInstallApp: true);
        var response = await FirebaseAuth.instance
            .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs);
        const snackBar = SnackBar(
          content: Text('Ссылка отправлена!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on FirebaseAuthException catch (e) {
        print(e);
        const snackBar = SnackBar(
          content: Text('Произошла ошибка!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    //Верстка
    return Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
                height: 750,
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 120),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(248, 191, 0, 255)),
                    child: Container(
                        height: double.infinity,
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 0.5))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Авторизация",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 30, 255, 0),
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: username,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: emailValidate,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Введите почту',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: password,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Введите пароль',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      signInWithEmailAndPassword();
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 21, 255, 0)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("Авторизация",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      SentEmailLink();
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(255, 0, 255, 47)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("Авторизация по почте",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      signInWithAnonymously();
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(255, 0, 255, 8)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("Анонимная авторизация",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]))))));
  }
}
