import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';
import 'package:sams_app/features/quizzes/data/model/data_models/quiz_model.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/shared/quiz_card_image.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/shared/quiz_card_style.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/shared/quiz_status_badge.dart';
import 'package:sams_app/features/quizzes/presentation/view/quiz_tab/widgets/shared/quiz_trailing_icon.dart';

class WebQuizCard extends StatefulWidget {
  final QuizModel quizModel;
  final VoidCallback onTap;

  const WebQuizCard({
    super.key,
    required this.quizModel,
    required this.onTap,
  });

  @override
  State<WebQuizCard> createState() => _WebQuizCardState();
}

class _WebQuizCardState extends State<WebQuizCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final style = QuizCardStyle.fromState(widget.quizModel.state);
    final bool isEnded = widget.quizModel.state == QuizState.closed;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: isEnded ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isEnded ? null : widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovered
                  ? style.titleColor.withValues(alpha: 0.3)
                  : style.borderColor,
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: QuizTrailingIcon(
                  state: widget.quizModel.state,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.sp,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        transform: Matrix4.identity()
                          ..translateByDouble(
                            0,
                            isEnded
                                ? 0
                                : isHovered
                                ? -5
                                : 0,
                            0,
                            1,
                          ),
                        child: QuizCardImage(
                          state: widget.quizModel.state,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.quizModel.title,
                      style: AppStyles.mobileTitleSmallSb.copyWith(
                        fontSize: 18,
                        color: style.titleColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          widget.quizModel.description ??
                              'No description available',
                          style: AppStyles.mobileBodySmallRg.copyWith(
                            fontSize: 13,
                            color: style.descriptionColor.withValues(
                              alpha: 0.8,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: QuizStatusBadge(
                        state: widget.quizModel.state,
                        formattedTime: widget.quizModel.formattedStartTime,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
