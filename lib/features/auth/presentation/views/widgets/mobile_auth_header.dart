import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sams_app/core/utils/assets/app_images.dart';

class MobileAuthHeader extends StatelessWidget {
  const MobileAuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 375 / 293,
        child: SvgPicture.asset(
          AppImages.imagesMobileAuthHeader,
        ),
      ),
    );
  }
}
