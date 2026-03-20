import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/calculate_installment_usecase.dart';
import '../../../domain/entities/calculations_param.dart';
import '../../../domain/entities/installment_plan_entity.dart';
import '../../../domain/entities/repayment_schedule_entry.dart';
import '../../../domain/repositories/bnpl_repository.dart';

part 'installment_event.dart';
part 'installment_state.dart';

@injectable
class InstallmentBloc extends Bloc<InstallmentEvent, InstallmentState> {
  final BnplRepository _repository;
  final CalculateInstallmentUseCase _calculateInstallment;

  InstallmentBloc(this._repository, this._calculateInstallment)
      : super(const InstallmentInitial()) {
    on<InstallmentPlansRequested>(_onPlansRequested);
    on<InstallmentPlanSelected>(_onPlanSelected);
  }

  Future<void> _onPlansRequested(
    InstallmentPlansRequested event,
    Emitter<InstallmentState> emit,
  ) async {
    emit(const InstallmentLoading());
    final result = await _repository.getInstallmentPlans();

    await result.fold(
      (failure) async => emit(InstallmentError(failure.message)),
      (plans) async {
        final monthlyAmounts = <String, double>{};
        if (event.productPrice > 0) {
          for (final plan in plans) {
            final calcResult = await _calculateInstallment.call(
              CalculateParams(price: event.productPrice, plan: plan),
            );
            calcResult.fold(
              (_) => monthlyAmounts[plan.label] = 0,
              (calc) => monthlyAmounts[plan.label] = calc.monthlyInstallment,
            );
          }
        }

        emit(
          InstallmentLoaded(
            plans: plans,
            monthlyInstallment: 0,
            totalAmount: 0,
            totalFees: 0,
            repaymentSchedule: const [],
            planMonthlyAmounts: monthlyAmounts,
          ),
        );
      },
    );
  }

  Future<void> _onPlanSelected(
    InstallmentPlanSelected event,
    Emitter<InstallmentState> emit,
  ) async {
    if (state is InstallmentLoaded) {
      final currentState = state as InstallmentLoaded;

      final result = await _calculateInstallment.call(
        CalculateParams(price: event.productPrice, plan: event.plan),
      );

      result.fold(
        (failure) => emit(InstallmentError(failure.message)),
        (calculation) => emit(
          currentState.copyWith(
            selectedPlan: event.plan,
            monthlyInstallment: calculation.monthlyInstallment,
            totalAmount: calculation.totalAmount,
            totalFees: calculation.totalFees,
            repaymentSchedule: calculation.repaymentSchedule,
            planMonthlyAmounts: {
              ...currentState.planMonthlyAmounts,
              event.plan.label: calculation.monthlyInstallment,
            },
          ),
        ),
      );
    }
  }
}
