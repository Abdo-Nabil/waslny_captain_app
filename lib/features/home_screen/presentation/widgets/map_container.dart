import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../resources/colors_manager.dart';
import '../../../../resources/constants_manager.dart';
import '../../cubits/home_screen_cubit.dart';

class MapContainer extends StatefulWidget {
  const MapContainer({Key? key}) : super(key: key);

  @override
  State<MapContainer> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> {
  late GoogleMapController _mapsController;

  @override
  void dispose() {
    _mapsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: HomeScreenCubit.cairoCameraPosition,
        onMapCreated: (GoogleMapController controller) async {
          await HomeScreenCubit.getIns(context)
              .onMapCreatedCallback(controller);
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('overView'),
            color: ColorsManager.redColor,
            width: ConstantsManager.polyLineWidth,
            points: BlocProvider.of<HomeScreenCubit>(context, listen: true)
                .polyLinePointsList,
          ),
        },
        markers:
            BlocProvider.of<HomeScreenCubit>(context, listen: true).markers,
      ),
    );
  }
}
