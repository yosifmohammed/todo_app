import 'package:Bottom_Navigation_Bar_Udemy/cubit/states.dart';
import 'package:Bottom_Navigation_Bar_Udemy/screens/ArchivedScreen.dart';
import 'package:Bottom_Navigation_Bar_Udemy/screens/DoneScreen.dart';
import 'package:Bottom_Navigation_Bar_Udemy/screens/TasksScreen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  AppCubit get(context) => BlocProvider.of(context);
  int indexPage = 0;
  List<Widget> screens = [
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetOpened = false;
  IconData addIcon = Icons.edit_outlined;
  Color addColor = Colors.blueGrey;

  void changeIndex(int index) {
    indexPage = index;
    emit(AppChangeBottomNavBarState());
  }

  // 1. create database
  // 2. create tables
  // 3. open database
  // 4. insert database
  // 5. get from database
  // 6. update in database
  // 7. delete from database

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database is created');
        // id Integer
        // title String
        // date String
        // time String
        // status String
        await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
      },
      onOpen: (database) {
        getFromDatabase(database);
        print('database is opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }
  Future insertToDatabase(
      {@required String title,
      @required String date,
      @required String time}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        emit(AppInsertDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('inserted not successfully ${error.toString()}');
      });
      return null;
    });
  }

  void getFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element){
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else if(element['status'] == 'archive')
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
    @required Color color,
  }) {
    isBottomSheetOpened = isShow;
    addIcon = icon;
    addColor = color;
    emit(AppChangeBottomSheetState());
  }

  void updateData({
      @required String status,
      @required int id,
    }) async{
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
    ).then((value){
      getFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
      @required int id,
    }) async{
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id],
    ).then((value){
      getFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
