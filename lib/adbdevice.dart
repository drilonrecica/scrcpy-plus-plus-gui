class ADBDevice {
  bool selected;
  final String deviceName;
  final String deviceType;

  ADBDevice(this.selected, this.deviceName, this.deviceType);

  @override
  String toString() {
    return deviceName + deviceType;
  }
}
