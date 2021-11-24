import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant_finder/constant.dart';
import 'package:restaurant_finder/controller/auth_controller.dart';
import 'package:restaurant_finder/ui/models/restaurant_model.dart';

final places =
    GoogleMapsPlaces(apiKey: "");

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
  List<RestaurantModel>? restaurants;

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _currentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _retrieveNearbyRestaurants(LatLng _userLocation) async {
    try {
      PlacesSearchResponse _response = await places.searchNearbyWithRadius(
          Location(lat: _userLocation.latitude, lng: _userLocation.longitude),
          10000,
          type: "restaurant",
          keyword: "food");
      List<RestaurantModel> _restaurants = _response.results
          .map((result) => RestaurantModel(
              name: result.name,
              address: result.vicinity ?? '',
              rating: result.rating,
              image: result.photos.isNotEmpty
                  ? result.photos[0].photoReference
                  : ''))
          .toList();
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
        restaurants = _restaurants;
      });
    } catch (err) {
      //print('error');
      //print(err.toString());
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
              future: _currentLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Failed to get user location."));
                  } else {
                    Position? snapshotData = snapshot.data;
                    LatLng _userLocation =
                        LatLng(snapshotData!.latitude, snapshotData.longitude);
                    if (markers.isEmpty) {
                      _retrieveNearbyRestaurants(_userLocation);
                    }
                    return GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _userLocation,
                        zoom: 12,
                      ),
                      markers: markers
                        ..add(Marker(
                            markerId: const MarkerId("My Location"),
                            infoWindow:
                                const InfoWindow(title: "My Location"),
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
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Expanded(
                            child: AlertDialog(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: Text('Do you want to logout?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 16)),
                              actions: [
                                MaterialButton(
                                  textColor: Colors.black,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 16)),
                                ),
                                MaterialButton(
                                  textColor: Colors.black,
                                  onPressed: () async {
                                    await user.signOut();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Logout',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 16)),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: ClipRRect(
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
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    restaurants == null
                        ? Center(
                            child: Text(
                            'No Restaurant found',
                            style: Theme.of(context).textTheme.headline1,
                          ))
                        : Flexible(
                            fit: FlexFit.loose,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Expanded(
                                            child: SimpleDialog(
                                              title: Text(
                                                restaurants![index].name!,
                                              ),
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25),
                                                  child: Row(
                                                    children: [
                                                      Text('Address: ',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14)),
                                                      Text(
                                                          restaurants![index]
                                                              .address!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14)),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25),
                                                  child: Row(
                                                    children: [
                                                      Text('Reviews: ',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14)),
                                                      Text(
                                                          '${restaurants![index].rating!}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14)),
                                                    ],
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Close',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              fontSize: 16)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: RestaurantCard(
                                      name: restaurants![index].name!,
                                      address: restaurants![index].address!,
                                      image: restaurants![index].image!,
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: 10,
                                  );
                                },
                                itemCount: restaurants!.length),
                          ),
                  ],
                )),
          ),
        ]),
      );
    });
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final String address;
  final String image;
  const RestaurantCard(
      {Key? key,
      required this.name,
      required this.address,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(18))),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 30,
              color: Theme.of(context).iconTheme.color,
            ),
            Text(name,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 14))
          ]),
    );
  }
}
