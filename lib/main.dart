import 'package:flutter/material.dart';
import 'states/zen.dart';
import 'states/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flomato',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const ScaffoldPage(title: 'Flomato🍅'),
    );
  }
}

// 首页框架
class ScaffoldPage extends StatefulWidget {
  final String title;
  const ScaffoldPage({ Key? key, required this.title }) : super(key: key);

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  // 选中的具体页面
  late int _selectedIndex;
  final _pageController = PageController();

  // 初始化状态
  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  // 设置底部导航各页面图标样式
  final List<BottomNavigationBarItem> _bottomItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
    const BottomNavigationBarItem(icon: Icon(Icons.person_pin_circle_rounded), label: '禅模式'),
  ];

  // 设置body导航
  final List<StatefulWidget> _bodyList = [
    const MyHomePage(),
    const ZenPage()
  ];

  // 点击底部导航后进行页面跳转
  changeBottomNavigationIndex(int index) {
    _pageController.jumpToPage(index);
  }

  // 切换页面
  _pageChanged(int index) {
    setState(() {
      // 更改底部导航选中
      if (_selectedIndex != index) {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title, style: const TextStyle(fontSize: 28),),
      ),
      // 设置body自动跳转到对应索引页面
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: _pageChanged,
        controller: _pageController,
        itemCount: _bodyList.length,
        itemBuilder: (context, index) => _bodyList[index],
      ),
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        currentIndex: _selectedIndex,
        onTap: changeBottomNavigationIndex,
      ),
    );
  }
}