part of 'bnpl_bloc.dart';

abstract class BnplState extends Equatable {
  const BnplState();  

  @override
  List<Object> get props => [];
}
class BnplInitial extends BnplState {}
