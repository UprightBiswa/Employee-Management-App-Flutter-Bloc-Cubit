import 'package:employee_app/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/add_employee_page.dart';
import '../../presentation/pages/employee_list_page.dart';
import '../models/employee_model.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/list',
      builder: (context, state) => const EmployeeListPage(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => AddEditEmployeePage(
        employee: state.extra as Employee?,
      ),
    ),
  ],
);
