import 'dart:math';
import 'package:flutter/material.dart'; // runApp在这个material库里面

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YHHomePage(),
    );
  }
}
// 动画
class YHHomePage extends StatefulWidget {
  const YHHomePage({Key? key}) : super(key: key);

  @override
  State<YHHomePage> createState() => _YHHomePageState();
}

class _YHHomePageState extends State<YHHomePage> with SingleTickerProviderStateMixin {
  // 1.创建AnimationController
  late AnimationController _controller;
  late final Animation<double> _animation;

  late final Animation _sizeAnim;
  late final Animation _colorAnim;
  late final Animation _opacityAnim;
  late final Animation _radiansAnim;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),

    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    // 3. Tween 的 animate 有些是不支持设置CurvedAnimation。
    //     _sizeAnim = Tween(begin: 10.0,end: 200.0).animate(_animation); 最好不要这样写 可能会导致报错
    // 3.1 创建size的 Tween 大小
    _sizeAnim = Tween(begin: 10.0,end: 200.0).animate(_controller);
    // 3.2 创建color的 Tween 颜色
    _colorAnim = ColorTween(begin: Colors.orange,end: Colors.blue).animate(_controller);
    // 3.1 创建opacity的 Tween 透明度
    _opacityAnim = Tween(begin: 0.0,end: 1.0).animate(_controller);
    // 3.1 创建radians的 Tween 旋转幅度
    _radiansAnim = Tween(begin: 0.0,end: 2 *pi).animate(_controller);


    //
    // _controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });

    // 监听动画的变化的改变
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        _controller.reverse();
      }
      else if (status == AnimationStatus.dismissed){
        _controller.forward();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    print("执行了_YHHomePageState 的build 方法");

    /**
     * 效果
     * 1. 大小变化动画
     * 2. 颜色变化动画
     * 3. 透明度变化动画
     * */
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: Center(
        child:AnimatedBuilder(
          builder: (ctx,child){
            return Opacity(
              opacity: 0.5, // 透明度
              //  将需要旋转的Widget用Transform包裹
              child: Transform(
                transform: Matrix4.rotationZ(_radiansAnim.value), // pi是180
                alignment: Alignment.center,
                child: Container(
                  width: _sizeAnim.value,
                  height: _sizeAnim.value,
                  color: _colorAnim.value,
                ),
              ),
            );
          },
          animation: _controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: (){
          if(_controller.isAnimating){
            _controller.stop();
          }
          else if (_controller.status == AnimationStatus.forward){
            _controller.forward();
          }
          else if (_controller.status == AnimationStatus.reverse){
            _controller.reverse();
          }
          else {
            _controller.forward();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // 回收
    _controller.dispose();
  }
}





