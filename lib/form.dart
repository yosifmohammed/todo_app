import 'package:Bottom_Navigation_Bar_Udemy/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  //@required bool obscure,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTab,
  @required Function validate,
  @required String label,
  @required Icon prefixIcon,
  Widget suffixIcon,
  bool isClickable = true,
}) => TextFormField(
    controller: controller,
    //obscureText: obscure,
    keyboardType: type,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    validator: validate,
    onTap: onTab,
    enabled: isClickable,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ));

Widget buildTaskItem(Map model, context) => Dismissible(
  key: UniqueKey(),
  child:   Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            child: Text('${model['date']}' ,style: TextStyle(fontSize: 14),),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${model['time']}',
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
              onPressed: (){
                AppCubit().get(context).updateData(status: 'done', id: model['id']);
              },
              icon:Icon(Icons.check_box, color: Colors.green,),
          ),
          IconButton(
            onPressed: (){
              AppCubit().get(context).updateData(status: 'archive', id: model['id']);
            },
            icon: Icon(Icons.archive, color: Colors.black45,),
          ),
        ],
      ),
    ),
  onDismissed: (direction){
    if(direction == DismissDirection.startToEnd)
    AppCubit().get(context).deleteData(id: model['id'],);
  },
);