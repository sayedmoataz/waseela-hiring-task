import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../entities/order_param.dart';
import '../repositories/bnpl_repository.dart';

@injectable
class CreateOrderUseCase implements UseCase<OrderEntity, CreateOrderParams> {
  final BnplRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) {
    return repository.createOrder(
      productId: params.productId,
      planId: params.planId,
      totalAmount: params.totalAmount,
      monthlyInstallment: params.monthlyInstallment,
    );
  }
}
