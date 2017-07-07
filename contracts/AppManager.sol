pragma solidity ^0.4.4;

import "./BaseClasses.sol";
import "./DeviceManager.sol";

// The application manager
 /*a = appManagerContract.addDevice("0x4d4be4a4526f1cfe2eee78c993626922407b7bf5", 123, "0x22db9bac1ef521aea55b6aa5549de009de8fd8a9",{from:ETHEREUM_CLIENT.eth.defaultAccount, gas:3000000,}, function(e,result){console.log(result)});*/
contract AppManager is DougEnabled {

    // App owner
    address owner;

    // Constructor
    function AppManager() {
        owner = msg.sender;
    }

    function addDevice(address device_address, bytes32 device_pubkey, address device_owner)
    public returns (uint256 idx) {
      // Getting current DeviceManager contract from Doug
      var deviceManager = ContractProvider(DOUG).contracts('DeviceManager');

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (deviceManager == 0x0)
      {
        return 0;
      }
      idx = DeviceManager(deviceManager).addDevice(device_address, device_pubkey, device_owner);
    }

    function getDevicesCount() constant public returns(uint256)
    {
      // Getting current DeviceManager contract from Doug
      var deviceManager = ContractProvider(DOUG).contracts('DeviceManager');

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (deviceManager == 0x0)
      {
        throw;
      }

      return DeviceManager(deviceManager).getDevicesCount();
    }

    function getDeviceById(uint idx) constant public
    returns(address device_address, bytes32 device_pubkey, address device_owner, bool device_active){
      // Getting current DeviceManager contract from Doug
      var deviceManager = ContractProvider(DOUG).contracts('DeviceManager');

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (deviceManager == 0x0)
      {
        return (0x0, 0, 0x0, false);
      }

      // Diving to next managing level
      return DeviceManager(deviceManager).getDeviceById(idx);
    }

    function switchOffDeviceById(uint idx) returns (bool result)
    {
      // Getting current DeviceManager contract from Doug
      var deviceManager = ContractProvider(DOUG).contracts('DeviceManager');

      if (deviceManager == 0x0)
      {
        return false;
      }

      return DeviceManager(deviceManager).switchOffDeviceById(idx);
    }

    function switchOnDeviceById(uint idx) returns (bool result)
    {
      // Getting current DeviceManager contract from Doug
      var deviceManager = ContractProvider(DOUG).contracts('DeviceManager');

      if (deviceManager == 0x0)
      {
        return false;
      }

      return DeviceManager(deviceManager).switchOnDeviceById(idx);
    }

}
