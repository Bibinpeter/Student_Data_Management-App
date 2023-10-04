import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:week4/database/databaseqlite.dart';
import 'package:week4/liststudent.dart';
import 'package:week4/screen/studentmodel.dart';

// ignore: camel_case_types
class screen1 extends StatefulWidget {
  const screen1({super.key});

  @override
  State<screen1> createState() => _screen1State();
}

// ignore: camel_case_types
class _screen1State extends State<screen1> {
  final formkey = GlobalKey<FormState>();

  final studentnameeditingcontroller = TextEditingController();

  final rollnumbereditingcontroller = TextEditingController();

  final departmenteditingcontroller = TextEditingController();

  final phonenumbereditingcontroller = TextEditingController();

  final studentideditingcontroller = TextEditingController();

  File? selectImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("STUDENT INFORMATION"),
        backgroundColor: const Color.fromARGB(255, 87, 66, 208),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const liststudent(),
                ));
              },
              icon: const Icon(Icons.person_search))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        selectImage == null ? null : FileImage(selectImage!),
                    radius: 60,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () async {
                              File? imgFrmFn =
                                  await ImagePickFromGallery(context);
                              setState(() {
                                selectImage = imgFrmFn;
                              });
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(Icons.camera_alt),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Txtfrmfild(
                    label: "studennt ID",
                    icon: Icons.perm_identity,
                    controller: studentideditingcontroller,
                    keybrd: TextInputType.number,
                    validatorr: (value) {
                      if (value!.isEmpty) {
                        return "Enter your ID";
                      } else if (value.length < 2) {
                        return "enter atleast 3 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Txtfrmfild(
                    label: "Student Name",
                    icon: Icons.person,
                    controller: studentnameeditingcontroller,
                    validatorr: (value) {
                      if (value!.isEmpty) {
                        return "Enter the name";
                      } else if (value.length < 3) {
                        return "enter atleast 3 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Txtfrmfild(
                    label: "Roll Number",
                    icon: Icons.numbers,
                    keybrd: TextInputType.number,
                    controller: rollnumbereditingcontroller,
                    validatorr: (value) {
                      if (value!.isEmpty) {
                        return "enter the roll number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Txtfrmfild(
                    label: "Department",
                    icon: Icons.school,
                    controller: departmenteditingcontroller,
                    validatorr: (value) {
                      if (value!.isEmpty) {
                        return "enter the department";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Txtfrmfild(
                    keybrd: TextInputType.number,
                    label: "Phone  Number",
                    icon: Icons.phone,
                    controller: phonenumbereditingcontroller,
                    validatorr: (value) {
                      if (value!.isEmpty) {
                        return " enter the phone number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          if (selectImage == null) {
                            snackbarFunction(context, "Please Select a image",
                                Colors.redAccent);
                          } else {
                            final recievedStudent = studentmodel(
                                id: int.parse(studentideditingcontroller.text),
                                studentname: studentnameeditingcontroller.text,
                                rollnumber:
                                    int.parse(rollnumbereditingcontroller.text),
                                department: departmenteditingcontroller.text,
                                imageurl: selectImage!.path,
                                phonenumber: phonenumbereditingcontroller.text);
                            await addStudentToDb(recievedStudent, context);
                          }
                        }
                      },
                      child: const Text("save"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Txtfrmfild extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validatorr;
  final TextInputType? keybrd;
  const Txtfrmfild(
      {super.key,
      required this.label,
      required this.icon,
      required this.controller,
      this.validatorr,
      this.keybrd});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keybrd,
      controller: controller,
      validator: validatorr,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder()),
    );
  }
}

// ignore: non_constant_identifier_names
Future<File?> ImagePickFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    snackbarFunction(context, e.toString(), Colors.red);
  }
  return image;
}

void snackbarFunction(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
  ));
}
