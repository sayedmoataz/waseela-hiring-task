import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:waseela/core/errors/failure.dart';
import 'package:waseela/features/bnpl/domain/entities/installment_calc_result.dart';
import 'package:waseela/features/bnpl/domain/entities/installment_plan_entity.dart';
import 'package:waseela/features/bnpl/domain/repositories/bnpl_repository.dart';
import 'package:waseela/features/bnpl/domain/usecases/calculate_installment_usecase.dart';
import 'package:waseela/features/bnpl/presentation/bloc/installment/installment_bloc.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([BnplRepository])
@GenerateNiceMocks([
  MockSpec<CalculateInstallmentUseCase>(as: #MockCalculateInstallmentUseCase),
])
void main() {
  late MockBnplRepository mockRepository;
  late MockCalculateInstallmentUseCase mockCalculate;
  late InstallmentBloc bloc;

  const tPlanSmall = InstallmentPlanEntity(
    months: 3,
    label: '3 Months',
    interestRate: 0.0,
    processingFee: 0.0,
  );

  const tPlanMedium = InstallmentPlanEntity(
    months: 6,
    label: '6 Months',
    interestRate: 0.0,
    processingFee: 0.0,
  );

  const tPlanLarge = InstallmentPlanEntity(
    months: 12,
    label: '12 Months',
    interestRate: 0.1,
    processingFee: 50.0,
  );

  const tAllPlans = [tPlanSmall, tPlanMedium, tPlanLarge];

  const tServerFailure = ServerFailure(message: 'Server error');

  const tFakeCalcResult = InstallmentCalculationResult(
    monthlyInstallment: 333.33,
    totalAmount: 1000.0,
    totalFees: 0.0,
    repaymentSchedule: [],
  );

  setUp(() {
    mockRepository = MockBnplRepository();
    mockCalculate = MockCalculateInstallmentUseCase();
    bloc = InstallmentBloc(mockRepository, mockCalculate);
  });

  tearDown(() => bloc.close());

  // Initial State
  test('initial state should be InstallmentInitial', () {
    expect(bloc.state, const InstallmentInitial());
  });

  // InstallmentPlansRequested
  group('InstallmentPlansRequested', () {
    group('Repository failure', () {
      blocTest<InstallmentBloc, InstallmentState>(
        'emits [Loading, Error] when repository fails',
        build: () {
          when(
            mockRepository.getInstallmentPlans(),
          ).thenAnswer((_) async => const Left(tServerFailure));
          return bloc;
        },
        act: (bloc) => bloc.add(const InstallmentPlansRequested()),
        expect: () => [
          const InstallmentLoading(),
          const InstallmentError('Server error'),
        ],
        verify: (_) {
          verify(mockRepository.getInstallmentPlans()).called(1);
          verifyNever(mockCalculate.call(any));
        },
      );
    });

    group('productPrice = 0 (no product selected)', () {
      blocTest<InstallmentBloc, InstallmentState>(
        'emits [Loading, Loaded] with all plans and empty monthlyAmounts',
        build: () {
          when(
            mockRepository.getInstallmentPlans(),
          ).thenAnswer((_) async => const Right(tAllPlans));
          return bloc;
        },
        act: (bloc) => bloc.add(const InstallmentPlansRequested()),
        expect: () => [
          const InstallmentLoading(),
          isA<InstallmentLoaded>()
              .having((s) => s.plans, 'plans', tAllPlans)
              .having((s) => s.planMonthlyAmounts, 'monthlyAmounts', isEmpty),
        ],
        verify: (_) {
          verifyNever(mockCalculate.call(any));
        },
      );
    });

    group('planMonthlyAmounts calculation', () {
      blocTest<InstallmentBloc, InstallmentState>(
        'populates planMonthlyAmounts for each eligible plan',
        build: () {
          when(
            mockRepository.getInstallmentPlans(),
          ).thenAnswer((_) async => const Right(tAllPlans));
          when(
            mockCalculate.call(any),
          ).thenAnswer((_) async => const Right(tFakeCalcResult));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(const InstallmentPlansRequested(productPrice: 1000.0)),
        expect: () => [
          const InstallmentLoading(),
          isA<InstallmentLoaded>().having(
            (s) => s.planMonthlyAmounts.isNotEmpty,
            'monthlyAmounts populated',
            isTrue,
          ),
        ],
        verify: (_) {
          verify(mockCalculate.call(any)).called(3);
        },
      );
    });
  });

  // InstallmentPlanSelected
  group('InstallmentPlanSelected', () {
    blocTest<InstallmentBloc, InstallmentState>(
      'emits updated InstallmentLoaded with full calculation result',
      build: () {
        when(
          mockCalculate.call(any),
        ).thenAnswer((_) async => const Right(tFakeCalcResult));
        return bloc;
      },
      seed: () => const InstallmentLoaded(
        plans: tAllPlans,
        monthlyInstallment: 0,
        totalAmount: 0,
        totalFees: 0,
        repaymentSchedule: [],
        planMonthlyAmounts: {},
      ),
      act: (bloc) => bloc.add(
        const InstallmentPlanSelected(plan: tPlanSmall, productPrice: 1000.0),
      ),
      expect: () => [
        isA<InstallmentLoaded>()
            .having((s) => s.selectedPlan, 'selectedPlan', tPlanSmall)
            .having((s) => s.monthlyInstallment, 'monthlyInstallment', 333.33)
            .having((s) => s.totalAmount, 'totalAmount', 1000.0)
            .having((s) => s.totalFees, 'totalFees', 0.0),
      ],
    );

    blocTest<InstallmentBloc, InstallmentState>(
      'updates planMonthlyAmounts map when plan is selected',
      build: () {
        when(
          mockCalculate.call(any),
        ).thenAnswer((_) async => const Right(tFakeCalcResult));
        return bloc;
      },
      seed: () => const InstallmentLoaded(
        plans: tAllPlans,
        monthlyInstallment: 0,
        totalAmount: 0,
        totalFees: 0,
        repaymentSchedule: [],
        planMonthlyAmounts: {},
      ),
      act: (bloc) => bloc.add(
        const InstallmentPlanSelected(plan: tPlanSmall, productPrice: 1000.0),
      ),
      expect: () => [
        isA<InstallmentLoaded>().having(
          (s) => s.planMonthlyAmounts['3 Months'],
          'plan monthly amount updated',
          333.33,
        ),
      ],
    );

    blocTest<InstallmentBloc, InstallmentState>(
      'emits InstallmentError when calculation fails',
      build: () {
        when(
          mockCalculate.call(any),
        ).thenAnswer((_) async => const Left(tServerFailure));
        return bloc;
      },
      seed: () => const InstallmentLoaded(
        plans: tAllPlans,
        monthlyInstallment: 0,
        totalAmount: 0,
        totalFees: 0,
        repaymentSchedule: [],
        planMonthlyAmounts: {},
      ),
      act: (bloc) => bloc.add(
        const InstallmentPlanSelected(plan: tPlanSmall, productPrice: 1000.0),
      ),
      expect: () => [const InstallmentError('Server error')],
    );

    blocTest<InstallmentBloc, InstallmentState>(
      'does nothing when plan selected outside InstallmentLoaded state',
      build: () => bloc,
      seed: () => const InstallmentInitial(),
      act: (bloc) => bloc.add(
        const InstallmentPlanSelected(plan: tPlanSmall, productPrice: 1000.0),
      ),
      expect: () => [],
      verify: (_) {
        verifyNever(mockCalculate.call(any));
        verifyNever(mockRepository.getInstallmentPlans());
      },
    );

    blocTest<InstallmentBloc, InstallmentState>(
      'updates selectedPlan when a different plan is selected',
      build: () {
        when(
          mockCalculate.call(any),
        ).thenAnswer((_) async => const Right(tFakeCalcResult));
        return bloc;
      },
      seed: () => const InstallmentLoaded(
        plans: tAllPlans,
        selectedPlan: tPlanSmall,
        monthlyInstallment: 333.33,
        totalAmount: 1000.0,
        totalFees: 0.0,
        repaymentSchedule: [],
        planMonthlyAmounts: {'3 Months': 333.33},
      ),
      act: (bloc) => bloc.add(
        const InstallmentPlanSelected(plan: tPlanMedium, productPrice: 1000.0),
      ),
      expect: () => [
        isA<InstallmentLoaded>().having(
          (s) => s.selectedPlan,
          'selectedPlan',
          tPlanMedium,
        ),
      ],
    );

    blocTest<InstallmentBloc, InstallmentState>(
      'emits nothing when same plan is selected again — Equatable deduplication',
      build: () {
        when(
          mockCalculate.call(any),
        ).thenAnswer((_) async => const Right(tFakeCalcResult));
        return bloc;
      },
      seed: () => const InstallmentLoaded(
        plans: tAllPlans,
        selectedPlan: tPlanSmall,
        monthlyInstallment: 333.33,
        totalAmount: 1000.0,
        totalFees: 0.0,
        repaymentSchedule: [],
        planMonthlyAmounts: {'3 Months': 333.33},
      ),
      act: (bloc) => bloc.add(
        const InstallmentPlanSelected(plan: tPlanSmall, productPrice: 1000.0),
      ),
      expect: () => [],
    );
  });
}
