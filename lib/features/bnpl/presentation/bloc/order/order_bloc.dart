import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/services/services.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/order_param.dart';
import '../../../domain/repositories/bnpl_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final BnplRepository _repository;
  final BiometricConsumer _biometricConsumer;

  OrderBloc(this._repository, this._biometricConsumer)
    : super(const OrderInitial()) {
    on<OrderSubmitted>(_onOrderSubmitted);
    on<OrderReset>((event, emit) => emit(const OrderInitial()));
  }

  Future<void> _onOrderSubmitted(
    OrderSubmitted event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final isAvailable = await _biometricConsumer.isBiometricAvailable();
    final hasEnrolled = await _biometricConsumer.hasBiometricEnrolled();
    final canCheck = isAvailable.getOrElse(() => false);
    final isEnrolled = hasEnrolled.getOrElse(() => false);

    if (canCheck && isEnrolled) {
      final bioResult = await _biometricConsumer.authenticateWithBiometric(
        reason: AppStrings.confirmOrderWithBiometric,
      );

      final authenticated = bioResult.fold((_) => false, (success) => success);

      if (!authenticated) {
        emit(
          const OrderFailure(message: AppStrings.biometricAuthenticationFailed),
        );
        return;
      }
    }

    final result = await _repository.createOrder(
      params: CreateOrderParams(
        productId: event.productId,
        planId: event.planId,
        totalAmount: event.totalAmount,
        monthlyInstallment: event.monthlyInstallment,
      ),
    );

    result.fold(
      (failure) => emit(OrderFailure(message: failure.message)),
      (order) => emit(OrderSuccess(status: order.status)),
    );
  }
}
