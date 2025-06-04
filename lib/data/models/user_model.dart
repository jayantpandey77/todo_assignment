import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;
  final String username;
  final Address address;
  final Company company;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    required this.username,
    required this.address,
    required this.company,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'] ?? '',
      username: json['username'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      company: Company.fromJson(json['company'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'image': image,
      'username': username,
      'address': address.toJson(),
      'company': company.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    phone,
    image,
    username,
    address,
    company,
  ];
}

class Address extends Equatable {
  final String address;
  final String city;
  final String state;
  final String postalCode;

  const Address({
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'postalCode': postalCode,
    };
  }

  @override
  List<Object?> get props => [address, city, state, postalCode];
}

class Company extends Equatable {
  final String name;
  final String department;
  final String title;

  const Company({
    required this.name,
    required this.department,
    required this.title,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'department': department, 'title': title};
  }

  @override
  List<Object?> get props => [name, department, title];
}

class UserResponse extends Equatable {
  final List<User> users;
  final int total;
  final int skip;
  final int limit;

  const UserResponse({
    required this.users,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      users: (json['users'] as List)
          .map((user) => User.fromJson(user))
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [users, total, skip, limit];
}
