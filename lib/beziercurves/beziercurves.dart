import 'package:flutter/material.dart';

class BezierCurve extends StatefulWidget {
  const BezierCurve({super.key, required this.title});

  final String title;

  @override
  State<BezierCurve> createState() => _BezierCurveState();
}

class _BezierCurveState extends State<BezierCurve> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  double x = 0, y = 0, z = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CustomPaint(
                  painter: _ClipShadowShadowPainter(
                      clipper: WaveClipper(),
                      shadow: const Shadow(
                          blurRadius: 10,
                          color: Colors.grey,
                          offset: Offset(0, 10))),
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.amber,
                    ),
                  ),
                ),
                CustomPaint(
                  painter: _ClipShadowShadowPainter(
                      clipper: WaveClipper(),
                      shadow: const Shadow(
                          blurRadius: 10,
                          color: Color.fromARGB(255, 68, 48, 48),
                          offset: Offset(0, 5))),
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Aabid Bin Syeed',
              style: TextStyle(
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(10.0, 10.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  // Shadow(
                  //   offset: Offset(10.0, 10.0),
                  //   blurRadius: 8.0,
                  //   color: Color.fromARGB(125, 0, 0, 255),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration:
                      const BoxDecoration(color: Colors.yellow, boxShadow: [
                    BoxShadow(color: Colors.grey, offset: const Offset(10, 12))
                  ]),
                ),
                ClipPath(
                  clipper: LeaveCliper(),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 40, 109, 40),
                              offset: Offset(10, 12))
                        ]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ClipPath(
              clipper: CubicCurve(),
              child: Container(
                height: 150,
                width: 100,
                decoration: const BoxDecoration(color: Colors.blue, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 36, 115, 168),
                      offset: Offset(10, 12))
                ]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ClipPath(
              clipper: ArcToPoints(),
              child: Container(
                height: 150,
                width: 100,
                decoration: const BoxDecoration(
                    color: Colors.purple,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 36, 115, 168),
                          offset: Offset(10, 12))
                    ]),
              ),
            ),
          ],
        ),
        // Transform(
        //   transform: Matrix4.identity()
        //     ..rotateX(x)
        //     ..rotateY(y)
        //     ..rotateZ(z),
        //   child: GestureDetector(
        //     onPanUpdate: (details) {
        //       setState(() {
        //         y = y - details.delta.dx / 100;
        //         x = x - details.delta.dy / 100;
        //       });
        //     },
        //     child: Container(
        //       color: Colors.red,
        //       height: 40,
        //       width: 40,
        //     ),
        //   ),
        // ),
        // const Text(
        //   'You have pushed the button this many times:',
        // ),
        // Text(
        //   '$_counter',
        //   style: Theme.of(context).textTheme.headline4,
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ArcToPoints extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20;
    var path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius))
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(Offset(size.width - radius, size.height),
          radius: Radius.circular(radius))
      ..lineTo(radius, size.height)
      ..arcToPoint(Offset(0, size.height - radius),
          radius: Radius.circular(radius), clockwise: false)
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: const Radius.elliptical(40, 20))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CubicCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var controlPoint1 = Offset(50, size.height - 100);
    var controlpoint2 = Offset(size.width - 50, size.height - 50);
    var endpoint = Offset(size.width, size.height - 50);
    var path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height - 50)
      ..cubicTo(controlPoint1.dx, controlPoint1.dy, controlpoint2.dx,
          controlpoint2.dy, endpoint.dx, endpoint.dy);
    // ..lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LeaveCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0); //p0
    var firstStart = Offset(0, size.height / 2);
    var firstEnd = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    var secondStart = Offset(size.width, size.height / 2);
    var secondEnd = Offset(size.width / 2, 0);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height); // starting point //p0
    var firstStart = Offset(size.width / 5, size.height); // p1
    //first point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0); // p2
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    // path.lineTo(size.width, size.height - 10);
    // now we need to make second controlling point like p1
    // p2 will be our starting point and p3 is now controller
    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105); //p3
    // third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10); //p4
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0); // p5 end with this point to complete the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

// shadow of this any widget
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    super.key,
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  //https://medium.com/flutter-community/multi-language-support-in-flutter-a12de708f833
//   List<String> names=[];

// // Don’t
// names.forEach((name) {
//   print(name);
// });

// // Do
// names.forEach(print);
//Don't
  var s = 'This is demo string \\ and \$';

//Do
  var st = r'This is demo string \ and $';
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
