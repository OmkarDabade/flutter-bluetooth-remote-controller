import 'package:flutter/material.dart';


class CameraComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.play_arrow_sharp,
                  color: Colors.white,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, "/ilkSayfa"),
              ),
              IconButton(
                icon: Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, "/ilkSayfa"),
              ),
              IconButton(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, "/ilkSayfa"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
