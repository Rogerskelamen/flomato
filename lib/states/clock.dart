import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/time_handle.dart';

// ignore: must_be_immutable
class ClockDisplay extends StatefulWidget {
  Duration time;
  String taskName;

  ClockDisplay({Key? key, required this.time, required this.taskName}) : super(key: key);

  @override
  State<ClockDisplay> createState() => _ClockDisplayState();
}

class _ClockDisplayState extends State<ClockDisplay> {
  // 接受传过来的持续时间
  late Duration _time;
  // 定义一个时间片
  late Duration _ticker;

  bool _isEndCicle = false;

  @override
  void initState() {
    super.initState();
    // 初始化变量
    _time = widget.time;
    _ticker = const Duration(milliseconds: 100);

    // 页面一旦初始化就开始计时
    Timer.periodic(_ticker, (timer) {
      setState(() {
        _time -= const Duration(seconds: 1);
      });

      // 如果倒计时结束
      if(_time == const Duration(seconds: 0)) {
        setState(() {
          _isEndCicle = true;
        });

        // 结束计时器
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: _isEndCicle ? const Text('可以休息一下了') : Text('正在专心于' + widget.taskName),
      ),
      body: Center(
        child: Column(
          children: [
            // 展示一个不断循环的动效
            LinearProgressIndicator(
              value: _isEndCicle ? 100 : null,
            ),

            // 番茄时钟图片和动画
            Container(
              margin: const EdgeInsets.only(top: 50.0, bottom: 20.0),
              height: 200,
              width: 400,
              // color: Colors.pink,
              child: Stack(
                children: [
                  Positioned(
                    left: 105.0,
                    top: 6.0,
                    child: SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 10.0,
                        // 用现在的时间和最开始传过来的时间相比
                        value: _time.inSeconds / widget.time.inSeconds,
                      ),
                    )
                  ),
                  Positioned(
                    child: Image.asset('imgs/tomato.png'),
                  )
                ],
              ),
            ),

            // 正式倒计时时钟
            Text(displayDuration(_time), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300),)
          ],
        ),
      ),
    );
  }
}