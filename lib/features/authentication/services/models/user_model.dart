import 'package:equatable/equatable.dart';

import './trip_model.dart';

class UserModel extends Equatable {
  final String userId;
  final String phoneNumber;
  final String? name;
  final List<TripModel>? trips;

  const UserModel({
    required this.userId,
    required this.phoneNumber,
    this.name,
    this.trips,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        phoneNumber,
        trips,
      ];

  factory UserModel.fromJson(Map<String, dynamic> map) {
    //
    final List<TripModel> trips = [];
    if (map['trips'] != null) {
      map['trips'].forEach((element) {
        trips.add(TripModel.fromJson(element));
      });
    }
    return UserModel(
      userId: map['userId'],
      phoneNumber: map['phoneNumber'],
      name: map['name'],
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
      'userId': userId,
      'phoneNumber': phoneNumber,
      'name': name,
      'trips': listOfMaps,
    };
  }
}

// UserModel({
//   required String userId,
//   required String phoneNumber,
//   String? name,
//   this.tripsModel,
// }) : super(
//         userId: userId,
//         phoneNumber: phoneNumber,
//         name: name,
//         tripsEntity: tripsModel != null
//             ? List<TripEntity>.generate(
//                 tripsModel.length,
//                 (index) => TripEntity(
//                     tripId: tripsModel[index].tripId,
//                     userId: tripsModel[index].userId,
//                     driverId: tripsModel[index].driverId,
//                     source: tripsModel[index].source,
//                     destination: tripsModel[index].destination,
//                     cost: tripsModel[index].cost,
//                     date: tripsModel[index].date,
//                     time: tripsModel[index].time,
//                     estimatedTime: tripsModel[index].estimatedTime,
//                     pathArray: tripsModel[index].pathArray,
//                     rating: tripsModel[index].rating),
//               )
//             : null,
//       );
