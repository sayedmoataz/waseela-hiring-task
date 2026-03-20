import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/crashlytics/crashlytics_logger.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculations_param.dart';
import '../entities/installment_calc_result.dart';
import '../entities/repayment_schedule_entry.dart';

@injectable
class CalculateInstallmentUseCase
    implements UseCase<InstallmentCalculationResult, CalculateParams> {
  @override
  Future<Either<Failure, InstallmentCalculationResult>> call(
    CalculateParams params,
  ) async {
    try {
      final totalInterest = params.price * params.plan.interestRate;
      final totalAmount =
          params.price + totalInterest + params.plan.processingFee;
      final monthly = totalAmount / params.plan.months;

      final schedule = List.generate(params.plan.months, (index) {
        final dueDate = DateTime(
          params.startDate.year,
          params.startDate.month + index + 1,
          params.startDate.day,
        );
        return RepaymentScheduleEntry(
          installmentNumber: index + 1,
          dueDate: dueDate,
          amount: monthly,
        );
      });

      return Right(
        InstallmentCalculationResult(
          monthlyInstallment: monthly,
          totalAmount: totalAmount,
          totalFees: totalInterest + params.plan.processingFee,
          repaymentSchedule: schedule,
        ),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(e, stackTrace, feature: 'bnpl');
      return Left(ErrorHandler.handle(e, stackTrace: stackTrace));
    }
  }
}
