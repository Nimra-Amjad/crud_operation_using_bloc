import 'package:crud_app_using_bloc/bloc/user_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/user_model.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
            final state = context.read<UserListBloc>().state;
            final id = state.users.length + 1;
            showBottomSheet(context: context, id: id);
          },
          child: Text("Add User")),
      appBar: AppBar(
        title: Text('CRUD using BloC'),
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state is UserListUpdated && state.users.isNotEmpty) {
            final users = state.users;
            return ListView.builder(itemBuilder: (context, index) {
              final user = users[index];
              return buildUserTile(context, user);
            });
          } else {
            return const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text("No user found"),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildUserTile(BuildContext context, User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                context.read<UserListBloc>()..add(DeleteUser(user: user));
              },
              icon: Icon(Icons.delete)),
          IconButton(
              onPressed: () {
                name.text = user.name;
                email.text = user.email;
                showBottomSheet(context: context, id: user.id, isEdit: true);
              },
              icon: Icon(Icons.edit)),
        ],
      ),
    );
  }

  showBottomSheet(
          {required BuildContext context,
          bool isEdit = false,
          required int id}) =>
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  buildTextField(controller: name, hint: "Enter name"),
                  buildTextField(controller: email, hint: "Enter email"),
                  ElevatedButton(
                      onPressed: () {
                        final user =
                            User(id: id, name: name.text, email: email.text);
                        if (isEdit) {
                          context.read<UserListBloc>()
                            ..add(UpdateUser(user: user));
                        } else {
                          context.read<UserListBloc>()
                            ..add(AddUser(user: user));
                        }
                        Navigator.pop(context);
                      },
                      child: Text("Update"))
                ],
              ),
            );
          });

  static Widget buildTextField(
          {required TextEditingController controller, required String hint}) =>
      Padding(
        padding: EdgeInsets.all(12.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
        ),
      );
}
