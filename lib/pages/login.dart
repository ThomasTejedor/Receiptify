import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          Padding(
            padding: const EdgeInsets.only(top: 10),
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
          Column (
            children: [
              Padding(
                padding: const EdgeInsets.only(
                top: 100,
                left: 50,
                right: 50),
                
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: TextButton.styleFrom (
                      backgroundColor: const Color.fromARGB(255, 62, 92, 118),
                      foregroundColor: const Color.fromARGB(255, 13, 19, 33),
                      
                    ),
                    onPressed: () async {},
                    child: const Text('Login')
                  ),
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}