package com.example.steering_wheel_sim

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val eventChannel = "sensorData"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            object :
                EventChannel.StreamHandler {
                private var sensorManager: SensorManager? = null
                private var sensorEventListener: SensorEventListener? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
                    val accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
                    val gyroscope = sensorManager?.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
                    val sensorData = mutableMapOf<String, Any>()
                    sensorEventListener = object : SensorEventListener {
                        override fun onSensorChanged(p0: SensorEvent?) {
                            p0?.let {
                                when (it.sensor.type) {
                                    Sensor.TYPE_ACCELEROMETER -> {
                                        val accel = mapOf(
                                            "x" to it.values[0],
                                            "y" to it.values[1],
                                            "z" to it.values[2]
                                        )
                                        sensorData["accelerometer"] = accel
                                    }

                                    Sensor.TYPE_GYROSCOPE -> {
                                        val gyro = mapOf(
                                            "x" to it.values[0],
                                            "y" to it.values[1],
                                            "z" to it.values[2]
                                        )
                                        sensorData["gyroscope"] = gyro
                                    }
                                    else -> events?.error("SENSOR_ERR01", "Sensor not found", null)
                                }
                                events?.success(sensorData)
                            }
                        }

                        override fun onAccuracyChanged(p0: Sensor?, p1: Int) {}
                    }
                    sensorManager?.registerListener(
                        sensorEventListener,
                        accelerometer,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                    sensorManager?.registerListener(
                        sensorEventListener,
                        gyroscope,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }

                override fun onCancel(arguments: Any?) {
                    sensorManager?.unregisterListener(sensorEventListener)
                }
            })
    }
}
