part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;

  const ProductLoaded({required this.products, this.selectedProduct});

  static const _sentinel = Object();

  ProductLoaded copyWith({
    List<ProductEntity>? products,
    Object? selectedProduct = _sentinel,
  }) => ProductLoaded(
    products: products ?? this.products,
    selectedProduct: identical(selectedProduct, _sentinel)
        ? this.selectedProduct
        : selectedProduct as ProductEntity?,
  );

  @override
  List<Object?> get props => [products, selectedProduct];
}

final class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ProductEmptyState extends ProductState {
  const ProductEmptyState();

  @override
  List<Object?> get props => [];
}
