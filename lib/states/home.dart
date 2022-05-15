import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './clock.dart';
import '../utils/time_handle.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {
  // 设置混合AutomaticKeepAlive来保存状态不被重置
  @override
  bool get wantKeepAlive => true;

  late Duration _time;
  late String _taskName;

  @override
  void initState() {
    super.initState();
    _time = const Duration(minutes: 25);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        // child: CustomScrollView(
        //   slivers: [
        //     SliverFixedExtentList(
        //       itemExtent: 50.0,
        // child: Column(

        // )
        // child :Container(
        //   margin: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 0.0),
        //   padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
        //   decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     color: Colors.white,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Color(0xaaaaaaaa),
        //         offset: Offset(0.0, 5.0),
        //         blurRadius: 8.0,
        //         spreadRadius: 3.0,
        //       )
        //     ]
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const Text('首页', style: TextStyle(fontSize: 20),),
        //       OutlinedButton(
        //         child: const Text(
        //           '+ Enable'
        //         ),
        //         onPressed: (){},
        //       )
        //     ],
        //   ),
        // ),
        // 收藏的时钟列表
        child: ListView.builder(
          itemCount: 10,
          itemExtent: 120.0,
          shrinkWrap: true,
          itemBuilder: (context, index) => _createTile(context, index)
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  // 创建收藏时钟列表
  _createTile(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.computeLuminance() < 0.5 ? Colors.white : Colors.black38,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Color(0x1b1b1b) : Color(0xaaaaaaaa),
            offset: const Offset(0, 5.0),
            blurRadius: 8.0
          )
        ]
      ),
      child: ListTile(
        title: Text('$index', style: TextStyle(fontSize: 20.0),),
      ),
    );
  }

  // 添加一个番茄时间任务
  _addNewTask() {
    showCupertinoModalPopup(
      // 取消点击任意键之后可以退出
      barrierDismissible: false,
      context: context,
      // 设置背景模糊
      filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
      builder: (context) {
        return Center(
          child: Column(
            children: [
              // 取消和确定按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 取消按钮
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, top: 50.0),
                    child: CupertinoButton(
                      child: const Text('取消', style: TextStyle(color: Colors.amberAccent),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    ),
                  ),
                  // 确定按钮
                  Container(
                    margin: const EdgeInsets.only(right: 10.0, top: 50.0),
                    child: CupertinoButton(
                      child: const Text('确定', style: TextStyle(color: Colors.limeAccent),),
                      onPressed: () {
                        // ignore: unnecessary_null_comparison
                        if (_taskName.isEmpty) {
                          // 如果为空直接返回，不让跳转
                          return;
                        }
                        Navigator.of(context).pop();
                        // 跳到另一个页面进行时间显示
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ClockDisplay(time: _time, taskName: _taskName)
                        ));
                        // setState(() {
                          // 遍历所有待办查找那个待办正好在当前待办时间的后面
                        //   for (var i = 0; i < _todos.length; i++) {
                        //     if (_todos[i].date.isAfter(_time)) {
                        //       _todos.insert(i,
                        //         TodoList(
                        //           itemName: _itemName,
                        //           date: _time,
                        //           isChecked: false
                        //         )
                        //       );
                        //       // 插入之后直接return退出
                        //       return;
                        //     }
                        //   }
                        //   // 如果还没有退出，说明当前的待办时间是最后的，直接加上
                        //   _todos.add(TodoList(itemName: _itemName, date: _time, isChecked: false));
                        // });
                      }
                    ),
                  )
                ],
              ),
              // Text Field
              Container(
                height: 60.0,
                padding: const EdgeInsets.only(left: 20.0),
                child: CupertinoTextField(
                  // 自动呼出键盘
                  autofocus: true,
                  // 设置输入框为透明
                  decoration: const BoxDecoration(
                    color: Colors.transparent
                  ),
                  cursorHeight: 30.0,
                  style: TextStyle(
                    fontSize: 30.0,
                    // 字体色随主题色渐变
                    color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.white : Colors.black,
                  ),
                  // 接收输入框中的文字
                  onChanged: (value) {
                    _taskName = value;
                  },
                )
              ),
              // Date Picker
              SizedBox(
                height: 300.0,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    initialDateTime: getTodayBegin().add(const Duration(minutes: 25)),
                    onDateTimeChanged: (value) {
                      _time = value.difference(getTodayBegin());
                    },
                  ),
                )
              )
            ],
          ),
        );
      },
    );
  }
}