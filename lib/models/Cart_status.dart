enum CartStatus {
  ACTIVE,
  CHECKED_OUT;

  static CartStatus fromString(String status) {
    return CartStatus.values.firstWhere(
          (e) => e.name == status,
      orElse: () => CartStatus.ACTIVE,
    );
  }

  String toJson() => name;
}