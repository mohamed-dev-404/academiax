import 'package:flutter/material.dart';
import 'package:sams_app/features/home/presentation/views/home/widgets/web/web_home_view_body.dart';

//* The web layout for the home screen
class WebHomeView extends StatelessWidget {
  const WebHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WebHomeViewBody(),
    );
  }
}
