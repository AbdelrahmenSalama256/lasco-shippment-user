class RecentOrdersModel {
  final String id;
  final int currentStep;
  final int totalSteps;
  final String fromLocation;
  final String toLocation;
  final String fromDate;
  final String toDate;

  RecentOrdersModel({
    required this.id,
    required this.currentStep,
    required this.totalSteps,
    required this.fromLocation,
    required this.toLocation,
    required this.fromDate,
    required this.toDate,
  });
}
