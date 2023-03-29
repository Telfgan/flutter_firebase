import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utilits/auth_type.dart';
import 'package:flutter_firebase/utilits/exception_codes.dart';

import 'dynamic_input_widget.dart';
import 'firebase_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authorization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firebase auth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;


  late FocusNode emailFocusNode;
  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;


  bool obscureText = true;
  bool registerAuthMode = false;
  bool _isAnonymous = false;

  AuthType? currentAuthType;

  @override
  void initState() {
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    emailFocusNode = FocusNode();
    usernameFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  void login() async {
    String message;

    UserCredential userCredential;

    try {
      switch (currentAuthType) {
        case AuthType.Anonymously:
          {
            userCredential = await FirebaseAuth.instance.signInAnonymously();
            message = "Успешная авторизация инкогнито";
          }
          break;
        case AuthType.EmailAndPassword:
          {
            userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text);
            message = userCredential != null
                ? "Email: ${userCredential.user!.email}, ${userCredential.user!.displayName}"
                : "Sorry, something went wrong";
          }
          break;

        case AuthType.EmailSignLink:
          {
            var emailAuth = emailController.text;
            message = "Non-null";
            final actionCodeSettings = ActionCodeSettings(
                // URL you want to redirect back to. The domain (www.example.com) for this
                // URL must be whitelisted in the Firebase Console.
                url:
                    'https://flutterfirebasesample.page.link/iGuj?email=$emailAuth',
                // This must be true
                handleCodeInApp: true,
                iOSBundleId: 'com.example.flutter_firebase',
                androidPackageName: 'com.example.flutter_firebase',
                // installIfNotAvailable
                androidInstallApp: true,
                // minimumVersion
                androidMinimumVersion: '12');

            FirebaseAuth.instance
                .sendSignInLinkToEmail(
                    email: emailAuth, actionCodeSettings: actionCodeSettings)
                .catchError((onError) => message = "Что-то пошло не так..")
                .then((value) => message = "Письмо отправлено на почту.");

                
          }
          break;

        default:
          {
            userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text);
            message = userCredential != null
                ? "Email: ${userCredential.user!.email}, ${userCredential.user!.displayName}"
                : "Sorry, something went wrong";
          }
      }
    } on FirebaseException catch (e) {
      message = getExceptionCode(e.code).exceptionMessage;
    }

    AlertDialog alert = AlertDialog(
      title: const Text('Information: '),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// Create a function that'll toggle the password's visibility on the relevant icon tap.
  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    // Почта
                    DynamicInputWidget(
                      controller: emailController,
                      obscureText: false,
                      focusNode: emailFocusNode,
                      toggleObscureText: null,
                      prefIcon: const Icon(Icons.mail),
                      labelText: "Введите почту",
                      textInputAction: TextInputAction.next,
                      isNonPasswordField: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Логин
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: registerAuthMode ? 65 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: registerAuthMode ? 1 : 0,
                        child: DynamicInputWidget(
                          controller: usernameController,
                          obscureText: false,
                          focusNode: usernameFocusNode,
                          toggleObscureText: null,
                          prefIcon: const Icon(Icons.person),
                          labelText: "Введите логин(по желанию)",
                          textInputAction: TextInputAction.next,
                          isNonPasswordField: true,
                        ),
                      ),
                    ),

                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: registerAuthMode ? 1 : 0,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),

                    DynamicInputWidget(
                      controller: passwordController,
                      labelText: "Введите пароль",
                      obscureText: obscureText,
                      focusNode: passwordFocusNode,
                      toggleObscureText: toggleObscureText,
                      prefIcon: const Icon(Icons.password),
                      textInputAction: registerAuthMode
                          ? TextInputAction.next
                          : TextInputAction.done,
                      isNonPasswordField: false,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: registerAuthMode ? 65 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: registerAuthMode ? 1 : 0,
                        child: DynamicInputWidget(
                          controller: confirmPasswordController,
                          focusNode: confirmPasswordFocusNode,
                          isNonPasswordField: false,
                          labelText: "Подтвердите пароль",
                          obscureText: obscureText,
                          prefIcon: const Icon(Icons.password),
                          textInputAction: TextInputAction.done,
                          toggleObscureText: toggleObscureText,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Отменить'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (!registerAuthMode) {
                              login();
                            }
                          },
                          child:
                              Text(registerAuthMode ? 'Зарегистрироваться' : 'Авторизоваться'),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(8.0),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(registerAuthMode
                            ? "Уже есть аккаунт?"
                            : "Еще не создали аккаунт?"),
                        TextButton(
                          onPressed: () {
                            setState(
                                () => registerAuthMode = !registerAuthMode);
                          },
                          child:
                              Text(registerAuthMode ? "Авторизоваться" : "Зарегистрироваться"),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: AuthType.values.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(AuthType.values[index].name),
                          leading: Radio<AuthType>(
                            value: AuthType.values[index],
                            groupValue: currentAuthType,
                            onChanged: (AuthType? value) {
                              setState(() {
                                currentAuthType = value;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ]),
                ))));
  }
}