part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {
  const OrderInitial();
}

final class OrderLoading extends OrderState {
  const OrderLoading();
}

final class OrderSuccess extends OrderState {
  final OrderStatus status;

  const OrderSuccess({required this.status});

  @override
  List<Object?> get props => [status];
}

final class OrderFailure extends OrderState {
  final String message;

  const OrderFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
