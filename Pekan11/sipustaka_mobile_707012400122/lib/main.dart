import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/app_theme.dart';
import 'cubits/auth_cubit.dart';
import 'cubits/auth_state.dart';
import 'cubits/book_cubit.dart';
import 'cubits/book_state.dart';
import 'cubits/loan_cubit.dart';
import 'cubits/loan_state.dart';
import 'pages/home_page.dart';
import 'services/api_service.dart';
import 'utils/helpers.dart';

void main() {
  runApp(SiPustakaApp(api: ApiService()));
}

class SiPustakaApp extends StatelessWidget {
  final ApiService api;

  const SiPustakaApp({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(api)..checkLogin()),
        BlocProvider(create: (_) => BookCubit(api)..loadBooks()),
        BlocProvider(create: (_) => LoanCubit(api)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (prev, curr) =>
                curr.message != null || prev.user?.id != curr.user?.id,
            listener: (context, state) {
              if (state.message != null) {
                showMessage(state.message!, isError: state.isError);
              }
              if (state.isLoggedIn) {
                context.read<LoanCubit>().loadLoans();
              } else {
                context.read<LoanCubit>().clearLoans();
              }
            },
          ),
          BlocListener<BookCubit, BookState>(
            listenWhen: (_, curr) => curr.message != null,
            listener: (context, state) {
              showMessage(state.message!, isError: state.isError);
            },
          ),
          BlocListener<LoanCubit, LoanState>(
            listenWhen: (_, curr) => curr.message != null,
            listener: (context, state) {
              showMessage(state.message!, isError: state.isError);
            },
          ),
        ],
        child: MaterialApp(
          title: 'SiPustaka',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: messengerKey,
          theme: AppTheme.light,
          home: const HomePage(),
        ),
      ),
    );
  }
}
