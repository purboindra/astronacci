import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/register/bloc/register_bloc.dart';
import 'package:frontend/features/register/bloc/register_event.dart';
import 'package:frontend/features/register/bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Screen")),
      body: Form(
        key: _formKey,
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
            SizedBox(height: 8),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
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
            SizedBox(height: 8),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.isNotEmpty && value.length < 10) {
                  return 'Address must be at least 10 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            BlocConsumer<RegisterBloc, RegisterState>(
              builder:
                  (context, state) => ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        context.read<RegisterBloc>().add(
                          SubmitRegisterEvent(
                            email: emailController.text,
                            name: nameController.text,
                            address: addressController.text,
                            age: ageController.text,
                            password: passwordController.text,
                          ),
                        );
                      }
                    },
                    child:
                        state is RegisterLoading
                            ? CircularProgressIndicator()
                            : Text("Register"),
                  ),
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  Navigator.of(context).pushNamed("/main");
                } else if (state is RegisterError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/login"),
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
