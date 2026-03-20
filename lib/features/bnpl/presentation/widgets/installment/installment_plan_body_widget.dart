import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../../core/services/navigation/navigation_extensions.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/typography.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../domain/entities/installment_plan_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../bloc/installment/installment_bloc.dart';
import 'installment_plan_card.dart';
import 'repayment_schedule_widget.dart';
import 'selected_plan_summary_widget.dart';

class InstallmentPlanBody extends StatefulWidget {
  final InstallmentLoaded state;
  final ProductEntity product;
  final int initialSelectedMonths;

  const InstallmentPlanBody({
    required this.state,
    required this.product,
    required this.initialSelectedMonths,
    super.key,
  });

  @override
  State<InstallmentPlanBody> createState() => _InstallmentPlanBodyState();
}

class _InstallmentPlanBodyState extends State<InstallmentPlanBody> {
  @override
  void initState() {
    super.initState();
    if (widget.state.selectedPlan == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final plans = widget.state.plans;
        final plan = plans.any((p) => p.months == widget.initialSelectedMonths)
            ? plans.firstWhere((p) => p.months == widget.initialSelectedMonths)
            : plans.first;
        context.read<InstallmentBloc>().add(
          InstallmentPlanSelected(
            plan: plan,
            productPrice: widget.product.price,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstallmentBloc, InstallmentState>(
      builder: (context, blocState) {
        final state = blocState is InstallmentLoaded ? blocState : widget.state;
        final product = widget.product;

        return ResponsiveBuilder(
          builder: (context, info) {
            final hPadding = info.horizontalPadding();
            final vSpacing = info.spacing(ResponsiveSpacing.md);
            final lgSpacing = info.spacing(ResponsiveSpacing.lg);

            final allPlans = state.plans;
            final uniqueMapByMonth = <int, InstallmentPlanEntity>{};
            for (final p in allPlans) {
              if (p.months > 0) {
                uniqueMapByMonth.putIfAbsent(p.months, () => p);
              }
            }
            final plans = uniqueMapByMonth.values.toList()
              ..sort((a, b) => a.months.compareTo(b.months));

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding,
                vertical: vSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.payLaterWithInstallments,
                    style: AppTypography.h4.copyWith(
                      fontSize: info.responsiveFontSize(18),
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                  Text(
                    AppStrings.selectAPlanThatWorksForYou,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: info.responsiveFontSize(14),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: lgSpacing),
                  Column(
                    children: plans.map((plan) {
                      final isSelected =
                          state.selectedPlan?.label == plan.label;
                      final monthlyAmount =
                          state.planMonthlyAmounts[plan.label] ?? 0.0;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: info.spacing(ResponsiveSpacing.md),
                        ),
                        child: InstallmentPlanCard(
                          plan: plan,
                          isSelected: isSelected,
                          monthlyAmount: monthlyAmount,
                          onTap: () => context.read<InstallmentBloc>().add(
                            InstallmentPlanSelected(
                              plan: plan,
                              productPrice: product.price,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (state.selectedPlan != null) ...[
                    SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                    SelectedPlanSummary(
                      months: state.selectedPlan!.months,
                      monthlyAmount: state.monthlyInstallment,
                      totalPrice: state.totalAmount,
                      info: info,
                    ),
                  ],

                  if (state.repaymentSchedule.isNotEmpty) ...[
                    SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                    RepaymentScheduleWidget(
                      schedule: state.repaymentSchedule,
                      info: info,
                    ),
                  ],

                  SizedBox(height: lgSpacing),
                  CustomButton(
                    text: AppStrings.confirmPlan,
                    textColor: AppColors.white,
                    isEnabled: state.selectedPlan != null,
                    onPressed: () {
                      if (state.selectedPlan == null) return;
                      context.navigateTo(
                        Routes.orderConfirmation,
                        arguments: {
                          RouteArguments.product: product,
                          RouteArguments.planId: state.selectedPlan!.label,
                          RouteArguments.monthlyInstallment:
                              state.monthlyInstallment,
                          RouteArguments.totalAmount: state.totalAmount,
                        },
                      );
                    },
                  ),
                  SizedBox(height: vSpacing),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
