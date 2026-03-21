import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../../core/services/navigation/navigation_extensions.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_toast/custom_toast.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../bloc/order/order_bloc.dart';
import '../product/product_card.dart';
import 'order_status_icon.dart';
import 'order_summary_card.dart';

class OrderConfirmationWidget extends StatefulWidget {
  final ProductEntity? product;
  final String planId;
  final double monthlyInstallment;
  final double totalAmount;

  const OrderConfirmationWidget({
    required this.product,
    required this.planId,
    required this.monthlyInstallment,
    required this.totalAmount,
    super.key,
  });

  @override
  State<OrderConfirmationWidget> createState() =>
      _OrderConfirmationWidgetState();
}

class _OrderConfirmationWidgetState extends State<OrderConfirmationWidget> {
  OverlayEntry? _loadingToast;

  void _dismissLoadingToast() {
    if (_loadingToast != null) {
      _loadingToast!.remove();
      _loadingToast = null;
    }
  }

  OrderStatus? _mapStatus(OrderState state) {
    if (state is OrderSuccess) {
      return state.status;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderLoading) {
          _loadingToast = CustomToast.loading(
            context,
            message: AppStrings.processingYourOrder,
          );
        } else if (state is OrderSuccess) {
          _dismissLoadingToast();
          if (state.status == OrderStatus.approved) {
            CustomToast.success(context, AppStrings.orderConfirmed);
          } else {
            CustomToast.info(context, AppStrings.orderPendingApproval);
          }
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              context.read<OrderBloc>().add(const OrderReset());
              context.navigateAndRemoveUntil(Routes.productCheckout);
            }
          });
        } else if (state is OrderFailure) {
          _dismissLoadingToast();
          CustomToast.error(context, state.message);
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text(AppStrings.orderConfirmation),
          centerTitle: true,
        ),
        body: ResponsiveBuilder(
          builder: (context, info) {
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: info.horizontalPadding(),
                  vertical: info.spacing(ResponsiveSpacing.lg),
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: info.contentMaxWidth()),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        label:
                            'Product: ${widget.product!.name}, price: EGP ${widget.product!.price.toStringAsFixed(2)}',
                        child: ProductCard(product: widget.product!),
                      ),
                      SizedBox(height: info.spacing(ResponsiveSpacing.xl)),
                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, state) {
                          return OrderStatusIcon(status: _mapStatus(state));
                        },
                      ),
                      SizedBox(height: info.spacing(ResponsiveSpacing.xl)),
                      OrderSummaryCard(
                        monthlyInstallment: widget.monthlyInstallment,
                        totalAmount: widget.totalAmount,
                      ),
                      SizedBox(height: info.spacing(ResponsiveSpacing.xxl)),
                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, state) {
                          return Semantics(
                            label: state is OrderLoading
                                ? 'Processing your order, please wait'
                                : 'Confirm order with biometric authentication',
                            button: true,
                            enabled: state is! OrderSuccess,
                            child: CustomButton(
                              text: AppStrings.confirmWithBiometric,
                              textColor: AppColors.white,
                              isLoading: state is OrderLoading,
                              isEnabled: state is! OrderSuccess,
                              onPressed: () {
                                context.read<OrderBloc>().add(
                                  OrderSubmitted(
                                    productId: widget.product!.id,
                                    planId: widget.planId,
                                    totalAmount: widget.totalAmount,
                                    monthlyInstallment:
                                        widget.monthlyInstallment,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dismissLoadingToast();
    super.dispose();
  }
}
