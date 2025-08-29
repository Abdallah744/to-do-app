// ignore_for_file: unnecessary_import, use_key_in_widget_constructors, avoid_print
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/components/components.dart';
import '../shared/cubit/AppCubit.dart';
import '../shared/cubit/AppState.dart';

class HomeLayout extends StatelessWidget {
  List<String> labels = ['New', 'Done', 'Archive'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is InsertToDatabaseState) {
            Navigator.pop(context);
            AppCubit.get(context).titleController.clear();
            AppCubit.get(context).timeController.clear();
            AppCubit.get(context).dateController.clear();
          }
        },
        builder: (BuildContext context, AppState state) {
          AppCubit appCubit = AppCubit.get(context);
          return Scaffold(
            key: appCubit.scaffoldKey,
            appBar: AppBar(
              title: Text(
                appCubit.titles[appCubit.currentIndex],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications, size: 20),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.menu, size: 20)),
              ],
              backgroundColor: Colors.teal,
            ),
            body: ConditionalBuilder(
              condition: state is! AppLoadingState,
              builder: (context) => appCubit.screens[appCubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: defaultFloatingActionButton(
              changeBottomSheetState: () {
                if (appCubit.isBottomSheetShown) {
                  if (appCubit.formKey.currentState!.validate()) {
                    appCubit.insertToDatabase(
                      title: appCubit.titleController.text,
                      date: appCubit.dateController.text,
                      time: appCubit.timeController.text,
                    );
                  }
                } else {
                  appCubit.isBottomSheetShown = true;
                  appCubit.scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.white70,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Form(
                              key: appCubit.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextFormField(
                                    controller: appCubit.titleController,
                                    type: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    suffix: Icons.title,
                                  ),
                                  SizedBox(height: 10),
                                  defaultTextFormField(
                                    controller: appCubit.dateController,
                                    type: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    onTab: () {
                                      showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse(
                                              '2026-03-01',
                                            ),
                                          )
                                          .then((value) {
                                            if (value != null) {
                                              print(
                                                DateFormat.yMMMd().format(
                                                  value,
                                                ),
                                              );
                                              appCubit.dateController.text =
                                                  DateFormat.yMMMd().format(
                                                    value,
                                                  );
                                            }
                                          })
                                          .catchError((error) {
                                            print(
                                              'error when picking a date ${error.toString()}',
                                            );
                                          });
                                    },
                                    suffix: Icons.calendar_month_outlined,
                                  ),
                                  SizedBox(height: 10),
                                  defaultTextFormField(
                                    controller: appCubit.timeController,
                                    type: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    onTab: () {
                                      showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          )
                                          .then((value) {
                                            if (value != null) {
                                              appCubit.timeController.text =
                                                  value
                                                      .format(context)
                                                      .toString();
                                              print(value.format(context));
                                            }
                                          })
                                          .catchError((error) {
                                            print(
                                              'error when picking a time ${error.toString()}',
                                            );
                                          });
                                    },
                                    suffix: Icons.access_time,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 20.0,
                        backgroundColor: Colors.amberAccent,
                      )
                      .closed
                      .then((value) {
                        appCubit.changeBottomSheetState(
                          isShown: false,
                          icon: Icons.edit,
                        );
                      });
                  appCubit.changeBottomSheetState(
                    isShown: true,
                    icon: Icons.add,
                  );
                }
              },
              fabIcon: appCubit.fabIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.teal,
              currentIndex: appCubit.currentIndex,
              onTap: (index) {
                appCubit.changeBottomNavBar(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu, color: Colors.white),
                  label: labels[0],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline, color: Colors.white),
                  label: labels[1],
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined, color: Colors.white),
                  label: labels[2],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
