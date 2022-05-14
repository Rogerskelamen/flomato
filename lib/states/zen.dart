import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
          children: [
            const Text('禅模式', style: TextStyle(fontSize: 36),),
            Text('$_count', style: const TextStyle(fontSize: 30),)
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}