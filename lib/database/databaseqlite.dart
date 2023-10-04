
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:week4/addstudent.dart';
import 'package:week4/screen/studentmodel.dart';

late Database db;
Future<void> initializedatabase()async{
db= await openDatabase("student.db",version: 1,
onCreate: (db, version) async
{
  await db.execute('CREATE TABLE studenttable (id INTEGER PRIMARY KEY, name TEXT, roll INTEGER, department TEXT, num REAL, imageurl)');
},
);
}
Future<void> addStudentToDb(studentmodel value,BuildContext context)async{
  final existingRecord=await db.query('studenttable',where: 'id = ?',whereArgs: [value.id]);
  final existingnumber=await db.query('studenttable',where: 'num= ?',whereArgs: [value.phonenumber]);
  if(existingRecord.isEmpty){
if(existingnumber.isEmpty){
    await db.rawInsert('INSERT INTO studenttable(id,name, roll, department,num,imageurl) VALUES(?,?,?,?,?,?)',[
      value.id,
      value.studentname,
      value.rollnumber,
      value.department,
      value.phonenumber,
      value.imageurl,
    ]);
    

    // ignore: use_build_context_synchronously
    snackbarFunction(context,
                                "Submitted Successfully...", Colors.green);
  }else{
  // ignore: use_build_context_synchronously
  snackbarFunction(context,"Number is already exist!", Colors.redAccent);
  
  }
  }else{

    // ignore: use_build_context_synchronously
    snackbarFunction(context,"id is already exist!!", Colors.redAccent);
    
  }
  
  
} 
Future <List<Map<String,dynamic>>> getAllstudentDetails() async{
  final value =await db.rawQuery('SELECT * FROM studenttable');
  return value;
}
Future<void> deletestudentDetailsFromDB(int id)async{
  await db.rawDelete('DELETE FROM studenttable WHERE id = ?',[id]);
}
 Future<void>updateStudentDetailsFromDB(studentmodel value)async{
 final updateData= await db.update('studenttable',{
  'id':value.id,
  'name':value.studentname,
  'roll':value.rollnumber,
  'department':value.department,
  'num':value.phonenumber,
  'imageurl':value.imageurl},
  where: 'id=?',
  whereArgs: [value.id]);
 }
 
