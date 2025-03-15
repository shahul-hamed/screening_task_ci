import 'package:flutter/material.dart';

/// custom elevated button
class MyElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  MyElevatedButton({required this.text,required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Set the background color to blue
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Set border radius to 12
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15
          // Set the text color to white
        ),
      ),
    );

  }

}