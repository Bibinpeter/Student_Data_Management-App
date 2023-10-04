import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week4/addstudent.dart';
import 'package:week4/database/databaseqlite.dart';
import 'package:week4/liststudent.dart';
import 'package:week4/screen/studentmodel.dart';

class updateStudentDetails extends StatefulWidget {
  const updateStudentDetails(
      {super.key,
     required this.id,
      required this.studentname,
      required this.rollnumber,
      required this.department,
      required this.imagesrc,
     required this.phonenumber});
  final int id;
  final String studentname;
  final int rollnumber;
  final String department;
  final String imagesrc;
  final double phonenumber;

  @override
  State<updateStudentDetails> createState() => _updateStudentDetailsState();
}

class _updateStudentDetailsState extends State<updateStudentDetails> {
  final formkey = GlobalKey<FormState>();

  late final studentnameeditingcontroller;

late  final rollnumbereditingcontroller;

 late final departmenteditingcontroller ;

 late final phonenumbereditingcontroller;

 late final studentideditingcontroller;
@override
  void initState() {
  
    studentideditingcontroller=TextEditingController(text: widget.id.toString());
    studentnameeditingcontroller=TextEditingController(text: widget.studentname);
    rollnumbereditingcontroller=TextEditingController(text:widget.rollnumber.toString());

    departmenteditingcontroller=TextEditingController(text: widget.department);
    phonenumbereditingcontroller=TextEditingController(text: widget.phonenumber.toInt().toString());

    super.initState();
  }
  File? selectImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(" Update STUDENT INFORMATION"),
        backgroundColor: const Color.fromARGB(255, 87, 66, 208),
         
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
                        selectImage == null ? FileImage(File(widget.imagesrc) ): FileImage(selectImage!),
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
                          
                            final recievedStudent = studentmodel(
                              imageurl:selectImage==null?widget.imagesrc:selectImage!.path,
                                id: int.parse(studentideditingcontroller.text),
                                studentname: studentnameeditingcontroller.text,
                                rollnumber: int.parse(rollnumbereditingcontroller.text),
                                department: departmenteditingcontroller.text,
                                phonenumber: phonenumbereditingcontroller.text);
                            await updateStudentDetailsFromDB(recievedStudent);  
                            snackbarFunction(
                                                context,
                                                "succesfully Updated...",
                                                Colors.green);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>liststudent(),));
                          
                        }
                      },
                      child: const Text("Update"),
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
