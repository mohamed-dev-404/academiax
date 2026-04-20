import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/features/quizzes/presentation/view/widgets/safe_pop_function.dart';

class SharedBackButton extends StatelessWidget {
  const SharedBackButton({
    super.key,
    this.color = AppColors.whiteLight,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => safePop(context: context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color!.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
