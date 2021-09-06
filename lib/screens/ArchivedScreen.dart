import 'package:Bottom_Navigation_Bar_Udemy/cubit/cubit.dart';
import 'package:Bottom_Navigation_Bar_Udemy/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../form.dart';

class ArchivedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Map> tasks = AppCubit().get(context).archivedTasks;
    return tasks.isEmpty?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.archive,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            'No Archived Tasks Yet,',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Please Add Some Archived Tasks',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    )
        :
    BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            itemCount: tasks.length
        );
      },
    );
  }
}
