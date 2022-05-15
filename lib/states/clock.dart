import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ClockDisplay extends StatefulWidget {
  Duration time;
  String taskName;

  ClockDisplay({Key? key, required this.time, required this.taskName}) : super(key: key);

  @override
  State<ClockDisplay> createState() => _ClockDisplayState();
}

class _ClockDisplayState extends State<ClockDisplay> {
  late Duration _time;

  @override
  void initState() {
    super.initState();
    _time = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('正在专心于一件事中'),
      ),
      body: Center(
        child: Column(
          children: [
            // 展示一个不断循环的动效
            const LinearProgressIndicator(),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              height: 200,
              width: 400,
              // color: Colors.pink,
              child: Stack(
                children: [
                  Positioned(
                    left: 103.0,
                    top: 8.0,
                    // color: Colors.red,
                    child: Container(
                      width: 180.0,
                      height: 180.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 10.0,
                        // value: _time.inMinutes / 100,
                      ),
                    )
                  ),
                  Positioned(
                    // child: Container(
                    //   width: 100,
                    //   height: 100,
                    //   color: Colors.transparent,
                    // ),
                    // bottom: 10.0,
                    child: Image.asset('imgs/tomato.png', scale: 0.8,),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}