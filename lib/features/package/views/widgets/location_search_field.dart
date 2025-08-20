import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../core/constants/widgets/print_util.dart';
import '../cubit/pickup_address_cubit.dart';

class LocationSearchField extends StatelessWidget {
  const LocationSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TypeAheadField<Map<String, dynamic>>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textController,
            decoration: InputDecoration(
              hintText: "search_for_location".tr(context),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              suffixIcon: textController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        textController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.orange, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.length < 3) return [];
            return await fetchSuggestions(pattern);
          },
          noItemsFoundBuilder: (context) {
            return Container(
              height: 50,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                'no_results_found'.tr(context),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            );
          },
          errorBuilder: (context, error) {
            String errorMessage;

            if (error is http.ClientException) {
              errorMessage = 'connection_error'.tr(context);
            } else {
              errorMessage = "something_went_wrong".tr(context);
            }

            PrintUtil.debug(error.toString());
            return Container(
              height: 50,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            );
          },
          suggestionsBoxDecoration: const SuggestionsBoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            color: Colors.white,
            elevation: 4,
            constraints: BoxConstraints(maxHeight: 300),
          ),
          loadingBuilder: (context) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          keepSuggestionsOnLoading: false,
          hideOnEmpty: true,
          hideOnError: true,
          hideOnLoading: true,
          itemBuilder: (context, suggestion) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.4)),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        suggestion['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          onSuggestionSelected: (suggestion) async {
            textController.text = suggestion['description'];
            final placeId = suggestion['place_id'];
            final Map<String, dynamic> location =
                await fetchPlaceDetails(placeId);
            location['description'] = suggestion['description'];
            PrintUtil.debug("Selected location: $location");
            context.read<PickupAddressCubit>().updateLocation(
                  LatLng(location['lat'], location['lng']),
                );
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchSuggestions(String input) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyB8sZjSpTijQt3lC9CoIMr0F1izwoJrXjM&types=geocode&components=country:eg');
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        return List<Map<String, dynamic>>.from(json['predictions']);
      }
    } catch (e) {
      PrintUtil.error("Error fetching suggestions: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyB8sZjSpTijQt3lC9CoIMr0F1izwoJrXjM');
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final location = json['result']['geometry']['location'];
        return {'lat': location['lat'], 'lng': location['lng']};
      }
    } catch (e) {
      PrintUtil.error("Error fetching place details: $e");
    }
    return {'lat': 0.0, 'lng': 0.0};
  }
}
