// ignore_for_file: unnecessary_import

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cubit/AppCubit.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validate,
  required String label,
  Function? onTab,
  required IconData suffix,
  bool readOnly = false,
}) => TextFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: label,
    suffixIcon: Icon(suffix),
  ),
  keyboardType: type,
  controller: controller,
  onTap: onTab as void Function()?,
  validator: validate,
  readOnly: readOnly,
);
// login or register button
Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required Function() function,
  required String text,
}) => Container(
  width: width,
  height: 40.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
  child: MaterialButton(
    onPressed: function,
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
// password FormFiled Box
Widget passwordTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onTap,
  required bool isPassword,
  required String? Function(String?) validate,
  required String label,
  required Widget prefix,
  Widget suffix = const Icon(Icons.remove_red_eye),
  required Function() suffixPressed,
  bool isClickable = true,
}) => TextFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: label,
    prefixIcon: prefix,
    suffixIcon: IconButton(onPressed: suffixPressed, icon: suffix),
  ),
  keyboardType: type,
  controller: controller,
  validator: validate,
  obscureText: isPassword,
);
// email FormFiled Box
Widget emailTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onTap,
  required String? Function(String?) validate,
  required String label,
  required Widget prefix,
  bool isClickable = true,
}) => TextFormField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: label,
    prefixIcon: prefix,
  ),
  keyboardType: type,
  validator: validate,
  controller: controller,
);
// name FormFiled Box
Widget nameTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onTap,
  required String? Function(String?) validate,
  required String label,
  bool isClickable = true,
}) => TextFormField(
  decoration: InputDecoration(border: OutlineInputBorder(), labelText: label),
  keyboardType: type,
  controller: controller,
  validator: validate,
);

// Task Item
Widget buildTaskItem(Map model, Color color, context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction) {
    AppCubit.get(
      context,
    ).deleteFromDatabase(status: model['status'], id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: color,
          child: Text(
            '${model['time']}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5),
              Text(
                '${model['date']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: () {
                AppCubit.get(
                  context,
                ).updateInDatabase(status: 'done', id: model['id']);
              },
              icon: Icon(Icons.check_circle_outline, color: Colors.green),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(
                  context,
                ).updateInDatabase(status: 'archive', id: model['id']);
              },
              icon: Icon(Icons.archive, color: Colors.black45),
            ),
          ],
        ),
      ],
    ),
  ),
);
// Floating Action Button
Widget defaultFloatingActionButton({
  required Function() changeBottomSheetState,
  required IconData fabIcon,
}) => FloatingActionButton(
  onPressed: changeBottomSheetState,
  backgroundColor: Colors.blueAccent,
  child: Icon(fabIcon, color: Colors.white, size: 30),
);

// Tasks Builder

Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) =>
        buildTaskItem(tasks[index], Colors.grey, context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.blueGrey,
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu, size: 90, color: Colors.grey),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);
