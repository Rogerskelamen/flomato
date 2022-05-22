import 'dart:ui';

// 主题库
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// 另一个state
import './clock.dart';

// 引入实体类
import '../entity/clock_info.dart';

// 工具类
import '../utils/time_handle.dart';

// 第三方库
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {
  // 设置混合AutomaticKeepAlive来保存状态不被重置
  @override
  bool get wantKeepAlive => true;

  // 弹出框显示的时间和任务名称
  late Duration _time;
  late String _taskName;

  // 收集所有的任务和时间
  List<ClockInfo> _clockList = [];

  @override
  void initState() {
    super.initState();

    // 初始化变量
    _time = const Duration(minutes: 25);
    // 载入持久化数据
    _loadList();
  }

  _loadList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('taskList') ?? [];
    List<String> lastList = prefs.getStringList('lastList') ?? [];
    setState(() {
      // 直接置空，强制初始化
      _clockList = [];

      for (var i = 0; i < taskList.length; i++) {
        // 每次添加一个ClockInfo实例
        _clockList.add(
          ClockInfo(
            last: Duration(minutes: int.parse(lastList[i])),
            task: taskList[i]
          )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        // 收藏的时钟列表
        child: ListView.builder(
          itemCount: _clockList.length,
          itemExtent: 110.0,
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
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.computeLuminance() < 0.5 ? Colors.white : Colors.black38,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: use_full_hex_values_for_flutter_colors
            color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? const Color(0x1b1b1b) : const Color(0xaaaaaaaa),
            offset: const Offset(0, 5.0),
            blurRadius: 8.0
          )
        ]
      ),
      child: ListTile(
        leading: const Icon(Icons.alarm, size: 40,),
        title: Text(
          _clockList[index].task,
          style: const TextStyle(fontSize: 24.0,),
        ),
        subtitle: Text(
          '持续专注: ' + displayLast(_clockList[index].last),
          style: const TextStyle(fontSize: 16.0),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 30.0,),
          onPressed: _deleteClock(index),
        ),
      )
    );
  }

  // 删除一个时钟
  _deleteClock(int index) {
    
  }

  // 添加一个番茄时间任务
  _addNewTask() {
    // 重新清空变量
    _taskName = '';
    _time = const Duration(minutes: 25);

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
                      child: const Text('确定', style: TextStyle(color: Colors.amberAccent),),
                      onPressed: () {
                        // ignore: unnecessary_null_comparison
                        if (_taskName.isEmpty || _time == const Duration(seconds: 0)) {
                          // 如果为空直接返回，不让跳转
                          return;
                        }
                        Navigator.of(context).pop();
                        // 跳到另一个页面进行时间显示
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ClockDisplay(time: _time, taskName: _taskName, isPrefer: false,)
                        ));
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
                    textTheme: CupertinoTextThemeData(),
                  ),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: const Duration(minutes: 25),
                    onTimerDurationChanged: (value) {
                      _time = value;
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