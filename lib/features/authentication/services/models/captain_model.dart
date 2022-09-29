import 'package:equatable/equatable.dart';

import './trip_model.dart';

class CaptainModel extends Equatable {
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
}
