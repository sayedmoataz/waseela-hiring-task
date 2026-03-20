part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class ProductFetched extends ProductEvent {
  const ProductFetched();
}

final class ProductSelected extends ProductEvent {
  final ProductEntity product;
  const ProductSelected(this.product);

  @override
  List<Object?> get props => [product];
}
