// The application manager
contract AppManager is DougEnabled {

    // App owner
    address owner;

    // Constructor
    function AppManager() {
        owner = msg.sender;
    }

    function addDevice(address device_address, bytes32 device_pubkey) returns (bool result) {
      // Getting current DeviceManager contract from Doug
      deviceManager = ContractProvider(DOUG).contracts('DeviceManager'))

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (deviceManager == 0x0)
      {
        return false;
      }

      // Diving to next managing level
      bool success = DeviceManager(deviceManager).addDevice(address device_address, bytes32 device_pubkey);

      return success;
    }

    function addOffer(address device_address, int32 value, string meta) returns (bool result) {
      // Getting current DeviceManager contract from Doug
      offersManager = ContractProvider(DOUG).contracts('OffersManager'))

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (offersManager == 0x0)
      {
        return false;
      }

      // Diving to next managing level
      bool success = OffersManager(offersManager).addOffer(address device_address, int32 value, string meta);

      return success;
    }

    function delDevice(address deviceAddress) returns (bool result) {
      // Getting current DeviceManager contract from Doug
      deviceManager = ContractProvider(DOUG).contracts('DeviceManager'))

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (deviceManager == 0x0)
      {
        return false;
      }

      // Diving to next managing level
      bool success = DeviceManager(deviceManager).delDevice(address device_address);

      return success;
    }

    function delOffer(address offer_address) returns (bool result) {
      // Getting current DeviceManager contract from Doug
      offersManager = ContractProvider(DOUG).contracts('OffersManager'))

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (offersManager == 0x0)
      {
        return false;
      }

      // Diving to next managing level
      bool success = OffersManager(offersManager).delOffer(address offer_address);

      return success;
    }


    // TODO
    /*function addDeviceType() {}
      function delDeviceType() {}*/

    // TODO
    /*function getAllDevices() static {}
    function getAllOffers() static {}
    function getAllDevicesByUser() static {}
    function getAllOffersByRegion() static {}*/

    //--------------------review-------------------------------
    // Set the permissions for a given address.
    /*function setPermission(address addr, uint8 permLvl) returns (bool res) {
        if (msg.sender != owner){
            return false;
        }
        address perms = ContractProvider(DOUG).contracts("perms");
        if ( perms == 0x0 ) {
            return false;
        }
        return Permissions(perms).setPermission(addr,permLvl);
    }*/
    //---------------------------------------------------------
}
