import 'package:flutter/material.dart';
//not so clear why this was used yet
extension GetArgument on BuildContext{
  T? getArgument<T>(){
    final modalRoute=ModalRoute.of(this);
    if(modalRoute!=null){
      final args = modalRoute.settings.arguments;
      if(args!=null&& args is T){
        return args as T;
      }
    }
    return null;
  }
}