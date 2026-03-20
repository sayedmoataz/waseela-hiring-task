import 'package:equatable/equatable.dart';

class RepaymentScheduleEntry extends Equatable {
  final int installmentNumber;
  final DateTime dueDate;
  final double amount;

  const RepaymentScheduleEntry({
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
  });

  @override
  List<Object?> get props => [installmentNumber, dueDate, amount];
}
