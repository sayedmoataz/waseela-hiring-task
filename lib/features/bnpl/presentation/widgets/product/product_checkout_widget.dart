import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_toast/custom_toast.dart';
import '../../bloc/product/product_bloc.dart';
import 'product_checkout_body_widget.dart';
import 'product_checkout_shimmer.dart';
import 'product_empty_widget.dart';
import 'product_error_widget.dart';

class ProductCheckoutWidget extends StatelessWidget {
  const ProductCheckoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductError) {
          CustomToast.error(context, state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => const ProductCheckoutShimmer(),
          ProductInitial() => const ProductCheckoutShimmer(),
          ProductLoaded(:final products, :final selectedProduct) =>
            ProductCheckoutBodyWidget(
              products: products,
              selectedProduct: selectedProduct,
            ),
          ProductError(:final message) => ProductErrorWidget(message: message),
          ProductEmptyState() => const ProductEmptyWidget(),
        };
      },
    );
  }
}
