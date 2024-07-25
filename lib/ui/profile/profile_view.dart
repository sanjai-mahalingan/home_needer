import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_needer/models/country_state.dart';
import 'package:home_needer/ui/initial_view.dart';
import 'package:home_needer/widgets/go_to_home_view.dart';
import 'package:home_needer/widgets/loader_view.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key, required this.userId});

  final userId;

  @override
  ConsumerState<ProfileView> createState() => _ProfileView();
}

class _ProfileView extends ConsumerState<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  FirebaseFirestore fireStoreRef = FirebaseFirestore.instance;

  TextEditingController displayName = TextEditingController();
  TextEditingController primaryPhone = TextEditingController();
  TextEditingController secondaryPhone = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  String? country = "India";
  String? selectedState;

  onProfileUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final profileData = {
          "displayName": displayName.text,
          "primaryPhone": primaryPhone.text,
          "secondaryPhone": secondaryPhone.text,
          "addressLine1": addressLine1.text,
          "addressLine2": addressLine2.text,
          "city": city.text,
          "zipCode": zipCode.text,
          "country": "India",
          "state": selectedState
        };
        final currentUser = ref.watch(userSession);
        final docRef =
            fireStoreRef.collection("profiles").doc(currentUser!.uid);
        docRef.update(profileData).then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Updated Successfully'),
                  backgroundColor: Colors.green,
                ),
              ),
              setState(() {
                isLoading = false;
              }),
            });
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("User Id on Init Stateeeeee ${widget.userId}");
    setState(() {
      isLoading = true;
    });
    if (widget.userId != null && widget.userId != '') {
      initializeValue();
    }
    setState(() {
      isLoading = false;
    });
  }

  void initializeValue() async {
    await fireStoreRef
        .collection("profiles")
        .doc(widget.userId)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print('>>>>>>>>>> Profile Value: $data');
      setState(() {
        displayName.text = data["displayName"] ?? '';
        primaryPhone.text = data["primaryPhone"] ?? '';
        secondaryPhone.text = data["secondaryPhone"] ?? '';
        addressLine1.text = data["addressLine1"] ?? '';
        addressLine2.text = data["addressLine2"] ?? '';
        city.text = data["city"] ?? '';
        zipCode.text = data["zipCode"] ?? '';
        country = data["India"] ?? '';
        selectedState = data["state"] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 93, 102),
        title: Text(
          'My Profile',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.white70),
        ),
        centerTitle: true,
        actions: [GoToHomeView()],
        foregroundColor: Colors.amber,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 75, 93, 102),
              Color.fromARGB(255, 45, 57, 63),
              Color.fromARGB(255, 25, 32, 36)
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: LoaderView(
                  size: 34,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: displayName,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Name',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter name to display";
                                }
                                if (value.isNotEmpty && value.length <= 3) {
                                  return "Name should be minimum 4 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: primaryPhone,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                color: Colors.white,``
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Primary Phone Number',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter primary phone number";
                                }
                                if (value.isNotEmpty && value.length < 10) {
                                  return "Enter valid phone number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: secondaryPhone,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Secondary Phone Number',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isNotEmpty && value.length < 10) {
                                  return "Enter valid phone number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: addressLine1,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Address Line 1',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter address";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: addressLine2,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  'Address Line 2',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: city,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  'City',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your city name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'State',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.amber),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: selectedState ?? selectedState,
                                    items: indiaStateList.map((value) {
                                      return DropdownMenuItem(
                                          value: value, child: Text(value));
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedState = value!;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: zipCode,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                label: Text(
                                  'ZipCode',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Zip Code";
                                }
                                if (value.isNotEmpty && value.length < 6) {
                                  return "Enter valid zip code";
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
                                      onProfileUpdate();
                                    },
                                    child: const Text('Update'),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
