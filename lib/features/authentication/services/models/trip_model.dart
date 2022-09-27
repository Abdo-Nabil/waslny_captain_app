import 'package:equatable/equatable.dart';

class TripModel extends Equatable {
  final String tripId;
  final String userId;
  final String driverId;
  final String source;
  final String destination;
  final double cost;
  final String date;
  final String time;
  final String estimatedTime;
  final List pathArray;
  final double rating;

  const TripModel({
    required this.tripId,
    required this.userId,
    required this.driverId,
    required this.source,
    required this.destination,
    required this.cost,
    required this.date,
    required this.time,
    required this.estimatedTime,
    required this.pathArray,
    required this.rating,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        tripId,
        userId,
        driverId,
        source,
        destination,
        cost,
        date,
        time,
        estimatedTime,
        pathArray,
        rating,
      ];
  //

  factory TripModel.fromJson(Map<String, dynamic> map) {
    return TripModel(
      tripId: map['tripId'],
      userId: map['userId'],
      driverId: map['driverId'],
      source: map['source'],
      destination: map['destination'],
      cost: map['cost'],
      date: map['date'],
      time: map['time'],
      estimatedTime: map['estimatedTime'],
      pathArray: map['pathArray'],
      rating: map['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'userId': userId,
      'driverId': driverId,
      'source': source,
      'destination': destination,
      'cost': cost,
      'date': date,
      'time': time,
      'estimatedTime': estimatedTime,
      'pathArray': pathArray,
      'rating': rating,
    };
  }
}

// TripModel({
//   required String tripId,
//   required String userId,
//   required String driverId,
//   required String source,
//   required String destination,
//   required double cost,
//   required String date,
//   required String time,
//   required String estimatedTime,
//   required List pathArray,
//   required double rating,
// }) : super(
//         tripId: tripId,
//         userId: userId,
//         driverId: driverId,
//         source: source,
//         destination: destination,
//         cost: cost,
//         date: date,
//         time: time,
//         estimatedTime: estimatedTime,
//         pathArray: pathArray,
//         rating: rating,
//       );
