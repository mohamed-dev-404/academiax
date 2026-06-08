import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/helper/app_toast.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/features/grades/data/repos/grade_repo.dart';
import 'package:sams_app/features/grades/presentation/view/instructor/shared/action_button.dart';
import 'package:sams_app/features/grades/presentation/view_model/export_grade_cubit/export_grade_cubit.dart';

class ExportExcelButton extends StatelessWidget {
  const ExportExcelButton({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExportGradeCubit(getIt<GradeRepo>()),
      child: BlocConsumer<ExportGradeCubit, ExportGradeState>(
        listener: (context, state) {
          if (state is ExportGradeSuccess) {
            AppToast.success(context, 'File downloaded successfully');
          } else if (state is ExportGradeFailure) {
            AppToast.error(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is ExportGradeLoading;
          return ActionButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<ExportGradeCubit>().exportGrades(
                      courseId: courseId,
                    );
                  },
            label: 'Export Excel',
            icon: isLoading
                ? buildButtonLoadingIndicator()
                : Icon(Icons.file_download_outlined, size: 18..clamp(16, 20)),
            color: AppColors.primary,
          );
        },
      ),
    );
  }

  SizedBox buildButtonLoadingIndicator() {
    return SizedBox(
      width: 18.sp.clamp(16, 20),
      height: 18.sp.clamp(16, 20),
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
