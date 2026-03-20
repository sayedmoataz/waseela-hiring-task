import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/bnpl_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final BnplRepository _repository;

  ProductBloc(this._repository) : super(const ProductInitial()) {
    on<ProductFetched>(_onProductFetched);
    on<ProductSelected>(_onProductSelected);
  }

  Future<void> _onProductFetched(
    ProductFetched event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _repository.getProducts();

    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        if (products.isEmpty) {
          emit(const ProductEmptyState());
        } else {
          emit(ProductLoaded(products: products));
        }
      },
    );
  }

  void _onProductSelected(
    ProductSelected event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      emit((state as ProductLoaded).copyWith(
        selectedProduct: event.product,
      ));
    }
  }
}
