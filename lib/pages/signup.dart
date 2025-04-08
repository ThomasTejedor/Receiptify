import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with WidgetsBindingObserver {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    Map userData = {};

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
                  color: Color.fromARGB(255, 240, 235, 216),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
          ),
          //Area for user input and Signup button
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
                        errorStyle: TextStyle(fontSize: 10.0), 
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
                  Container( 
                    padding: const EdgeInsets.all(12.0), 
                    color: Color(0x00000000),
                    child: TextFormField( 
                      obscureText: true,
                      validator: MultiValidator([ 
                        RequiredValidator( 
                          errorText: 'Please enter a Password'), 
                        MinLengthValidator(8, 
                          errorText: 
                            'Password must be atleast 8 digits'), 
                        PatternValidator(r'(?=.*?[#!@$%^&*-])', 
                          errorText: 
                            'Password must contain atleast one special character') 
                      ]).call, 
                      decoration: InputDecoration( 
                        hintText: 'Password', 
                        labelText: 'Password', 
                        prefixIcon: Icon( 
                          Icons.key, 
                        ), 
                        errorStyle: TextStyle(fontSize: 10.0), 
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
                            text: 'Already have an account?',
                            style: TextStyle(color: const Color.fromARGB(255, 62, 92, 118)),
                          ),
                          TextSpan(
                            text: '  Log in',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _formkey.currentState?.reset();
                                context.go('/login');
                              },
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