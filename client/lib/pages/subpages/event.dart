import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:soul_connection/constants/constants.dart';
import 'package:soul_connection/models/event.module.dart';
import 'package:soul_connection/pages/subpages/widgets/calandar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMap extends StatefulWidget {
  final LatLng startPosition;
  final List<LatLng> markersData;

  const CustomMap({
    super.key,
    required this.startPosition,
    required this.markersData,
  });

  @override
  CustomMapState createState() => CustomMapState();
}

class CustomMapState extends State<CustomMap> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    setState(() {
      _markers = widget.markersData.map((markerPosition) {
        EventModel event = allEvents.firstWhere(
          (element) =>
              element.locationX == markerPosition.latitude.toString() &&
              element.locationY == markerPosition.longitude.toString(),
          orElse: () {
            return EventModel(
              id: 0,
              duration: 1,
              type: '',
              maxParticipants: 0,
              name: 'No event',
              date: '00-00-0000',
              locationName: 'No location',
              locationX: '0',
              locationY: '0',
            );
          },
        );
        return Marker(
          markerId: MarkerId(markerPosition.toString()),
          position: markerPosition,
          infoWindow: InfoWindow(
            title: '${event.name}\nMax participants: ${event.maxParticipants}',
            snippet: '${event.locationName}\n${DateFormat('dd MMMM yyyy').format(DateFormat('dd-MM-yyyy').parse(event.date))}',
          ),
        );
      }).toSet();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.startPosition,
        zoom: 12.0,
      ),
      markers: _markers,
    );
  }
}

class CustomMapBoxPage extends StatelessWidget {
  final List<LatLng> allEvents;
  const CustomMapBoxPage({super.key, required this.allEvents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.8,
              height: MediaQuery.of(context).size.height / 1.5,
              child: CustomMap(
                startPosition: const LatLng(47.21, -1.55),
                markersData: allEvents,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  double x = double.parse(allEvents.first.locationX);
  double y = double.parse(allEvents.first.locationY);

  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dh(context),
      width: dw(context),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: dh(context) / 2,
              width: dw(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xffeaeef6), width: 2),
              ),
              padding: const EdgeInsets.all(18),
              child: CalandarPage(
                callbackEvent: (p0) {
                  setState(() {
                    x = double.parse(p0.locationX);
                    y = double.parse(p0.locationY);
                  });
                  key = GlobalKey();
                },
              ),
            ),
            sh(20),
            Container(
              height: dh(context) / 1.5,
              width: dw(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xffeaeef6), width: 2),
              ),
              padding: const EdgeInsets.all(18),
              child: CustomMap(
                key: key,
                startPosition: LatLng(x, y),
                markersData: [
                  LatLng(x, y),
                  for (var marker in allEvents)
                    LatLng(
                      double.parse(marker.locationX),
                      double.parse(marker.locationY),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
