import 'package:clean_architecture_tdd_course/features/user_listing/presentation/pages/user_listing_page.dart';
import 'package:clean_architecture_tdd_course/global/shared/bloc/network_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkBloc(),
      child: MaterialApp(
        home: UserListingPage(),
      ),
    );
  }
}
