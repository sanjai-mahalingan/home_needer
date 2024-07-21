import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_needer/ui/initial_view.dart';
import 'package:home_needer/widgets/loader_view.dart';

class RegistrationView extends ConsumerStatefulWidget {
  const RegistrationView({super.key});

  @override
  ConsumerState<RegistrationView> createState() => _RegistrationView();
}

class _RegistrationView extends ConsumerState<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore storage_ref = FirebaseFirestore.instance;

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
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text, password: password.text);

        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null) {
            ref.read(userSession.notifier).state = user;

            var profileData = {
              "uid": user.uid,
              "imageURL": '',
              "displayName": '',
              "primaryPhone": '',
              "secondaryPhone": '',
              "addressLine1": '',
              "addressLine2": '',
              "city": '',
              "state": '',
              "zipCode": '',
              "country": '',
              "createdOn": DateTime.now()
            };

            storage_ref.collection('profiles').doc(user.uid).set(profileData);
            setState(() {
              isLoading = false;
            });
            Navigator.popAndPushNamed(context, 'indexView');
            return;
          }
        });
      } on FirebaseAuthException catch (e) {
        if (mounted && e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('The email address is badly formatted.'),
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  right: 20,
                  left: 20),
            ),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
        if (mounted && e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('Email already registered'),
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  right: 20,
                  left: 20),
            ),
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Something went wrong. Try later'),
          backgroundColor: Colors.red,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
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
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 156, 105, 16)),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          label: Text(
                            'Email',
                            style: TextStyle(color: Colors.white60),
                          ),
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
                        controller: password,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 156, 105, 16)),
                        decoration: const InputDecoration(
                          label: Text(
                            'Password',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.isNotEmpty && value.length <= 6) {
                            return "Password must contains minimum 7 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isLoading
                          ? const LoaderView(size: 34)
                          : ElevatedButton(
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
