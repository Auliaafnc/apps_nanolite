class Customer {
  final String? department;
  final String? employee;
  final String? name;
  final String? categoryName;
  final String? phone;
  final String? email;
  final String? alamat;   // full address
  final String? maps;     // gmaps link
  final String? programName;
  final int programPoint;
  final int rewardPoint;
  final String? image;    // full URL
  final String? status;   // Pending/Disetujui/Ditolak/Active/etc.
  final String? createdAt;
  final String? updatedAt;

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

  // helper: ambil string pertama yang ada
  static String? _s(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v == null) continue;
      final s = v.toString();
      if (s.isEmpty || s == 'null') continue;
      return s;
    }
    return null;
  }

  // helper: ambil int pertama yang ada
  static int _i(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v is int) return v;
      if (v is String) {
        final p = int.tryParse(v);
        if (p != null) return p;
      }
    }
    return 0;
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      // department jarang dikirim; kalau backend belum kirim, akan null -> tampil "-"
      department: _s(json, ['department', 'department_name']),
      employee: _s(json, ['employee', 'employee_name']),
      name: _s(json, ['name']),
      categoryName: _s(json, [
        'category_name',
        'customer_category_name',
        'customer_categories_name'
      ]),
      phone: _s(json, ['phone', 'telp']),
      email: _s(json, ['email']),
      alamat: _s(json, ['alamat', 'full_address', 'address']),
      maps: _s(json, ['maps', 'gmaps_link']),
      programName:
          _s(json, ['customer_program_name', 'program_name', 'program']),
      programPoint: _i(json, ['program_point', 'jumlah_program']),
      rewardPoint: _i(json, ['reward_point']),
      image: _s(json, ['image', 'image_url']),
      status: _s(json, ['status', 'status_pengajuan']),
      createdAt: _s(json, ['created_at', 'createdAt']),
      updatedAt: _s(json, ['updated_at', 'updatedAt']),
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
