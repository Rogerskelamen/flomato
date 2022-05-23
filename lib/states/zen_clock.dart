import 'dart:async';

import 'package:flutter/material.dart';

// 工具库
import '../utils/time_handle.dart';

// 第三方库
import 'package:just_audio/just_audio.dart';
import 'package:wakelock/wakelock.dart';

class ZenClock extends StatefulWidget {
  const ZenClock({Key? key}) : super(key: key);

  @override
  State<ZenClock> createState() => _ZenClockState();
}

class _ZenClockState extends State<ZenClock> with WidgetsBindingObserver {
  // 是否计时结束
  late bool _isEndCircle;
  // 是否位于25分钟专注计时
  late bool _isWorking;
  // 是否停止了计时
  late bool _isStop;
  // 倒计时时刻
  late Duration _time;
  // 计时间隔
  late Duration _ticker;
  // 计时器
  late Timer _timer;
  // 变化的按钮图标
  late Icon _icon;

  // 音频播放器
  final _player = AudioPlayer();


  // 播放闹铃
  _playAlarm() async {
    // 设置闹铃铃声音频
    await _player.setAsset('audio/iphone_alarm.mp3');
    await _player.setLoopMode(LoopMode.one); // 设置循环播放闹铃
    _player.play();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    // 初始化变量
    _isEndCircle = false;
    _isWorking = true;
    _isStop = false;
    _time = const Duration(minutes: 25);
    _ticker = const Duration(milliseconds: 1000);
    _icon = const Icon(Icons.pause_circle_outline, size: 30.0,);

    // 开始计时
    _clockBegin();
  }

  // 计时器方法
  _clockBegin() {
    _timer = Timer.periodic(_ticker, (timer) {
      setState(() {
        _time -= const Duration(seconds: 1);
      });

      // 如果倒计时结束
      if(_time == const Duration(seconds: 0)) {
        setState(() {
          // 设置关闭倒计时的状态
          _isEndCircle = true;
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
    _timer.cancel();
    _player.stop();
    _player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      // 处于这种状态的应用程序应该假设他们可能在任何时候暂停
      case AppLifecycleState.inactive:  // 开始对app进行操作（任何操作）
        print('inactive');
        break;
      case AppLifecycleState.resumed: // 从后台切前台，界面可见
        print('resumed');
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        print('paused');
        break;
      case AppLifecycleState.detached: // APP 结束时调用
        print('detached');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isWorking ? const Text('禅模式')
                          : const Text('可以休息啦'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            // 展示一个不断循环的动效
            LinearProgressIndicator(
              value: _isEndCircle ? 100 : null,
            ),

            // 番茄时钟图片和动画
            Container(
              margin: const EdgeInsets.only(top: 60.0, bottom: 50.0),
              height: 200,
              width: 400,
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
                        value: _isWorking ? _time.inSeconds / (60 * 25)
                                          : _time.inSeconds / (60 * 5)
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
              margin: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _stop,
                    icon: _isEndCircle ? const Icon(Icons.stop_circle, size: 30.0,)
                                       : _icon
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // 返回主页
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
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

  _stop() async {
    if (_isEndCircle) {
      // 停止闹铃
      await _player.stop();

      _isWorking = !_isWorking;
      _isEndCircle = false;
      setState(() {
        // 设置好倒计时时长
        if(_isWorking) {
          _time = const Duration(minutes: 25);
        } else {
          _time = const Duration(minutes: 5);
        }
      });
      // 重新开始倒计时
      _clockBegin();
    } else {
      if(_isStop) {
        // 重新开始
        _clockBegin();
        setState(() {
          _icon = const Icon(Icons.pause_circle_outline, size: 30.0,);
        });
        _isStop = false;
      } else {
        // 停止计时
        _timer.cancel();
        setState(() {
          _icon = const Icon(Icons.play_circle_outline, size: 30.0,);
        });
        _isStop = true;
      }
    }
  }

}