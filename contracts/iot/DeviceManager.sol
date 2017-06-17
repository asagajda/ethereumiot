contract DeviceManager is AppManagerEnabled {

  using DeviceLibrary for address;
  address public eternalStorage;

  function DeviceManager(address _eternalStorage) {
    eternalStorage = _eternalStorage;
  }

  function addDevice(address device_address, bytes32 device_pubkey, address device_pubkey)
  returns (bool result) //TODO: return id
  {
    if (!isAppManager()){
      return false;
    }
    bool success = eternalStorage.addDevice(device_address, device_pubkey);
    return success;
  }

  function switchOffDeviceById(uint256 _id) returns (bool result)
  {
    if (!isAppManager()){
      return false;
    }
    bool success = eternalStorage.switchOffDeviceById(_id);
    return success;
  }

  function switchOnDeviceById(uint256 _id) returns (bool result)
  {
    if (!isAppManager()){
      return false;
    }
    bool success = eternalStorage.switchOnDeviceById(_id);
    return success;
  }

  function getDeviceById(uint256 _id) constant
  returns(address device_address, bytes32 device_pubkey, address device_owner, bool device_active)
  {
    return eternalStorage.getDeviceById(_id);
  }

  function updateDeviceById(uint256 _id, address device_address, bytes32 device_pubkey, address device_pubkey)
  {
    eternalStorage.updateDeviceById(_id, device_address, device_pubkey, device_pubkey);
  }

}
