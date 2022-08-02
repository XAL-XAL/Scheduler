import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:scheduler/colors.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final emailTextEditController = TextEditingController();
  final firstNameTextEditController = TextEditingController();
  final lastNameTextEditController = TextEditingController();
  final passwordTextEditController = TextEditingController();
  final confirmPasswordTextEditController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message!;
    });
  }

  late int selectedRadioTile = 0;

  @override
  Widget build(BuildContext context) {

    setSelectedType(int val) {
      setState(() {
        selectedRadioTile = val;
      });
    }

    const registerTitle = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Register",
        style: TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );

    final errorMessage = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _errorMessage,
        style: const TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );

    final emailField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty || !value.contains('@')) {
            return 'Please enter a valid email.';
          }
          return null;
        },
        controller: emailTextEditController,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_firstNameFocus);
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
          hintText: 'Email',
          hintStyle: const TextStyle(
              color: Colors.white
          ),
          contentPadding:
          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final passwordField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.length < 8) {
            return 'Password must be longer than 8 characters.';
          }
          return null;
        },
        autofocus: false,
        obscureText: true,
        controller: passwordTextEditController,
        textInputAction: TextInputAction.next,
        focusNode: _passwordFocus,
        onFieldSubmitted: (term) {
          FocusScope.of(context)
              .requestFocus(_confirmPasswordFocus);
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
          contentPadding:
          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final passwordConfirm = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        controller: confirmPasswordTextEditController,
        focusNode: _confirmPasswordFocus,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (passwordTextEditController.text.length > 8 &&
              passwordTextEditController.text != value) {
            return 'Passwords do not match.';
          }
          return null;
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
          hintText: 'Confirm Password',
          hintStyle: const TextStyle(
              color: Colors.white
          ),
          contentPadding:
          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final firstName = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your first name.';
          }
          return null;
        },
        controller: firstNameTextEditController,
        keyboardType: TextInputType.text,
        autofocus: false,
        textInputAction: TextInputAction.next,
        focusNode: _firstNameFocus,
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_lastNameFocus);
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
          hintText: 'First Name',
          hintStyle: const TextStyle(
              color: Colors.white
          ),
          contentPadding:
          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final lastName = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your last name.';
          }
          return null;
        },
        controller: lastNameTextEditController,
        keyboardType: TextInputType.text,
        autofocus: false,
        textInputAction: TextInputAction.next,
        focusNode: _lastNameFocus,
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_passwordFocus);
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
          hintText: 'Last Name',
          hintStyle: const TextStyle(
              color: Colors.white
          ),
          contentPadding:
          const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final managerButton = ListTile(
      title: const Text('Manager', style: TextStyle(color: Colors.white)),
      leading: Radio(
        value: 1,
        groupValue: selectedRadioTile,
        activeColor: lightTeal,
        onChanged: (val) {
          setSelectedType(1);
        },
      )
    );
    final employeeButton = ListTile(
        title: const Text('Employee', style: TextStyle(color: Colors.white)),
        leading: Radio(
          value: 2,
          groupValue: selectedRadioTile,
          activeColor: lightTeal,
          onChanged: (val) {
            setSelectedType(2);
          },
        )
    );

    final radioSelection = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: managerButton),
        Expanded(child: employeeButton),
      ],
    );

    final signupButton = Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _firebaseAuth
                .createUserWithEmailAndPassword(
                email: emailTextEditController.text,
                password: passwordTextEditController.text)
                .then((onValue) {
              /*Firestore.instance
                                .collection('users')
                                .document(onValue.uid)
                                .setData({
                              'firstName': firstNameTextEditController.text,
                              'lastName': lastNameTextEditController.text,
                            }).then((userInfoValue) {
                              Navigator.of(context).pushNamed(HomePage.tag);
                            });*/
            }).catchError((onError) {
              processError(onError);
            });
          }
        },
        padding: const EdgeInsets.all(12),
        color: Colors.blueGrey,
        child: Text('Sign Up'.toUpperCase(),
            style: const TextStyle(color: Colors.white)),
      ),
    );

    final cancelButton = Padding(
        padding: EdgeInsets.zero,
        child: FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: lightTeal),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
    );

    return Scaffold(
      backgroundColor: darkBackground,
      body: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 36.0, left: 24.0, right: 24.0),
                children: <Widget>[
                  registerTitle,
                  errorMessage,
                  firstName,
                  lastName,
                  emailField,
                  passwordField,
                  passwordConfirm,
                  radioSelection,
                  signupButton,
                  cancelButton,
                ],
              )
          )
      ),
    );
  }
}