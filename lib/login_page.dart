import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scheduler/colors.dart';
import 'package:scheduler/register_page.dart';
import 'package:scheduler/view/calendar_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String _errorMessage = '';

  void onChange() {
    setState(() {
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    emailController.addListener(onChange);
    passwordController.addListener(onChange);

    final logo = Hero(
      tag: 'Logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/logo/pink_logo.png')
      ),
    );

    const title = Text(
      "Scheduler",
      style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );

    final errorMessage = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _errorMessage,
        style: const TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );

    final email = TextFormField(
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email.';
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(
            color: Colors.white,
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              color: lightTeal,
            )
        ),
        hintText: 'Email',
        hintStyle: const TextStyle(
            color: Colors.white
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => node.nextFocus(),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(node);
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: const BorderSide(
              color: Colors.white,
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              color: lightTeal,
            )
        ),
        hintText: 'Password',
        hintStyle: const TextStyle(
            color: Colors.white
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CalendarPage())
          );
          /*if (_formKey.currentState.validate()) {
            signIn(emailController.text, passwordController.text)
                .then((uid) => {Navigator.of(context).pushNamed(HomePage.tag)})
                .catchError((error) => {processError(error)});
          }*/
        },
        padding: const EdgeInsets.all(12),
        color: darkTeal,
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: lightTeal),
      ),
      onPressed: () {},
    );

    final registerButton = Padding(
      padding: EdgeInsets.zero,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(RegisterPage.tag);
        },
        padding: const EdgeInsets.all(12),
        color: Colors.blueGrey,
        child: const Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
        backgroundColor: darkBackground,
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                const SizedBox(height: 24.0),
                title,
                const SizedBox(height: 12.0),
                errorMessage,
                const SizedBox(height: 12.0),
                email,
                const SizedBox(height: 12.0),
                password,
                const SizedBox(height: 24.0),
                loginButton,
                registerButton,
                forgotLabel
              ],
            ),
          ),
        ));
  }

  /*
  Future<String> signIn(final String email, final String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }*/

  void processError(final PlatformException error) {
    if (error.code == "ERROR_USER_NOT_FOUND") {
      setState(() {
        _errorMessage = "Unable to find user. Please register.";
      });
    } else if (error.code == "ERROR_WRONG_PASSWORD") {
      setState(() {
        _errorMessage = "Incorrect password.";
      });
    } else {
      setState(() {
        _errorMessage =
        "There was an error logging in. Please try again later.";
      });
    }
  }
}
