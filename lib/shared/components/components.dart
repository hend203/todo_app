import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
// import 'package:path/path.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  IconData? prefix,
  IconData? suffix,
  bool isPassword = false,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap,
  void Function()? onSuffixPressed,
  required String? Function(String?)? validate,
  bool isClickable = true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    validator: validate,
    enabled: isClickable,
    onTap: onTap,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: prefix != null ? Icon(prefix) : null,
      suffixIcon: suffix != null
          ? IconButton(icon: Icon(suffix), onPressed: onSuffixPressed)
          : null,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    ),
  );
}

// class buildTaskItem extends StatelessWidget {
//   const buildTaskItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TaskItem();
//   }

Widget buildTaskItem(Map task, context) {
  return Dismissible(
    key: Key(task['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteData(id: task['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.teal,
            child: Text(
              '${task['time']}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${task['title']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${task['date']}',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check_box, color: Colors.teal[300]),
                onPressed: () {
                  AppCubit.get(
                    context,
                  ).updateData(status: 'done', id: task['id']);
                },
              ),
              IconButton(
                icon: Icon(Icons.archive, color: Colors.grey[600]),
                onPressed: () {
                  AppCubit.get(
                    context,
                  ).updateData(status: 'archived', id: task['id']);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => const Divider(),
    itemCount: tasks.length,
  ),
  fallback: (context) => const Center(
    child: Text(
      'No tasks available , please add some tasks',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  ),
);
