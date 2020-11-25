import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<HomePage>{
  int degisenSayi = 0;

  void sayiArttir(){
    setState(() {
      degisenSayi++;
    });
  }
  void sayiAzalt(){
    setState(() {
      degisenSayi--;
    });
  }
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return new Scaffold(
      backgroundColor: Color(0XFF2e2e2e),
      appBar: new AppBar(
        backgroundColor: Color(0XFF2e2e2e),
        title: new Text("Revolution Remote Car"),
          actions: [
            IconButton(
            icon: Icon(Icons.bluetooth),
              onPressed: () => Navigator.pushNamed(context, "/bluetooth")
            ),
            IconButton(
                icon: Icon(Icons.camera_alt_outlined),
                onPressed: () => Navigator.pushNamed(context, "/ilkSayfa")
            ),
      ]
    ),
      body: new Row(
        children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              new Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 25),
                child:new ControllerButton(
                    child: Icon(Icons.keyboard_arrow_up, size: 20, color: Colors.white54),
                    onPressed: sayiArttir
                ),
              ),
              new Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 40),
                child:new ControllerButton(
                    child: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.white54),
                    onPressed: sayiAzalt
                ),)

            ],
          ),
          Align(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 200,
                  width: 370,
                  color: Colors.grey,
                );
              },
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
            child:new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  new Row(
                    children: [
                      new ControllerButton(
                          child: Icon(Icons.keyboard_arrow_left, size: 20, color: Colors.white54),
                          onPressed: sayiArttir
                      ),
                      new Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: new ControllerButton(
                            child: Icon(Icons.keyboard_arrow_right, size: 20, color: Colors.white54),
                            onPressed: sayiAzalt
                        ),
                      )

                    ],
                  )

                ],
              ),
          )
        ]
      )
    );

  }
}
class ControllerButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  final Color color;
  const ControllerButton({Key key, this.child, this.borderRadius = 30, this.color, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: Color(0XFF2e2e2e),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [Color(0XFF1c1c1c), Color(0XFF383838)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0XFF1c1c1c),
            offset: Offset(5.0, 5.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Color(0XFF404040),
            offset: Offset(-5.0, -5.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            gradient: const LinearGradient(begin: Alignment.topLeft, colors: [Color(0XFF303030), Color(0XFF1a1a1a)]),
          ),
          child: MaterialButton(
            color: color,
            minWidth: 0,
            onPressed: onPressed,
            shape: CircleBorder(),
            child: child,
          ),
        ),
      ),
    );
  }
}
