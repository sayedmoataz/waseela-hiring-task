part of 'installment_bloc.dart';

sealed class InstallmentEvent extends Equatable {
  const InstallmentEvent();

  @override
  List<Object?> get props => [];
}

final class InstallmentPlansRequested extends InstallmentEvent {
  final double productPrice;

  const InstallmentPlansRequested({this.productPrice = 0});

  @override
  List<Object?> get props => [productPrice];
}

final class InstallmentPlanSelected extends InstallmentEvent {
  final InstallmentPlanEntity plan;
  final double productPrice;

  const InstallmentPlanSelected({
    required this.plan,
    required this.productPrice,
  });

  @override
  List<Object?> get props => [plan, productPrice];
}
