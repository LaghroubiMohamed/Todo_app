import 'package:flutter/material.dart';

class Todowidget extends StatelessWidget {
  String text;
  bool isDone;
  Todowidget({this.text, this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 12,
            ),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE) : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: isDone
                  ? null
                  : Border.all(
                      color: Color(0xFF211551),
                      width: 2,
                    ),
            ),
            child: Image(image: AssetImage("assets/images/check_icon.png")),
          ),
          Flexible(
            child: Text(
              text ?? "Unnamed Todo",
              style: TextStyle(
                color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                fontSize: 16,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
