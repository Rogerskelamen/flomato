import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './zen_clock.dart';

class ZenPage extends StatefulWidget {
  const ZenPage({Key? key}) : super(key: key);

  @override
  State<ZenPage> createState() => _ZenPageState();
}

class _ZenPageState extends State<ZenPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _count = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 80.0),
              child: const Icon(
                Icons.self_improvement,
                size: 250.0,
                color: Colors.black12,
              ),
            ),
            Container(
              child: const Text(
                'Zen Mode',
                style: TextStyle(
                  color: Colors.black12,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(90.0, 40.0),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ZenClock())
                  );
                },
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _count++;
          });
        },
        child: const Icon(Icons.info_outline, size: 30.0,),
        heroTag: 'zen_btn',
      ),
    );
  }
}