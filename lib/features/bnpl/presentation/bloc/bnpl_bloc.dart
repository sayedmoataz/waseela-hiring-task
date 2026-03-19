import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bnpl_event.dart';
part 'bnpl_state.dart';

class BnplBloc extends Bloc<BnplEvent, BnplState> {
  BnplBloc() : super(BnplInitial()) {
    on<BnplEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
