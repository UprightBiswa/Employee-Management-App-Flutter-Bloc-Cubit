import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  //radius
  final double? radius;
  //border color
  final bool? borderColor;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.radius,
    this.borderColor = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
              borderColor == true ? AppColors.primary : Colors.white),
          backgroundColor: MaterialStateProperty.all(
              borderColor == true ? Colors.white : AppColors.primary),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor == true
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(
                radius ?? 8,
              ),
            ),
          ),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 16,
                color: borderColor == true ? AppColors.primary : Colors.white)),
      ),
    );
  }
}
