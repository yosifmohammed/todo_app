import 'package:Bottom_Navigation_Bar_Udemy/cubit/cubit.dart';
import 'package:Bottom_Navigation_Bar_Udemy/cubit/states.dart';
import 'package:Bottom_Navigation_Bar_Udemy/form.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map> tasks = AppCubit().get(context).newTasks;
    return ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) => BlocConsumer<AppCubit, AppStates>(
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
        ),
        fallback: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                'No New Tasks Yet, ',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Please Add Some New Tasks',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
    );
  }
}
