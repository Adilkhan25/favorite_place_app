import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  final FocusNode _focusNode = FocusNode();

  void _onMapTap(LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
      _searchResults.clear();
    });
  }

  void _saveLocation() {
    if (selectedLocation != null) {
      Navigator.pop(context, selectedLocation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a location!"),
      ));
    }
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5'));
      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        setState(() {
          _searchResults = results;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  void _selectSearchResult(dynamic result) {
    final lat = double.parse(result['lat']);
    final lon = double.parse(result['lon']);
    setState(() {
      selectedLocation = LatLng(lat, lon);
      _mapController.move(selectedLocation!, 15.0);
      _searchResults.clear();
    });
  }

  void _cancelSearch() {
    setState(() {
      _searchController.clear(); // Clear the text
      _searchResults.clear(); // Clear search results
      selectedLocation = null; // Optionally clear selected location
    });
    _focusNode.unfocus(); // Hide keyboard when canceling search
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // FlutterMap as the background
          SizedBox.expand(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(37.7749, -122.4194),
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  _onMapTap(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: selectedLocation != null
                      ? [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: selectedLocation!,
                            child: const Icon(Icons.location_pin,
                                color: Colors.red, size: 40),
                          ),
                        ]
                      : [],
                ),
              ],
            ),
          ),
          // Search bar and results
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: "Search location",
                    suffixIcon: _focusNode.hasFocus
                        ? IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: _cancelSearch,
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _searchLocation,
                          ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => _searchLocation(),
                ),
              ),
              if (_searchResults.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        _searchResults.length > 4 ? 4 : _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            leading: CircleAvatar(
                              radius: 18,
                              child: Icon(
                                Icons.location_on,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            title: Text(
                              result['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            subtitle: Text(
                              result['display_name'],
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                            onTap: () => _selectSearchResult(result),
                            trailing: Transform.rotate(
                              angle: -0.785398,
                              child: Icon(
                                Icons.arrow_upward,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.onSurface,
                          )
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
