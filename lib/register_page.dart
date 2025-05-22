import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(local.register)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: local.email),
                validator: (value) => value!.isEmpty ? local.enterEmail : null,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: local.password),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) return local.enterPassword;
                  if (value.length < 6) return local.passwordTooShort;
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: local.confirmPassword),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return local.passwordsDontMatch;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          try {
                            await auth.registerWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                            if (auth.currentUser != null) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (route) => false);
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _errorMessage = e.message ?? local.registrationFailed;
                            });
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                      child: Text(local.register),
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text(local.alreadyHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}