import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 25,
        ),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? "(Unnamed Task)",
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 10,
            ),
            Text(desc ?? "No description Added",
                style: GoogleFonts.nunito(
                  color: Color(0xFF86829D),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                )),
          ],
        ));
  }
}
