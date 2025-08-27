import 'package:todo/modules/archived_tasks/archived_tasks.dart';
import 'package:todo/modules/done_tasks/done_tasks.dart';
import 'package:todo/modules/new_tasks/new_tasks.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() async {
    database =
        await openDatabase(
          'tasks.db',
          version: 1,
          onCreate: (database, version) {
            print("Database created");
            database
                .execute(
                  'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, status TEXT, date TEXT, time TEXT)',
                )
                .then((value) {
                  print("Table created");
                })
                .catchError((error) {
                  print("Error creating table: $error");
                });
          },
          onOpen: (database) {
            getDataFromDatabase(database);
            print("Database opened");
          },
        ).then((value) {
          database = value;
          emit(AppCreateDatabaseState());
          return value;
        });
  }

  void insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
            'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
          )
          .then((value) {
            print("$value inserted successfully");
            emit(AppInsertDatabaseState());
            getDataFromDatabase(database);
          })
          .catchError((error) {
            print("Error inserting record: $error");
          });
    });
  }

  void getDataFromDatabase(database) {
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      newTasks = [];
      doneTasks = [];
      archivedTasks = [];

      value.forEach((task) {
        if (task['status'] == 'new') {
          newTasks.add(task);
        } else if (task['status'] == 'done') {
          doneTasks.add(task);
        } else if (task['status'] == 'archived') {
          archivedTasks.add(task);
        }
        print("Task: ${task['title']}, Status: ${task['status']}");
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateData({required String status, required int id}) async {
    database
        ?.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id])
        .then((value) {
          getDataFromDatabase(database);
          emit(AppUpdateDatabaseState());
        });
  }

  void deleteData({required int id}) async {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomNavBarState());
  }
}
