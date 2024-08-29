class CarType {
  String name;
  int capacity;
  double price;
  String desc;
  int id;

  CarType({
    required this.name,
    required this.capacity,
    required this.price,
    required this.desc,
    required this.id,
  });

  factory CarType.fromJson(Map<String, dynamic> json) {
    return CarType(
      name: json['name'],
      capacity: json['capacity'],
      price: json['price'],
      desc: json['desc'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'capacity': capacity,
      'price': price,
      'desc': desc,
      'id': id,
    };
  }
}
