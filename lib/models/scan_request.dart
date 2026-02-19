class ScanRequest {
  final String barcode;
  final String userId;
  final int quantity;

  ScanRequest({
    required this.barcode,
    required this.userId,
    this.quantity = 1, // default quantity
  });

  Map<String, dynamic> toJson() {
    return {
      "barcode": barcode,
      "userId": userId,
      "quantity": quantity,
    };
  }
}
