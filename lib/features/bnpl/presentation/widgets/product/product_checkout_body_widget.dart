import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/installment_plan_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../bloc/installment/installment_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import 'installment_preview_section_widget.dart';
import 'product_card.dart';

class ProductCheckoutBodyWidget extends StatefulWidget {
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;

  const ProductCheckoutBodyWidget({
    required this.products,
    this.selectedProduct,
    super.key,
  });

  @override
  State<ProductCheckoutBodyWidget> createState() =>
      _ProductCheckoutBodyWidgetState();
}

class _ProductCheckoutBodyWidgetState extends State<ProductCheckoutBodyWidget> {
  int _selectedMonths = 6;

  @override
  void didUpdateWidget(ProductCheckoutBodyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedProduct?.id != widget.selectedProduct?.id) {
      setState(() => _selectedMonths = 6);
      final product = widget.selectedProduct;
      if (product != null) {
        final state = context.read<InstallmentBloc>().state;
        if (state is InstallmentLoaded) {
          final plan = state.plans.cast<InstallmentPlanEntity>().firstWhere(
            (p) => p.months == 6,
            orElse: () => state.plans.first,
          );
          context.read<InstallmentBloc>().add(
            InstallmentPlanSelected(plan: plan, productPrice: product.price),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final hPadding = info.horizontalPadding();
        final vSpacing = info.spacing(ResponsiveSpacing.md);

        return BlocBuilder<InstallmentBloc, InstallmentState>(
          builder: (context, installmentState) {
            final allPlans = installmentState is InstallmentLoaded
                ? installmentState.plans
                : <InstallmentPlanEntity>[];
            final uniqueMapByMonth = <int, InstallmentPlanEntity>{};
            for (final p in allPlans) {
              if (p.months > 0) {
                uniqueMapByMonth.putIfAbsent(p.months, () => p);
              }
            }
            final plans = uniqueMapByMonth.values.toList()
              ..sort((a, b) => a.months.compareTo(b.months));

            final monthlyAmount = installmentState is InstallmentLoaded
                ? installmentState.monthlyInstallment
                : 0.0;
            final totalAmount = installmentState is InstallmentLoaded
                ? installmentState.totalAmount
                : 0.0;
            final totalFees = installmentState is InstallmentLoaded
                ? installmentState.totalFees
                : 0.0;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: hPadding,
                vertical: vSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.products.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                    itemBuilder: (context, index) {
                      final product = widget.products[index];
                      final isSelected =
                          widget.selectedProduct?.id == product.id;

                      return Column(
                        children: [
                          ProductCard(
                            product: product,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<ProductBloc>().add(
                                ProductSelected(product),
                              );
                              if (installmentState is InstallmentLoaded) {
                                final plan = plans
                                    .cast<InstallmentPlanEntity>()
                                    .firstWhere(
                                      (p) => p.months == _selectedMonths,
                                      orElse: () => plans.first,
                                    );
                                context.read<InstallmentBloc>().add(
                                  InstallmentPlanSelected(
                                    plan: plan,
                                    productPrice: product.price,
                                  ),
                                );
                              }
                            },
                          ),
                          if (isSelected && plans.isNotEmpty) ...[
                            SizedBox(
                              height: info.spacing(ResponsiveSpacing.sm),
                            ),
                            InstallmentPreviewSection(
                              plans: plans,
                              info: info,
                              selectedMonths: _selectedMonths,
                              monthlyAmount: monthlyAmount,
                              totalAmount: totalAmount,
                              totalFees: totalFees,
                              onPlanSelected: (months) {
                                setState(() => _selectedMonths = months);
                                final selectedPlan = plans.firstWhere(
                                  (p) => p.months == months,
                                );
                                context.read<InstallmentBloc>().add(
                                  InstallmentPlanSelected(
                                    plan: selectedPlan,
                                    productPrice: product.price,
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
