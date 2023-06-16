import 'package:clean_architecture_tdd_course/global/shared/bloc/network_bloc.dart';
import 'package:clean_architecture_tdd_course/global/shared/bloc/network_state.dart';
import 'package:clean_architecture_tdd_course/main/app_env.dart';

import '../../domain/entities/user.dart';
import '../bloc/user_listing_bloc.dart';
import '../bloc/user_listing_event.dart';
import '../bloc/user_listing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class UserListingPage extends StatefulWidget {
  const UserListingPage({super.key});

  @override
  State<UserListingPage> createState() => _UserListingPageState();
}

class _UserListingPageState extends State<UserListingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EnvInfo.appName),
      ),
      body: BlocListener<NetworkBloc, NetworkState>(
        listener: (context, state) {
          if (state is NetworkGainedState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Conntected')));
          } else if (state is NetworkLostState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Disconnected'),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<UserListingBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserListingBloc>(),
      child: Column(
        children: [
          BlocBuilder<UserListingBloc, UserListingState>(
            builder: (context, state) {
              if (state is Empty) {
                context.read<UserListingBloc>().add(GetUserListEvent());

                return Container();
              }
              if (state is Loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ListLoaded) {
                return ListView.builder(
                  itemCount: state.userList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    List<User> userList = state.userList;

                    return ListTile(
                      leading: PhysicalModel(
                        color: Colors.red.shade200,
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          '${userList[index].avatar}',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      dense: false,
                      title: Text(
                        '${userList[index].firstName} ${userList[index].lastName}',
                      ),
                      subtitle: Text(
                        '${userList[index].email}',
                      ),
                      trailing: Text(
                        '${userList[index].id}',
                      ),
                    );
                  },
                );
              } else if (state is Error) {
                return Text(state.message);
              } else {
                return Text('No Loaded BLOC');
              }
            },
          ),
          ElevatedButton(onPressed: () {}, child: Text('Hi'))
        ],
      ),
      // Column(
      //   children: [
      //     SizedBox(
      //       height: 50,
      //     ),
      //     Center(
      //       child: BlocBuilder<UserListingBloc, UserListingState>(
      //         builder: (context, state) {
      //           if (state is Empty) {
      //             BlocProvider.of<UserListingBloc>(context)
      //                 .add(GetSingleUserByNumberEvent(2));
      //             return Container();
      //           }
      //           if (state is Loading) {
      //             return CircularProgressIndicator();
      //           } else if (state is Loaded) {
      //             return Column(
      //               children: [
      //                 Text(state.user.firstName.toString()),
      //                 Text(state.user.lastName.toString()),
      //               ],
      //             );
      //           } else if (state is Error) {
      //             return Text(state.message);
      //           } else {
      //             return Text('No Loaded BLOC');
      //           }
      //         },
      //       ),
      //     ),
      //     SizedBox(
      //       height: 50,
      //     ),
      // ,
      //   ],
      // ),
    );
  }
}
