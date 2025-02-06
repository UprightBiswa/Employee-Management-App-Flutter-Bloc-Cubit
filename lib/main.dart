import 'package:employee_app/core/config/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/cubit/employee_cubit.dart';
import 'core/config/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!kIsWeb) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: MaterialApp.router(
          title: 'Employee App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
