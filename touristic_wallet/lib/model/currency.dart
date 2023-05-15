class Currency {
  int? id;
  final String code;
  final String name;
  final String type;
  final String icon;

  Currency(
      this.code,
      this.name,
      this.type,
      this.icon,
      );

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'type': type,
      'icon': icon,
    };
  }
}
