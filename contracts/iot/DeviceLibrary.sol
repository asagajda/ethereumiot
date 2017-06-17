import "EternalStorage.sol";

library DeviceLibrary {

  function getDevicesCount(address _storageContract) constant returns(uint256)
  {
    return EternalStorage(_storageContract).getUIntValue(sha3("DevicesCount"));
    //TODO: or return 0?
  }

  function getTurnedOffDevicesCount(address _storageContract) constant returns(uint256)
  {
    return EternalStorage(_storageContract).getUIntValue(sha3("OffDevicesCount"));
    //TODO: or return 0
  }

  function getTurnedOnDevicesCount(address _storageContract) constant returns(uint256)
  {
    return EternalStorage(_storageContract).getUIntValue(sha3("DevicesCount")) -
    EternalStorage(_storageContract).getUIntValue(sha3("OnDevicesCount"));
    //TODO: or return 0
  }

  function addDevice(address _storageContract, address _address, bytes32 _pubkey, address _owner)
  {
    //TODO: check collision
    var idx = getDevicesCount(_storageContract);
    EternalStorage(_storageContract).setAddressValue(sha3("device_address_", idx), _address);
    EternalStorage(_storageContract).setBytes32Value(sha3("device_pubkey_", idx), _pubkey);
    EternalStorage(_storageContract).setAddressValue(sha3("device_owner_", idx), _address);
    EternalStorage(_storageContract).setBooleanValue(sha3("device_active_", idx), true);
    EternalStorage(_storageContract).setUIntValue(sha3("DevicesCount"), idx + 1);
  }

  function switchOffDeviceById(address _storageContract, uint idx) returns (bool result)
  {
    var addr = EternalStorage(_storageContract).getAddressValue(sha3("device_address_", idx));
    if (addr == 0x0)
    {
      return false;
    }
    EternalStorage(_storageContract).setBooleanValue(sha3("device_active_", idx), false);
    var off_devices_count = EternalStorage(_storageContract).getUIntValue(sha3("OffDevicesCount"));
    EternalStorage(_storageContract).setUIntValue(sha3("OffDevicesCount"), off_devices_count + 1);
    return true;
  }

  function switchOnDeviceById(address _storageContract, uint idx) returns (bool result)
  {
    var addr = EternalStorage(_storageContract).getAddressValue(sha3("device_address_", idx));
    if (addr == 0x0)
    {
      return false;
    }
    EternalStorage(_storageContract).setBooleanValue(sha3("device_active_", idx), true);
    var off_devices_count = EternalStorage(_storageContract).getUIntValue(sha3("OffDevicesCount"));
    EternalStorage(_storageContract).setUIntValue(sha3("OffDevicesCount"), off_devices_count - 1);
    return true;
  }

  function getDeviceById(address _storageContract, uint _idx) constant
    returns(address device_address, bytes32 device_pubkey, address device_owner, bool device_active)
  {
    var addr = EternalStorage(_storageContract).getAddressValue(sha3("device_address_", idx));
    if (addr == 0x0)
    {
      return (0x0, 0x0, 0x0, 0x0);
    }
    var pubkey = EternalStorage(_storageContract).getBytes32Value(sha3("device_pubkey_", idx));
    var owner = EternalStorage(_storageContract).getAddressValue(sha3("device_owner_", idx));
    var active = EternalStorage(_storageContract).setBooleanValue(sha3("device_active_", idx));
    return (addr, pubkey, owner, active);
  }

  function updateDeviceById(address _storageContract, uint idx, address _address, bytes32 _pubkey, address _owner) returns (bool result)
  {
    var addr = EternalStorage(_storageContract).getAddressValue(sha3("device_address_", idx));
    if (addr == 0x0)
    {
      return (false);
    }
    EternalStorage(_storageContract).setAddressValue(sha3("device_address_", idx), _address);
    EternalStorage(_storageContract).setBytes32Value(sha3("device_pubkey_", idx), _pubkey);
    EternalStorage(_storageContract).setAddressValue(sha3("device_owner_", idx), _address);
    EternalStorage(_storageContract).setBooleanValue(sha3("device_active_", idx), true);
    return true;
  }

}
