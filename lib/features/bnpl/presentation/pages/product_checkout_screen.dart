import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../bloc/installment/installment_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../widgets/product/checkout_floating_button.dart';
import '../widgets/product/product_checkout_widget.dart';

class ProductCheckoutScreen extends StatelessWidget {
  const ProductCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProductBloc>()..add(const ProductFetched()),
        ),

        BlocProvider(
          create: (_) =>
              sl<InstallmentBloc>()..add(const InstallmentPlansRequested()),
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text(AppStrings.checkout),
          centerTitle: true,
          leading: SizedBox.shrink(),
          leadingWidth: 0,
        ),
        body: const ProductCheckoutWidget(),
        bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, productState) {
            final selectedProduct = productState is ProductLoaded
                ? productState.selectedProduct
                : null;

            return BlocBuilder<InstallmentBloc, InstallmentState>(
              builder: (context, installmentState) {
                final selectedMonths = installmentState is InstallmentLoaded
                    ? (installmentState.selectedPlan?.months ?? 6)
                    : 6;

                return selectedProduct == null
                    ? const SizedBox.shrink()
                    : CheckoutFloatingButton(
                        selectedProduct: selectedProduct,
                        selectedMonths: selectedMonths,
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
