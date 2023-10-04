import 'dart:io';

import 'package:flutter/material.dart';
import 'package:week4/addstudent.dart';
import 'package:week4/database/databaseqlite.dart';
import 'package:week4/updatestudentdata.dart';

// ignore: camel_case_types
class liststudent extends StatefulWidget {
  const liststudent({super.key});

  @override
  State<liststudent> createState() => _liststudentState();
}

// ignore: non_constant_identifier_names
final SearchController = TextEditingController();
late List<Map<String, dynamic>> listofStudentDetails = [];

// ignore: camel_case_types
class _liststudentState extends State<liststudent> {
  Future<void> fetchStudentData() async {
    List<Map<String, dynamic>> studentdetails = await getAllstudentDetails();

    if (SearchController.text.isNotEmpty) {
      studentdetails = studentdetails
          .where((s) => s['name']
              .toString()
              .toLowerCase()
              .contains(SearchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      listofStudentDetails = studentdetails;
    });
  }

  @override
  void initState() {
    fetchStudentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STUDENT LIST'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: SearchController,
              onChanged: (value) {
                setState(() {
                  fetchStudentData();
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                  hintText: '    Type name of student',
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: listofStudentDetails.length,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                final studentmap = listofStudentDetails[index];
                return ListTile(
                  title: Text(studentmap['name']),
                  subtitle: Text(studentmap['id'].toString()),
                  leading: CircleAvatar(
                      backgroundImage: FileImage(File(studentmap['imageurl']))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Delete the student information'),
                                    content: const Text(
                                        'are you sure you want to delete ?'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('cancel'),
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await deletestudentDetailsFromDB(
                                                studentmap['id']);
                                            fetchStudentData();
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            snackbarFunction(
                                                context,
                                                "succesfully deletd the student Details",
                                                Color.fromARGB(255, 2, 172, 7));
                                          },
                                          child: const Text('OK'))
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                     updateStudentDetails(
                                      id: studentmap['id'],
                                      studentname: studentmap['name'],
                                      rollnumber: studentmap['roll'],
                                      phonenumber:studentmap['num'],
                                      department: studentmap['department'],
                                      imagesrc:studentmap['imageurl'],
                                      ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
