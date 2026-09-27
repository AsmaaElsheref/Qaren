import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/features/services/taxi/data/models/carRental/car_rental_search_result_model.dart';

void main() {
  group('AI search route parsing', () {
    test('reads the trip coordinates from data, not the nearby car', () {
      final response = CarRentalSearchResultModel.fromJson({
        'status': 'success',
        'dataMode': 'real',
        'data': {
          'cars': [
            {
              'id': 'bolt-saudi_standard_sa',
              'lat': 31.2617352,
              'lng': 30.0066878,
              'price': 32,
              'fare_id': 'mock_fare_bolt-saudi_standard',
            },
          ],
          'meta': {'total': 1},
          'ai_assistant': {
            'understood_prompt': 'airport',
            'destination_name': 'Suggested destination',
            'parsed_parameters': {
              'pickup': {'lat': 31.2607352, 'lng': 30.0056878},
              'destination': {'lat': 31.2757352, 'lng': 30.0206878},
            },
          },
        },
      });

      expect(response.status, isTrue);
      expect(response.offers.single.carId, 'bolt-saudi_standard_sa');
      expect(
        response.parsedParameters?.pickup,
        const LatLng(31.2607352, 30.0056878),
      );
      expect(
        response.parsedParameters?.dropoff,
        const LatLng(31.2757352, 30.0206878),
      );
      expect(
        response.parsedParameters?.destinationName,
        'Suggested destination',
      );
    });

    test('continues accepting the legacy flat AI response', () {
      final response = CarRentalSearchResultModel.fromJson({
        'status': true,
        'data': [],
        'ai_assistant': {
          'destination_name': 'Airport',
          'parsed_parameters': {
            'pickup_lat': '30.0444',
            'pickup_lng': '31.2357',
            'dropoff_lat': 30.05,
            'dropoff_lng': 31.24,
          },
        },
      });

      expect(response.parsedParameters?.pickup, const LatLng(30.0444, 31.2357));
      expect(response.parsedParameters?.dropoff, const LatLng(30.05, 31.24));
      expect(response.parsedParameters?.destinationName, 'Airport');
    });

    test('does not invent a route when AI metadata is absent', () {
      final response = CarRentalSearchResultModel.fromJson({
        'status': 'success',
        'data': {
          'cars': [
            {'id': 'car-1', 'lat': 31.2617352, 'lng': 30.0066878},
          ],
        },
      });

      expect(response.status, isTrue);
      expect(response.offers, hasLength(1));
      expect(response.parsedParameters, isNull);
    });

    test('accepts string coordinates and leaves an incomplete point unset', () {
      final response = CarRentalSearchResultModel.fromJson({
        'status': 'success',
        'data': {
          'cars': [],
          'ai_assistant': {
            'parsed_parameters': {
              'pickup': {'lat': '31.2607352', 'lng': '30.0056878'},
              'destination': {'lat': 'invalid', 'lng': '30.0206878'},
            },
          },
        },
      });

      expect(
        response.parsedParameters?.pickup,
        const LatLng(31.2607352, 30.0056878),
      );
      expect(response.parsedParameters?.dropoff, isNull);
    });
  });
}
