import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:scheduler/colors.dart';

class RegisterWidget extends StatefulWidget {

  final String type;
  final TextEditingController textController;
  final FocusNode focusNode;
  final String password;

  const RegisterWidget({Key? key,
    required this.type,
    required this.textController,
    required this.focusNode,
    required this.password,
  }) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message!;
    });
  }


  @override
  Widget build(BuildContext context) {

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (widget.type == 'Company') {
            if (value!.isEmpty) {
              return 'Please enter a Company';
            }
          }
          else if (widget.type == 'First Name') {
            if (value!.isEmpty) {
              return 'Please enter your first name.';
            }
          }
          else if (widget.type == 'Last Name') {
            if (value!.isEmpty) {
              return 'Please enter your last name.';
            }
          }
          else if (widget.type == 'Email') {
            if (value!.isEmpty || !value.contains('@')) {
              return 'Please enter a valid email.';
            }
          }
          else if (widget.type == 'Password') {
            if (value!.length < 5) {
              return 'Password must be longer than 5 characters.';
            }
          }
          else if (widget.type == "Confirm Password") {
            if (value!.isEmpty || widget.password != value) {
              return 'Passwords do not match.';
            }
          }
          return null;
        },
        controller: widget.textController,
        keyboardType: widget.type == 'Email' ? TextInputType.emailAddress : TextInputType.text,
        autofocus: false,
        obscureText: widget.type == 'Password' || widget.type == 'Confirm Password' ? true : false,
        textInputAction: TextInputAction.next,
        focusNode: widget.focusNode,
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(widget.focusNode);
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
          hintText: widget.type,
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
  }
}