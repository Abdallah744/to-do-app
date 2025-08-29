// ignore_for_file: unnecessary_import, avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/archive_tasks/archive_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';
import 'AppState.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit() : super(InitAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  int currentIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  Database? database ;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];


  void changeBottomNavBar(int index){
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void createDatabase() {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate:(database, version){
        print('database created');
        database
            .execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        })
            .catchError((error){
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database){
        getTasksDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
       database = value;
      emit(CreateDatabaseState());
     });
  }

  Future insertToDatabase({
    required String? title,
    required String? date,
    required String? time,
  }) async{
    return await database!.transaction((txn) async{
      txn.rawInsert('INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
            emit(InsertToDatabaseState());
            getTasksDataFromDatabase(database);
            print('$value inserted successfully');
      })
          .catchError((error) {
        print('error when inserting new record ${error.toString()}');
      });
    });
  }

  void updateInDatabase({
    required String? status,
    required int? id,
}) {
    database?.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?', ['$status', '$id']).then((value) {
      getTasksDataFromDatabase(database);
      emit(UpdateInDatabaseState());
      print('Status Updated Successfully');
    });
  }

  void deleteFromDatabase({
    required String? status,
    required int? id,
  }) {
    database?.rawUpdate('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getTasksDataFromDatabase(database);
      emit(DeleteFromDatabaseState());
      print('Task Deleted Successfully');
    });
  }

  void getTasksDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoadingState());
    database!.rawQuery('SELECT * FROM Tasks')
        .then((value) {
      value.forEach((element) {
        if(element['status'] == 'new'){
          newTasks.add(element);
        }
        else if(element['status'] == 'done'){
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });
      emit(GetFromDatabaseState());
    });
  }


  void changeBottomSheetState(
      {
        required bool isShown,
        required IconData icon,
      }
      )
  {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(ChangeBottomSheetState());

  }

}