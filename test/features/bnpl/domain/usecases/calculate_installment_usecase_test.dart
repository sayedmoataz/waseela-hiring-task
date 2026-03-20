import 'package:flutter_test/flutter_test.dart';
import 'package:waseela/features/bnpl/domain/entities/calculations_param.dart';
import 'package:waseela/features/bnpl/domain/entities/installment_plan_entity.dart';
import 'package:waseela/features/bnpl/domain/usecases/calculate_installment_usecase.dart';

void main() {
  late CalculateInstallmentUseCase useCase;

  const zeroFeePlan = InstallmentPlanEntity(
    months: 6,
    label: '6 Months',
    interestRate: 0.0,
    processingFee: 0.0,
  );

  const withInterestPlan = InstallmentPlanEntity(
    months: 12,
    label: '12 Months',
    interestRate: 0.1,
    processingFee: 50.0,
  );

  const threemonthPlan = InstallmentPlanEntity(
    months: 3,
    label: '3 Months',
    interestRate: 0.05,
    processingFee: 20.0,
  );

  setUp(() {
    useCase = CalculateInstallmentUseCase();
  });

  group('CalculateInstallmentUseCase', () {
    // Happy Path

    test(
      'should return correct monthly installment with zero interest and fees',
      () async {
        final params = CalculateParams(price: 1200.0, plan: zeroFeePlan);
        final result = await useCase.call(params);
        expect(result.isRight(), isTrue);
        final calculation = result.getOrElse(() => throw Exception());
        expect(calculation.monthlyInstallment, equals(200.0));
        expect(calculation.totalAmount, equals(1200.0));
        expect(calculation.totalFees, equals(0.0));
      },
    );

    test(
      'should return correct values with interest and processing fee',
      () async {
        final params = CalculateParams(price: 1000.0, plan: withInterestPlan);
        final result = await useCase.call(params);
        expect(result.isRight(), isTrue);
        final calculation = result.getOrElse(() => throw Exception());
        expect(calculation.totalFees, equals(150.0));
        expect(calculation.totalAmount, equals(1150.0));
        expect(calculation.monthlyInstallment, closeTo(95.83, 0.01));
      },
    );

    test('should return correct values for 3-month plan', () async {
      final params = CalculateParams(price: 600.0, plan: threemonthPlan);
      final result = await useCase.call(params);
      expect(result.isRight(), isTrue);
      final calculation = result.getOrElse(() => throw Exception());
      expect(calculation.totalAmount, equals(650.0));
      expect(calculation.monthlyInstallment, closeTo(216.67, 0.01));
    });

    // Repayment Schedule

    test(
      'should generate repayment schedule with correct number of entries',
      () async {
        final params = CalculateParams(price: 1200.0, plan: zeroFeePlan);
        final result = await useCase.call(params);
        final schedule = result
            .getOrElse(() => throw Exception())
            .repaymentSchedule;
        expect(schedule.length, equals(6));
      },
    );

    test(
      'should generate schedule with sequential installment numbers',
      () async {
        final params = CalculateParams(price: 1200.0, plan: zeroFeePlan);
        final result = await useCase.call(params);
        final schedule = result
            .getOrElse(() => throw Exception())
            .repaymentSchedule;
        for (int i = 0; i < schedule.length; i++) {
          expect(schedule[i].installmentNumber, equals(i + 1));
        }
      },
    );

    test(
      'should generate schedule with due dates exactly one month apart',
      () async {
        final startDate = DateTime(2026, 3, 20);
        final params = CalculateParams(
          price: 1200.0,
          plan: zeroFeePlan,
          startDate: startDate,
        );
        final result = await useCase.call(params);
        final schedule = result
            .getOrElse(() => throw Exception())
            .repaymentSchedule;
        expect(schedule[0].dueDate, equals(DateTime(2026, 4, 20)));
        expect(schedule[1].dueDate, equals(DateTime(2026, 5, 20)));
        expect(schedule[5].dueDate, equals(DateTime(2026, 9, 20)));
      },
    );

    test(
      'should generate valid schedule when startDate is not provided',
      () async {
        final before = DateTime.now();
        final params = CalculateParams(price: 1200.0, plan: zeroFeePlan);
        final result = await useCase.call(params);
        final schedule = result
            .getOrElse(() => throw Exception())
            .repaymentSchedule;
        expect(schedule.length, equals(6));
        expect(schedule.first.dueDate.isAfter(before), isTrue);
      },
    );

    test(
      'should generate schedule where all installments have equal amounts',
      () async {
        final params = CalculateParams(price: 1200.0, plan: zeroFeePlan);
        final result = await useCase.call(params);
        final amounts = result
            .getOrElse(() => throw Exception())
            .repaymentSchedule
            .map((e) => e.amount)
            .toSet();
        expect(amounts.length, equals(1));
        expect(amounts.first, equals(200.0));
      },
    );

    test('installment amounts should sum to totalAmount', () async {
      final params = CalculateParams(price: 1000.0, plan: withInterestPlan);
      final result = await useCase.call(params);
      final calculation = result.getOrElse(() => throw Exception());
      final sumOfInstallments = calculation.repaymentSchedule.fold(
        0.0,
        (sum, e) => sum + e.amount,
      );
      expect(sumOfInstallments, closeTo(calculation.totalAmount, 0.01));
    });

    // Edge Cases

    test('should return Right for zero price', () async {
      final params = CalculateParams(price: 0.0, plan: zeroFeePlan);
      final result = await useCase.call(params);
      expect(result.isRight(), isTrue);
      final calculation = result.getOrElse(() => throw Exception());
      expect(calculation.monthlyInstallment, equals(0.0));
      expect(calculation.totalAmount, equals(0.0));
    });

    test('should return Right on valid input', () async {
      final params = CalculateParams(price: 500.0, plan: withInterestPlan);
      final result = await useCase.call(params);
      expect(result.isRight(), isTrue);
    });
  });
}
