import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationView extends ConsumerStatefulWidget {
  const RegistrationView({super.key});

  @override
  ConsumerState<RegistrationView> createState() => _RegistrationView();
}

class _RegistrationView extends ConsumerState<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  onRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black87, Colors.black, Colors.black],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Join with,',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: const Color.fromARGB(255, 173, 171, 171)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Image(
                image: AssetImage('assets/home_needer.jpg'),
                height: 110,
                width: 120,
                opacity: AlwaysStoppedAnimation(.8),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Home Needer',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: const Color.fromARGB(255, 173, 171, 171)),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Email'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          if (value.isNotEmpty && !emailValid.hasMatch(value)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text('Password'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.isNotEmpty && value.length <= 6) {
                            return "Password must contains minimum 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onRegistration();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white12,
                            foregroundColor: Colors.blueGrey),
                        child: const Text('Register Now'),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'loginView');
                            },
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
