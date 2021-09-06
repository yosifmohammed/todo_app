import 'package:Bottom_Navigation_Bar_Udemy/cubit/cubit.dart';
import 'package:Bottom_Navigation_Bar_Udemy/cubit/states.dart';
import 'package:Bottom_Navigation_Bar_Udemy/form.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget
 {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state){
          AppCubit cubit = AppCubit().get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              elevation: 0,
              title: Text(
                  cubit.titles[cubit.indexPage]
              ),
              centerTitle: true,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              showUnselectedLabels: false,
              selectedLabelStyle: TextStyle(color: Colors.black),
              unselectedIconTheme: IconThemeData(color: Colors.grey),
              selectedIconTheme: IconThemeData(color: Colors.blueGrey),
              selectedItemColor: Colors.blueGrey,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined,size: 20,),label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.download_done_outlined,size: 20), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined,size: 20),label: 'Archived')
              ],
              currentIndex: cubit.indexPage,
              onTap: (index){
                AppCubit().get(context).changeIndex(index);
              },
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.indexPage],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: cubit.addColor,
              child: Icon(cubit.addIcon),
              onPressed: ()
              {
                if(cubit.isBottomSheetOpened)
                {
                  if(formKey.currentState.validate()){
                    cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text
                    );
                  }
                }else
                  {
                  scaffoldKey.currentState
                      .showBottomSheet((context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                              controller: titleController,
                              type: TextInputType.text,
                              validate: (String value){
                                if(value.isEmpty){
                                  return 'Title must be not empty';
                                }
                                return null;
                              },
                              label: 'Task Title',
                              prefixIcon: Icon(Icons.title),
                              onTab: (){
                                print('timing tapped');
                              }
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: timeController,
                            onTab: (){
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now()).then((value){
                                timeController.text = value.format(context).toString();
                              });
                            },
                            type: TextInputType.datetime,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Time must be not empty';
                              }
                              return null;
                            },
                            label: 'Task Time',
                            prefixIcon: Icon(Icons.watch_later_outlined),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: dateController,
                            onTab: (){
                              showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2021-09-02')
                              ).then((value){
                                dateController.text = DateFormat.yMMMd().format(value);
                              });
                            },
                            type: TextInputType.datetime,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'Date must be not empty';
                              }
                              return null;
                            },
                            label: 'Task Date',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                      elevation: 10
                  ).closed.then((value) {
                  cubit.changeBottomSheetState(
                  isShow: false,
                  icon: Icons.edit,
                  color: Colors.teal
                  );
                  });
                  }
                cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.add,
                    color: Colors.greenAccent
                );
                }
            ),
          );

        },
      ),
    );
  }
}
