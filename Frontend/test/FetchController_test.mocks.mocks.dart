import 'package:blockpark/controllers/FetchController.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

class MockFetchController extends _i1.Mock implements _i2.FetchController {
  Future<Map<String, int>> fetchStatusCounts() async {
    return <String, int>{'available': 10, 'rented': 5, 'rentingComplete': 3};
  }

  Future<List<dynamic>> fetchParkingSpacesByOwner() async {
    final List<Map<String, dynamic>> mockData = [
      {
        "dayTimes": {
          "Thursday": {
            "start": "00:00",
            "end": "16:00"
          }
        },
        "_id": "A",
        "owner": "B",
        "renter": "C",
        "address": "Karlavägen",
        "zipCode": "12345",
        "city": "Stockholm",
        "startDate": "2024-02-22T23:44:13.313Z",
        "endDate": null,
        "price": 1,
        "paymentSchedule": "weekly",
        "isGarage": true,
        "isParkingSpace": false,
        "accessibility": true,
        "largeVehicles": false,
        "status": "available",
        "review": null,
        "rating": null,
        "__v": 0
      }
    ];

    return mockData;
  }

  Future<List<dynamic>> fetchParkingSpacesByRenter() async {
    final List<Map<String, dynamic>> mockData = [
      {
        "dayTimes": {
          "Monday": {
            "start": "08:00",
            "end": "17:30"
          }
        },
        "_id": "A",
        "owner": "B",
        "renter": "C",
        "address": "Kungsgatan",
        "zipCode": "12345",
        "city": "Stockholm",
        "startDate": "2024-02-22T23:44:13.313Z",
        "endDate": null,
        "price": 1,
        "paymentSchedule": "weekly",
        "isGarage": true,
        "isParkingSpace": false,
        "accessibility": true,
        "largeVehicles": false,
        "status": "rented",
        "review": null,
        "rating": null,
        "__v": 0
      }
    ];

    return mockData;
  }
}