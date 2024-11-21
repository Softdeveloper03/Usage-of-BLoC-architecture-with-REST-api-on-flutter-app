// Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frnt/model/model.dart';
import 'package:frnt/repository/repository.dart';

abstract class NameEvent {}

class FetchNames extends NameEvent {}

class CreateName extends NameEvent {
  final String name;
  CreateName(this.name);
}

class UpdateName extends NameEvent {
  final int id;
  final String name;
  UpdateName(this.id, this.name);
}

class DeleteName extends NameEvent {
  final int id;
  DeleteName(this.id);
}

// States
abstract class NameState {}

class NameInitial extends NameState {}

class NameLoading extends NameState {}

class NameLoaded extends NameState {
  final List<NameModel> names;
  NameLoaded(this.names);
}

class NameError extends NameState {
  final String message;
  NameError(this.message);
}

// Bloc
class NameBloc extends Bloc<NameEvent, NameState> {
  final NameRepository repository;

  NameBloc(this.repository) : super(NameInitial()) {
    on<FetchNames>((event, emit) async {
      emit(NameLoading());
      try {
        final names = await repository.fetchNames();
        emit(NameLoaded(names));
      } catch (e) {
        emit(NameError(e.toString()));
      }
    });

    on<CreateName>((event, emit) async {
      try {
        await repository.createName(event.name);
        add(FetchNames());
      } catch (e) {
        emit(NameError(e.toString()));
      }
    });

    on<UpdateName>((event, emit) async {
      try {
        await repository.updateName(event.id, event.name);
        add(FetchNames());
      } catch (e) {
        emit(NameError(e.toString()));
      }
    });

    on<DeleteName>((event, emit) async {
      try {
        await repository.deleteName(event.id);
        add(FetchNames());
      } catch (e) {
        emit(NameError(e.toString()));
      }
    });
  }
}
