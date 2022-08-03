import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scheduler/colors.dart';
import 'view/register_page.dart';
import 'view/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => const LoginPage(),
    RegisterPage.tag: (context) => RegisterPage(),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
              selectionHandleColor: Colors.transparent,
            ),
            primaryColor: Colors.white,
          ),
          home: MaterialApp(
            title: 'Login',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: darkTeal,
                selectionHandleColor: Colors.transparent,
              ),
              primaryColor: Colors.white,
              fontFamily: 'Nunito',
            ),
            home: LoginPage(),
            routes: routes,
          )),
    );
  }
}
