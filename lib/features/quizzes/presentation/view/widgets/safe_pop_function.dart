import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sams_app/core/models/course_header_card_model.dart';
import 'package:sams_app/core/utils/router/router_payload_cache.dart';
import 'package:sams_app/core/utils/router/routes_name.dart';

/// Safely navigates the user back to the previous screen.
///
/// Priority logic:
/// 1. Use [context.pop] if a stack exists (Handles most Mobile/Web transitions).
/// 2. If stack is lost (e.g., page refresh on Web), fallback to cached Course Details.
/// 3. Ultimate fallback to Courses List.
void safePop({required BuildContext context}) {
  if (context.canPop()) {
    context.pop();
  } else {
    // Stack lost fallback (Common on Web Refresh)
    final model = RouterPayloadCache.get<CourseHeaderCardModel>(
      RoutesName.courseDetails,
      null,
    );

    if (model != null) {
      context.go(RoutesName.courseDetails, extra: model);
    } else {
      context.go(RoutesName.courses);
    }
  }
}
