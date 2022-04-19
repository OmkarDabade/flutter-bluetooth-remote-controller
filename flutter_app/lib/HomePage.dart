import 'dart:typed_data';
import 'camera_component.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  // Get the instance of the Bluetooth
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  List<BluetoothDevice> _devicesList = [];
  bool isDisconnecting = false;
  bool _connected = false;
  BluetoothDevice? _device;

  // To track whether the device is still connected to Bluetooth
  bool get isConnected =>
      connection != null && (connection?.isConnected ?? false);

  @override
  void initState() {
    _setPortraitModeOnly();

    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // If the Bluetooth of the device is not enabled,
    // then request permission to turn on Bluetooth
    // as the app starts up
    _enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // For retrieving the paired devices list
        _getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  void _setPortraitModeOnly() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  Future<bool> _enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      if (await FlutterBluetoothSerial.instance.requestEnable() ?? false) {
        await _getPairedDevices();
        return true;
      }
    } else if (_bluetoothState == BluetoothState.STATE_ON) {
      await _getPairedDevices();
      return true;
    }

    return false;
  }

  Future<void> _getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];

    if (_devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text(
          'NONE',
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      for (BluetoothDevice device in _devicesList) {
        items.add(DropdownMenuItem(
          child: Text(
            device.name ?? device.address,
            style: const TextStyle(color: Colors.white),
          ),
          value: device,
        ));
      }
    }
    return items;
  }

  void _connect() async {
    if (_device == null) {
      print('No device selected');
    } else {
      if (!isConnected) {
        // Trying to connect to the device using
        // its address
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;

          // Updating the device connectivity
          // status to [true]
          setState(() {
            _connected = true;
          });

          // This is for tracking when the disconnecting process
          // is in progress which uses the [isDisconnecting] variable
          // defined before.
          // Whenever we make a disconnection call, this [onDone]
          // method is fired.
          connection?.input?.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        print('Device connected');
      }
    }
  }

  void _disconnect() async {
    // Closing the Bluetooth connection
    await connection?.close();
    print('Device disconnected');

    // Update the [_connected] variable
    if (connection != null && !(connection!.isConnected)) {
      setState(() {
        _connected = false;
      });
    }
  }

  void _sendMessageToBluetooth(String val) async {
    if (connection != null) {
      connection!.output.add(Uint8List.fromList(utf8.encode(val + "\r\n")));
      await connection!.output.allSent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0XFF2e2e2e),
          actions: [
            Switch(
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                future() async {
                  if (value) {
                    // Enable Bluetooth
                    await FlutterBluetoothSerial.instance.requestEnable();
                  } else {
                    // Disable Bluetooth
                    await FlutterBluetoothSerial.instance.requestDisable();
                  }

                  // In order to update the devices list
                  await _getPairedDevices();

                  // Disconnect from any device before
                  // turning off Bluetooth
                  if (_connected) {
                    _disconnect();
                  }
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            DropdownButton<BluetoothDevice>(
              items: _getDeviceItems(),
              onChanged: (value) => setState(() => _device = value),
              value: _devicesList.isNotEmpty ? _device : null,
              dropdownColor: const Color(0XFF2e2e2e),
            ),
            ElevatedButton(
              // color: Colors.redAccent,
              onPressed: _connected ? _disconnect : _connect,
              child: Text(
                _connected ? 'Disconnect' : 'Connect',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                color: const Color(0XFF2e2e2e),
                child: const CameraComponent(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                color: const Color(0XFF2e2e2e),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ControllerButton(
                      child: const Icon(Icons.keyboard_arrow_left,
                          size: 20, color: Colors.white54),
                      onPressed: () => _sendMessageToBluetooth("3"),
                    ),
                    ControllerButton(
                      child: const Icon(Icons.keyboard_arrow_right,
                          size: 20, color: Colors.white54),
                      onPressed: () => _sendMessageToBluetooth("4"),
                    ),
                    ControllerButton(
                      child: const Icon(Icons.keyboard_arrow_up,
                          size: 20, color: Colors.white54),
                      onPressed: () => _sendMessageToBluetooth("1"),
                    ),
                    ControllerButton(
                      child: const Icon(Icons.keyboard_arrow_down,
                          size: 20, color: Colors.white54),
                      onPressed: () => _sendMessageToBluetooth("2"),
                    ),
                    ControllerButton(
                      child: const Icon(Icons.stop_circle,
                          size: 20, color: Colors.white54),
                      onPressed: () => _sendMessageToBluetooth("5"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControllerButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double borderRadius;
  // final Color color;
  const ControllerButton(
      {Key? key,
      required this.child,
      this.borderRadius = 30,
      // required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: const Color(0XFF2e2e2e),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [Color(0XFF1c1c1c), Color(0XFF383838)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0XFF1c1c1c),
            offset: Offset(5.0, 5.0),
            blurRadius: 10.0,
          ),
          BoxShadow(
            color: Color(0XFF404040),
            offset: Offset(-5.0, -5.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                colors: [Color(0XFF303030), Color(0XFF1a1a1a)]),
          ),
          child: MaterialButton(
            // color: color,
            minWidth: 0,
            onPressed: onPressed,
            shape: const CircleBorder(),
            child: child,
          ),
        ),
      ),
    );
  }
}
