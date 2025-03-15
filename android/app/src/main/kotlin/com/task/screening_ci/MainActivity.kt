package com.task.screening_ci

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import android.content.pm.PackageManager


class MainActivity: FlutterActivity() {

    private val BATTERY_CHANNEL = "com.task.screening_ci/battery"
    private var batteryEventChannel: EventChannel.EventSink? = null


    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            val batteryPercentage = (level * 100) / scale
            batteryEventChannel?.success(batteryPercentage)
        }
    }


    // Overriding onCreate to configure the EventChannel properly
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        // Safely unwrap the nullable DartExecutor to use it as a BinaryMessenger
        val binaryMessenger: BinaryMessenger = flutterEngine?.dartExecutor
            ?: throw IllegalStateException("DartExecutor is null")

        // ** EventChannel for battery level updates **
        val batteryChannel = EventChannel(binaryMessenger, "com.task.screening_ci/battery")

        // Set the StreamHandler for battery level updates
        batteryChannel.setStreamHandler(object : EventChannel.StreamHandler {
            private var batteryReceiver: BroadcastReceiver? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                // Register a receiver to get battery updates
                batteryReceiver = object : BroadcastReceiver() {
                    override fun onReceive(context: Context, intent: Intent) {
                        val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                        events?.success(level)  // Send the battery level as an event
                    }
                }
                // Register the receiver for battery status updates
                val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                registerReceiver(batteryReceiver, filter)
                }

                override fun onCancel(arguments: Any?) {
                    // Unregister the receiver when the stream is canceled
                    batteryReceiver?.let {
                        unregisterReceiver(it)
                    }
                    batteryReceiver = null
                }
            })
        // ** MethodChannel for getting installed apps list **
        val appListChannel = MethodChannel(binaryMessenger, "com.task.screening_ci/installed_apps")

        // Set up the MethodChannel to get installed apps
        appListChannel.setMethodCallHandler { call, result ->
            if (call.method == "getInstalledApps") {
                val apps = getInstalledApps()  // Function to list installed apps
                result.success(apps)  // Return the list of apps to Flutter
            } else {
                result.notImplemented()  // Handle unimplemented methods
            }
        }
    }

    // Function to get a list of installed apps
    private fun getInstalledApps(): List<String> {
        val apps = mutableListOf<String>()
        val packageManager = packageManager
        val installedApplications = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)

        // Collect the package names of installed apps
        for (app in installedApplications) {
            apps.add(app.packageName)
        }
        return apps
    }
}