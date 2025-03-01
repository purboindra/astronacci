import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/login/bloc/login_bloc.dart';
import 'package:frontend/features/login/bloc/login_event.dart';
import 'package:frontend/features/login/bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  if (value.isNotEmpty &&
                      (!value.contains('@') || !value.contains('.'))) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  return null;
                },
              ),
              SizedBox(height: 15),
              BlocConsumer<LoginBloc, LoginState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text;
                        final password = passwordController.text;
                        log("email: $email, password: $password");
                        context.read<LoginBloc>().add(
                          SubmitLoginEvent(email: email, password: password),
                        );
                      }
                    },
                    child:
                        state is LoginLoading
                            ? CircularProgressIndicator()
                            : Text("Login"),
                  );
                },
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    Navigator.of(context).pushNamed("/main");
                  } else if (state is LoginError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, "/register"),
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
