import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    Map userData = {};
    final _formkey = GlobalKey<FormState>();

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          //Logo or Logo Name
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Center(
              child: const Text(
                'Receiptify',
                style: TextStyle( 
                  color: const Color.fromARGB(255, 240, 235, 216),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
          ),
          //Area for user input and login button
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 50
            ),
            child: Form(
              key: _formkey,
              child: Column(
                
                children: [
                  //Create the email user text input
                  Padding( 
                    padding: const EdgeInsets.all(12.0), 
                    child: TextFormField( 
                      validator: MultiValidator([ 
                        RequiredValidator( 
                            errorText: 'Enter email address'), 
                        EmailValidator( 
                            errorText: 
                                'Please correct email field'), 
                      ]).call, 
                      decoration: InputDecoration( 
                        hintText: 'Email', 
                        labelText: 'Email', 
                        prefixIcon: Icon( 
                          Icons.email, 
                          //color: Colors.green, 
                        ), 
                        errorStyle: TextStyle(fontSize: 18.0), 
                        border: OutlineInputBorder( 
                          borderSide: 
                            BorderSide(color: Colors.red), 
                          borderRadius: BorderRadius.all( 
                            Radius.circular(9.0)
                          )   
                        )
                      )
                    )
                  ),
                  //Create the password user input field
                  Padding( 
                    padding: const EdgeInsets.all(12.0), 
                    child: TextFormField( 
                      validator: MultiValidator([ 
                        RequiredValidator( 
                          errorText: 'Please enter Password'), 
                        MinLengthValidator(8, 
                          errorText: 
                            'Password must be atlist 8 digit'), 
                        PatternValidator(r'(?=.*?[#!@$%^&*-])', 
                          errorText: 
                            'Password must be atlist one special character') 
                      ]).call, 
                      decoration: InputDecoration( 
                        hintText: 'Password', 
                        labelText: 'Password', 
                        prefixIcon: Icon( 
                          Icons.key, 
                        ), 
                        errorStyle: TextStyle(fontSize: 18.0), 
                        border: OutlineInputBorder( 
                          borderSide: BorderSide(color: Colors.red), 
                          borderRadius: 
                            BorderRadius.all(
                              Radius.circular(9.0)
                            )
                        ), 
                      ), 
                    ), 
                  ), 
                  //Create the Login Button
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 5),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom (
                          backgroundColor: const Color.fromARGB(255, 62, 92, 118),
                          foregroundColor: const Color.fromARGB(255, 13, 19, 33),
                          
                        ),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            print('form submitted');
                          }
                        },
                        child: const Text('Login')
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Dont have an account?',
                            style: new TextStyle(color: const Color.fromARGB(255, 62, 92, 118)),
                          ),
                          TextSpan(
                            text: '  Sign up',
                            style: new TextStyle(color: Colors.blue),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ]
      ),
    );

  }
  
}