import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screening_task_ci/viewmodel/device_info_view_model.dart';


class DeviceInfoView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final deviceInfoViewModel = Provider.of<DeviceInfoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Device Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Installed apps',
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10,),
            FutureBuilder(
              future: deviceInfoViewModel.fetchInstalledApps(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                else {
                  return Expanded(flex: 9,
                    child: ListView.separated(
                      separatorBuilder: (context,i)=>Divider(),
                      itemCount: deviceInfoViewModel.installedApps.length,
                      itemBuilder: (context, index) {
                        return Text("${index+1}."+deviceInfoViewModel.installedApps[index],style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),);
                      },
                    ),
                  );
                }
              }
            ),
            SizedBox(height: 10,),
            Text(
              'Battery Percentage',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10,),
            Expanded(flex: 1,
              child: Consumer<DeviceInfoViewModel>(
                builder: (context,viewModel,child) {
                  final _batteryPercentage = viewModel.batteryLevel;
                  return Row(
                    children: [
                      /// progress indicator for indicating battery level with color based on percentage
                      Expanded(child: LinearProgressIndicator(value: double.parse(_batteryPercentage.toString()),color:_batteryPercentage <25 ? Colors.redAccent :_batteryPercentage <50 ? Colors.orange : Colors.green,)),
                      SizedBox(width: 2,),
                      Text(
                        '$_batteryPercentage%',
                        style: TextStyle(fontSize: 23,color:_batteryPercentage <25 ? Colors.redAccent :_batteryPercentage <50 ? Colors.orange : Colors.green,fontWeight: FontWeight.w500 ),
                      ),
                    ],
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}