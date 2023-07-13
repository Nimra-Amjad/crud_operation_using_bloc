import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/user_model.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc() : super(UserListInitial(users: [])) {
    on<AddUser>(_addUser);
    on<DeleteUser>(_deleteUser);
    on<UpdateUser>(_updateUser);
  }

  _addUser(AddUser event, Emitter<UserListState> emit) {
    state.users.add(event.user);
    emit(UserListUpdated(users: state.users));
  }

  _deleteUser(DeleteUser event, Emitter<UserListState> emit) {
    state.users.remove(event.user);
    emit(UserListUpdated(users: state.users));
  }

  _updateUser(UpdateUser event, Emitter<UserListState> emit) {
    for (int i = 0; i < state.users.length; i++) {
      if (event.user.id == state.users[i].id) {
        state.users[i] = event.user;
      }
    }
    emit(UserListUpdated(users: state.users));
  }
}
