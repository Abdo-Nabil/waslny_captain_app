import 'package:equatable/equatable.dart';

import './trip_model.dart';

class CaptainModel extends Equatable {
  final String? captainId;
  final String email;
  final String password;
  final String name;
  final String phone;
  final String age;
  final String gender;
  final String carModel;
  final String plateNumber;
  final String carColor;
  final String productionDate;
  final String numOfPassengers;
  final String? ratting;
  final List<TripModel>? trips;
  const CaptainModel({
    this.captainId,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.age,
    required this.gender,
    required this.carModel,
    required this.plateNumber,
    required this.carColor,
    required this.productionDate,
    required this.numOfPassengers,
    this.ratting,
    this.trips,
  });

  @override
  List<Object?> get props => [
        captainId,
        email,
        password,
        name,
        phone,
        age,
        gender,
        carModel,
        plateNumber,
        carColor,
        productionDate,
        numOfPassengers,
        ratting,
        trips,
      ];

  factory CaptainModel.fromJson(Map<String, dynamic> map) {
    //
    final List<TripModel> trips = [];
    if (map['trips'] != null) {
      map['trips'].forEach((element) {
        trips.add(TripModel.fromJson(element));
      });
    }
    return CaptainModel(
      captainId: map['captainId'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      phone: map['phone'],
      age: map['age'],
      gender: map['gender'],
      carModel: map['carModel'],
      plateNumber: map['plateNumber'],
      carColor: map['carColor'],
      productionDate: map['productionDate'],
      numOfPassengers: map['numOfPassengers'],
      ratting: map['ratting'],
      trips: trips,
    );
  }
  //
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> listOfMaps = [];

    if (trips != null) {
      for (TripModel element in trips!) {
        listOfMaps.add(element.toJson());
      }
    }
    return {
      'captainId': captainId,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'age': age,
      'gender': gender,
      'carModel': carModel,
      'plateNumber': plateNumber,
      'carColor': carColor,
      'productionDate': productionDate,
      'numOfPassengers': numOfPassengers,
      'ratting': ratting,
      'trips': listOfMaps,
    };
  }

  CaptainModel copyWith({
    String? captainId,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? age,
    String? gender,
    String? carModel,
    String? plateNumber,
    String? carColor,
    String? productionDate,
    String? numOfPassengers,
    List<TripModel>? trips,
  }) {
    return CaptainModel(
      captainId: captainId ?? this.captainId,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      carModel: carModel ?? this.carModel,
      plateNumber: plateNumber ?? this.plateNumber,
      carColor: carColor ?? this.carColor,
      productionDate: productionDate ?? this.productionDate,
      numOfPassengers: numOfPassengers ?? this.numOfPassengers,
      trips: trips ?? this.trips,
    );
  }
}
