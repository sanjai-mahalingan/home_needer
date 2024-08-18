import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_needer/models/business_model.dart';
import 'package:home_needer/models/country_state.dart';
import 'package:home_needer/ui/business/business_landing_view.dart';
import 'package:home_needer/ui/initial_view.dart';
import 'package:home_needer/widgets/go_to_home_view.dart';
import 'package:home_needer/widgets/loader_view.dart';

class CreateHouseEssentialsView extends ConsumerStatefulWidget {
  const CreateHouseEssentialsView({super.key, required this.businessID});

  final String businessID;

  @override
  ConsumerState<CreateHouseEssentialsView> createState() =>
      _HouseEssentialsView();
}

class _HouseEssentialsView extends ConsumerState<CreateHouseEssentialsView> {
  final _formKey = GlobalKey<FormState>();
  FilePickerResult? fileResult;
  bool isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storageRef = FirebaseStorage.instance;

  final RegExp nameRegExp = RegExp(r"^[a-zA-Z0-9-'_\s]*$");
  final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  String? existingImageFile;
  String? newImageFile;

  File? imageFile;
  String? networkImageFile;

// Form Variables
  String selectedBusinessType = 'Contractors';
  // String selectedCountry = 'India';
  String? selectedState = 'Tamil Nadu';
  TextEditingController businessName = TextEditingController();
  TextEditingController contactPhone = TextEditingController();
  TextEditingController contactEmail = TextEditingController();
  TextEditingController businessAddress = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController country = TextEditingController(text: "India");
  TextEditingController websiteURL = TextEditingController();
  TextEditingController mapURL = TextEditingController();
  TextEditingController instagramUserName = TextEditingController();
  TextEditingController facebookID = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController additionalInformation = TextEditingController();

  void _openFilePicker() async {
    fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      setState(() {
        final finalImage = File(fileResult!.files.single.path.toString());
        final bytes = finalImage.readAsBytesSync().lengthInBytes;
        final kb = bytes / 1024;
        if (kb > 150) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image file should be less than 150kb'),
              backgroundColor: Colors.red,
            ),
          );
          imageFile = null;
        } else {
          imageFile = File(fileResult!.files.single.path.toString());
        }
      });
    }
  }

  onBusinessFormSubmit() async {
    setState(() {
      isLoading = true;
    });
    final user = ref.watch(userSession);
    if (_formKey.currentState!.validate()) {
      String? imageURL;
      if (imageFile != null) {
        newImageFile = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef_ =
            storageRef.ref().child('houseEssentials/$newImageFile.jpg');
        UploadTask uploadTask = storageRef_.putFile(imageFile!);
        imageURL = await (await uploadTask).ref.getDownloadURL();
      } else {
        imageURL = null;
      }
      var data = {
        "uid": user!.uid,
        "category": "House Essential",
        "businessType": selectedBusinessType,
        "imagePath": (imageURL != null)
            ? imageURL
            : networkImageFile != ''
                ? networkImageFile
                : null,
        "imageName":
            newImageFile != null ? '$newImageFile.jpg' : existingImageFile,
        "businessName": businessName.text,
        "contactPhone": contactPhone.text,
        "contactEmail": contactEmail.text,
        "businessAddress": businessAddress.text,
        "landmark": landmark.text,
        "city": city.text,
        "state": selectedState,
        "zipCode": zipCode.text,
        "country": country.text,
        "websiteURL": websiteURL.text,
        "mapURL": mapURL.text,
        "instagramUserName": instagramUserName.text,
        "facebookID": facebookID.text,
        "additionalInformation": additionalInformation.text,
        "visibility": true
      };

      if (widget.businessID.isEmpty) {
        await firestore
            .collection('houseEssentials')
            .add(data)
            .then((DocumentReference value) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Your business added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  setState(() {
                    isLoading = false;
                  }),
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BusinessLandingView(),
                    ),
                  ),
                });
      } else {
        if (newImageFile != null && existingImageFile != null) {
          await deleteExistingImage(existingImageFile);
        }
        await firestore
            .collection('houseEssentials')
            .doc(widget.businessID)
            .update(data)
            .then(
              (value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Your business updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                ),
                setState(() {
                  isLoading = false;
                }),
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BusinessLandingView(),
                  ),
                ),
                // Navigator.pushNamed(context, "profileView"),
              },
              onError: (e) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Something went wrong. Kindly try later"),
                    backgroundColor: Colors.red,
                  ),
                ),
                setState(() {
                  isLoading = false;
                }),
              },
            );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  deleteExistingImage(String? imageName) async {
    await storageRef.ref().child('constructions/$imageName').delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 93, 102),
        title: Text(
          'HOUSE ESSENTIALS',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Colors.white70),
        ),
        centerTitle: true,
        actions: [GoToHomeView()],
        foregroundColor: Colors.amber,
      ),
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              color: Colors.black54,
              child: const LoaderView(size: 64),
            )
          : SingleChildScrollView(
              child: Container(
                // alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        // Contact Information
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.cyan.shade800,
                                  Colors.cyan.shade200
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Business Contact Information",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // Business Image
                        Card(
                          color: Colors.amber[200],
                          shadowColor: Colors.amber[900],
                          child: imageFile != null
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Image.file(
                                          imageFile!,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                      IconButton(
                                        splashRadius: 10.0,
                                        splashColor: Colors.amber,
                                        onPressed: () {
                                          setState(() {
                                            imageFile = null;
                                          });
                                        },
                                        icon: const Icon(Icons.clear),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      TextButton.icon(
                                        onPressed: _openFilePicker,
                                        icon: const Icon(Icons.file_upload),
                                        label: const Text(
                                            'Upload Business Image/Logo'),
                                      ),
                                      const Text(
                                          '(Image file should be less than 150kb)'),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Business Type
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Business Type:'),
                            DropdownButton(
                              isExpanded: true,
                              value: selectedBusinessType,
                              items: houseEssentials.map((value) {
                                return DropdownMenuItem(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBusinessType = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Business Name
                        TextFormField(
                          controller: businessName,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            label: Text('Business Name to Display'),
                            hintText: 'The official name of your business',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter business name';
                            }
                            if (value.isNotEmpty &&
                                !nameRegExp.hasMatch(value)) {
                              return 'Special characters are not allowed';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Contact Information
                        TextFormField(
                          controller: contactPhone,
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            label: Text('Contact Number'),
                            prefix: Text("+91"),
                            icon: Icon(Icons.phone_android),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Provide Contact Number";
                            }
                            if (value.isNotEmpty && value.length < 10) {
                              return "Enter valid contact number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Email Address
                        TextFormField(
                          controller: contactEmail,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            label: Text('Email'),
                            icon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value != null && !emailRegExp.hasMatch(value)) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                        // Address
                        TextFormField(
                          controller: businessAddress,
                          textInputAction: TextInputAction.next,
                          maxLines: 2,
                          keyboardType: TextInputType.streetAddress,
                          decoration: const InputDecoration(
                            label: Text('Business Address'),
                            icon: Icon(Icons.contacts),
                          ),
                        ),
                        TextFormField(
                          controller: landmark,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text("Landmark"),
                            icon: Icon(Icons.accessibility),
                          ),
                        ),
                        TextFormField(
                          controller: city,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text('City'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter city name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // state selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('State Name'),
                            DropdownButton(
                                isExpanded: true,
                                value: selectedState,
                                items: indiaStateList.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedState = value;
                                  });
                                }),
                          ],
                        ),
                        // ZipCode
                        TextFormField(
                          controller: zipCode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('ZipCode'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter ZipCode";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            TextFormField(
                              controller: country,
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text('Country Name'),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // Social Media Details
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.cyan.shade800,
                                  Colors.cyan.shade200
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Social Media Details",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          controller: websiteURL,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                            label: Text('Business Website url(if any)'),
                            icon: Icon(Icons.web),
                          ),
                        ),
                        TextFormField(
                          controller: mapURL,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.url,
                          decoration: const InputDecoration(
                              label: Text('Location Map Link'),
                              icon: Icon(Icons.pin_drop),
                              hintText:
                                  "Copy page the google map url of your location",
                              hintStyle: TextStyle(fontSize: 12)),
                        ),
                        TextFormField(
                          controller: instagramUserName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text('Instagram User Name'),
                            icon: Icon(Icons.face),
                          ),
                        ),
                        TextFormField(
                          controller: facebookID,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text('Facebook ID'),
                            icon: Icon(Icons.facebook_rounded),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Additional Information
                        TextFormField(
                          controller: additionalInformation,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                            hintText:
                                'Any additional services offered by your business.',
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            onBusinessFormSubmit();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              foregroundColor: Colors.white),
                          child: Text(
                            widget.businessID.isEmpty ? "SUBMIT" : "UPDATE",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
