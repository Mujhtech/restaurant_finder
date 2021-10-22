import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant_finder/constant.dart';
import 'package:restaurant_finder/controller/auth_controller.dart';

final places =
    GoogleMapsPlaces(apiKey: "AIzaSyAHlx6_8mI3vfKbkRS6Qz0J1kmNjA3mPr0");

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> markers = {};

  late Future<Position> _currentLocation;

  @override
  void initState() {
    super.initState();
    _currentLocation = Geolocator.getCurrentPosition();
  }

  Future<void> _retrieveNearbyRestaurants(LatLng _userLocation) async {
    try {
      PlacesSearchResponse _response = await places.searchNearbyWithRadius(
          Location(lat: _userLocation.latitude, lng: _userLocation.longitude),
          5000,
          keyword: "restaurant");
      for (final data in _response.results) {
        print(data.name);
      }
      Set<Marker> _restaurantMarkers = _response.results
          .map((result) => Marker(
              markerId: MarkerId(result.name),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              infoWindow: InfoWindow(
                  title: result.name,
                  snippet:
                      "Ratings: " + (result.rating?.toString() ?? "Not Rated")),
              position: LatLng(result.geometry!.location.lat,
                  result.geometry!.location.lng)))
          .toSet();

      setState(() {
        markers.addAll(_restaurantMarkers);
      });
    } catch (err) {
      print('error');
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final user = watch(authControllerProvider);
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(children: [
          FutureBuilder<Position>(
              future: _currentLocation,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Failed to get user location."));
                  } else {
                    Position? snapshotData = snapshot.data;
                    LatLng _userLocation =
                        LatLng(snapshotData!.latitude, snapshotData.longitude);
                    return GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _userLocation,
                        zoom: 12,
                      ),
                      markers: markers
                        ..add(Marker(
                            markerId: const MarkerId("User Location"),
                            infoWindow:
                                const InfoWindow(title: "User Location"),
                            position: _userLocation)),
                    );
                  }
                }
                return const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Constant.purpleColor)),
                  ),
                );
              }),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                          color: Constant.grayColor,
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text(
                              user.fbUser!.email![0],
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ))),
                  InkWell(
                    onTap: () async {
                      try {
                        final res = await _currentLocation;
                        await _retrieveNearbyRestaurants(
                            LatLng(res.latitude, res.longitude));
                        print(markers);
                      } catch (err) {
                        print(err.toString());
                      }
                    },
                    child: Icon(
                      Icons.nightlight_round,
                      size: 30,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              //margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Center(
                child: Text(
                  'No Restaurant found',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
          )
        ]),
      );
    });
  }
}
