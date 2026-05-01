import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/configs/size_config.dart';
import 'package:sams_app/core/widgets/shared/general_arrow_back.dart';
import 'package:sams_app/features/assignments/data/model/get_all_submissions/student_info_model.dart';

class SubmissionDetailsHeader extends StatelessWidget {
  const SubmissionDetailsHeader({super.key, required this.studentInfo});
  final StudentInfoModel studentInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 30),
      child: Column(
        children: [
          /// Top Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                SizeConfig.isMobile(context)
                    ? IconButton(
                        onPressed: () => context.pop(),
                        icon: const GeneralArrowBack(
                          color: AppColors.white,
                        ),
                      )
                    : const SizedBox(width: 40),
                SizeConfig.isMobile(context)
                    ? const SizedBox(width: 40)
                    : const Expanded(child: SizedBox()),
                const Text(
                  'Student Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizeConfig.isMobile(context)
                    ? const SizedBox(width: 40)
                    : const Expanded(child: SizedBox()),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: ClipOval(
              child:
                  (studentInfo.profilePic == null ||
                      studentInfo.profilePic!.isEmpty)
                  ? Text(
                      // Logic to get first letter of the first and second name (e.g., Tamara Mazen -> TM)
                      (() {
                        // Trim and split the name into a list of words
                        final List<String> names =
                            studentInfo.name?.trim().split(' ') ?? [];

                        if (names.length >= 2) {
                          // Take the first letter of the first two words
                          return (names[0][0] + names[1][0]).toUpperCase();
                        } else if (names.isNotEmpty && names[0].isNotEmpty) {
                          // If only one name exists, take the first two letters of that name
                          return names[0]
                              .substring(0, names[0].length >= 2 ? 2 : 1)
                              .toUpperCase();
                        }
                        return '??'; // Default placeholder if name is totally empty
                      })(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    )
                  : Image.network(
                      studentInfo.profilePic!,
                      width: 80, // Double the radius for a perfect fit
                      height: 80,
                      fit: BoxFit.cover,

                      /// Error handler to show initials if the image fails to load from the server
                      errorBuilder: (context, error, stackTrace) => Text(
                        (() {
                          final List<String> names =
                              studentInfo.name?.trim().split(' ') ?? [];
                          if (names.length >= 2) {
                            return (names[0][0] + names[1][0]).toUpperCase();
                          }
                          if (names.isNotEmpty) {
                            return names[0]
                                .substring(0, names[0].length >= 2 ? 2 : 1)
                                .toUpperCase();
                          }
                          return '??';
                        })(),
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          /// Name
          Text(
            studentInfo.name ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),

          /// ID
          Text(
            'ID: ${studentInfo.academicId}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
