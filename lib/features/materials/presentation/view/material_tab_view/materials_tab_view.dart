import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sams_app/core/utils/services/service_locator.dart';
import 'package:sams_app/core/widgets/shared/adaptive_layout.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/widget/mobile/materials_mobile_layout.dart';
import 'package:sams_app/features/materials/presentation/view/material_tab_view/widget/web/materials_web_layout.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';

/// The root entry point for the Materials Tab.
/// It orchestrates state management and adaptive rendering for both Mobile and Web platforms.
class MaterialsTabView extends StatelessWidget {
  final String courseId;
  const MaterialsTabView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    //* State Injection Layer:
    //* Providing necessary Cubits using 'getIt' (Service Locator) to maintain a clean dependency tree.
    return MultiBlocProvider(
      providers: [
        //* 1. Fetch Cubit: Responsible for loading the list of materials.
        //* Triggering the initial fetch immediately upon creation.
        BlocProvider(
          create: (context) =>
              getIt<MaterialFetchCubit>()..fetchMaterials(courseId: courseId),
        ),
        //* 2. CRUD Cubit: Responsible for operations like adding or deleting materials.
        BlocProvider(
          create: (context) => getIt<MaterialCrudCubit>(),
        ),
      ],
      //* Adaptive UI Layer:
      //* Seamlessly switches between Mobile and Web layouts based on screen constraints.
      child: AdaptiveLayout(
        mobileLayout: (context) => MaterialsMobileLayout(
          courseId: courseId,
        ),
        webLayout: (context) => MaterialsWebLayout(
          courseId: courseId,
        ),
      ),
    );
  }
}
