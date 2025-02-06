import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );
  //hint Text('text'),
  static const TextStyle hintText = TextStyle(
    fontSize: 12,
    color: AppColors.text,
  );
  // boldText
  static const TextStyle boldText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  // 14 w400
  static const TextStyle w400 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );


}
