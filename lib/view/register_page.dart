import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:scheduler/colors.dart';
import 'package:scheduler/register_widgets.dart';

import 'bottom_menu_bar.dart';

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
            _firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditController.text, password: passwordTextEditController.text)
                .then((onValue) {
                  FirebaseFirestore.instance.collection('users').doc(onValue.user?.uid).set({
                      'firstName': firstNameTextEditController.text,
                      'lastName': lastNameTextEditController.text,
                      'email': emailTextEditController.text,
                      'type': selectedRadioTile == 1 ? 'Manager' : 'Employee',
                  }).then((userInfoValue) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomMenuBar()));
                  });
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
                  RegisterWidget(type: 'First Name', textController: firstNameTextEditController, focusNode: _firstNameFocus, password: ''),
                  RegisterWidget(type: 'Last Name', textController: lastNameTextEditController, focusNode: _lastNameFocus, password: ''),
                  RegisterWidget(type: 'Email', textController: emailTextEditController, focusNode: _emailFocus, password: ''),
                  RegisterWidget(type: 'Password', textController: passwordTextEditController, focusNode: _passwordFocus, password: ''),
                  RegisterWidget(type: 'Confirm Password', textController: confirmPasswordTextEditController, focusNode: _confirmPasswordFocus, password: passwordTextEditController.text),
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