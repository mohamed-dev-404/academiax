import 'package:flutter/material.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/mobile/mobile_home_app_bar.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/mobile/mobile_home_view_body.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/shared/active_profile_builder.dart';

//* The mobile layout for the home screen
class MobileHomeView extends StatelessWidget {
  const MobileHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ActiveProfileBuilder(
      builder: (context, name, imagePath) {
        return Scaffold(
          appBar: MobileHomeAppBar(
            userName: name,
            imagePath: imagePath,
          ),
          body: const MobileHomeViewBody(),
        );
      },
    );
  }
}