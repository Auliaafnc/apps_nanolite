class Customer {
  final String? department;
  final String? employee;
  final String? name;
  final String? categoryName;
  final String? phone;
  final String? email;
  final String? alamat; // full address
  final String? maps;   // gmaps link
  final String? programName;
  final int programPoint;
  final int rewardPoint;
  final String? image;     // full URL
  final String? status;    // Pending/Disetujui/Ditolak
  final String? createdAt; // dd/MM/yyyy
  final String? updatedAt; // dd/MM/yyyy

  Customer({
    this.department,
    this.employee,
    this.name,
    this.categoryName,
    this.phone,
    this.email,
    this.alamat,
    this.maps,
    this.programName,
    this.programPoint = 0,
    this.rewardPoint = 0,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    int _asInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return Customer(
      department: json['department']?.toString(),
      employee: json['employee']?.toString(),
      name: json['name']?.toString(),
      categoryName: json['category_name']?.toString(),
      phone: json['phone']?.toString(),
      email: (json['email'] == null || json['email'].toString().isEmpty)
          ? null
          : json['email'].toString(),
      alamat: json['alamat']?.toString(),
      maps: json['maps']?.toString(),
      programName: json['customer_program_name']?.toString(),
      programPoint: _asInt(json['program_point']),
      rewardPoint: _asInt(json['reward_point']),
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'department': department,
        'employee': employee,
        'name': name,
        'category_name': categoryName,
        'phone': phone,
        'email': email,
        'alamat': alamat,
        'maps': maps,
        'customer_program_name': programName,
        'program_point': programPoint,
        'reward_point': rewardPoint,
        'image': image,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
