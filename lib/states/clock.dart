import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/time_handle.dart';
import 'package:just_audio/just_audio.dart';

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
  // 是否结束的标志
  bool _isEndCicle = false;

  // 音频播放器
  final _player = AudioPlayer();


  _playAlarm() async {
    // 设置闹铃铃声音频
    await _player.setAsset('audio/iphone_alarm.mp3');
    await _player.setLoopMode(LoopMode.one); // 设置循环播放闹铃
    _player.play();
  }

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
          // 设置关闭倒计时的状态
          _isEndCicle = true;
        });
        // 播放闹铃
        _playAlarm();

        // 结束计时器
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _player.stop();
    _player.dispose();
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
              margin: const EdgeInsets.only(top: 60.0, bottom: 50.0),
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
                        color: Colors.lightGreen,
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
            Text(displayDuration(_time), style:
              const TextStyle(
                fontSize: 46,
                fontWeight: FontWeight.w300,
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 12.0,
                    color: Color.fromARGB(255, 120, 120, 120),
                  )
                ],
              ),
            ),

            // 下面三个按钮
            Container(
              margin: const EdgeInsets.only(top: 30),
              // color: Colors.pink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _resetOrStop,
                    icon: _isEndCicle ? const Icon(Icons.stop_circle, size: 30.0,)
                                      : const Icon(Icons.refresh, size: 30.0,)
                  ),
                  IconButton(
                    onPressed: _star(),
                    icon: const Icon(Icons.favorite_border, size: 30.0,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Back',
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 重置按钮或者是停止按钮
  _resetOrStop() async {
    if (_isEndCicle) {
      await _player.stop();
    }else {
      setState(() {
        _time = widget.time;
      });
    }
  }

  // 添加时钟收藏
  _star() {

  }

  // IconButton _getIconBtn() {
  //   return IconButton(on, icon: icon)
  // }
}