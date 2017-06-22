// Base class for contracts that are used in a doug system.
contract DougEnabled {
    address DOUG;

    function setDougAddress(address dougAddr) returns (bool result){
        // Once the doug address is set, don't allow it to be set again, except by the
        // doug contract itself.
        if(DOUG != 0x0 && msg.sender != DOUG){
            return false;
        }
        DOUG = dougAddr;
        return true;
    }

    // Makes it so that Doug is the only contract that may kill it.
    function remove(){
        if(msg.sender == DOUG){
            selfdestruct(DOUG);
        }
    }
}

// The Doug contract.
contract Doug {

    address owner;

    // This is where we keep all the contracts.
    mapping (bytes32 => address) public contracts;

    modifier onlyOwner { //a modifier to reduce code replication
        if (msg.sender == owner) {// this ensures that only the owner can access the function
            _;
        }
    }

    // Constructor
    function Doug(){
        owner = msg.sender;
    }

    // Add a new contract to Doug. This will overwrite an existing contract.
    function addContract(string name, address addr) onlyOwner returns (bool result) {
        DougEnabled de = DougEnabled(addr);
        // Don't add the contract if this does not work.
        if(!de.setDougAddress(address(this))) {
            return false;
        }
        contracts[sha3(name)] = addr;
        return true;
    }

    // Remove a contract from Doug. We could also selfdestruct if we want to.
    function removeContract(string name) onlyOwner returns (bool result) {
        if (contracts[sha3(name)] == 0x0){
            return false;
        }
        contracts[sha3(name)] = 0x0;
        return true;
    }

    function remove() onlyOwner {
        address fm = contracts["fundmanager"];
        address perms = contracts["perms"];
        address permsdb = contracts["permsdb"];
        address bank = contracts["bank"];
        address bankdb = contracts["bankdb"];

        // Remove everything.
        if(fm != 0x0){ DougEnabled(fm).remove(); }
        if(perms != 0x0){ DougEnabled(perms).remove(); }
        if(permsdb != 0x0){ DougEnabled(permsdb).remove(); }
        if(bank != 0x0){ DougEnabled(bank).remove(); }
        if(bankdb != 0x0){ DougEnabled(bankdb).remove(); }

        // Finally, remove doug. Doug will now have all the funds of the other contracts,
        // and when suiciding it will all go to the owner.
        selfdestruct(owner);
    }

    function contracts(string name) returns (address addr) {
        return contracts[sha3(name)];
    }

}


// Interface for getting contracts from Doug
contract ContractProvider {
    function contracts(string name) returns (address addr) {}
}


// Base class for contracts that only allow the fundmanager to call them.
// Note that it inherits from DougEnabled
contract AppManagerEnabled is DougEnabled {

    // Makes it easier to check that fundmanager is the caller.
    function isAppManager() constant returns (bool) {
        if(DOUG != 0x0){
            address am = ContractProvider(DOUG).contracts("AppManager");
            return msg.sender == am;
        }
        return false;
    }
}

// The application manager
contract AppManager is DougEnabled {

    // App owner
    address owner;

    // Constructor
    function AppManager() {
        owner = msg.sender;
    }

    function addDevice(address device_address, bytes32 device_pubkey, address device_owner) returns (bool result) {
      // Getting current DeviceManager contract from Doug
      var deviceManager = ContractProvider(DOUG).contracts('DeviceManager');

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (deviceManager == 0x0)
      {
        return false;
      }

      // Diving to next managing level
      bool success = DeviceManager(deviceManager).addDevice(device_address, device_pubkey, device_owner);

      return success;
    }

    function getDeviceById(uint idx)
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

    /*function addOffer(address device_address, int32 value, string meta) returns (bool result) {
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
    }*/


    // TODO: switchoff
    /*function delDevice(address device_address) returns (bool result) {
      // Getting current DeviceManager contract from Doug
      var deviceManager = ContractProvider(DOUG).contracts('DeviceManager');

      // No no need to check permissions, anyone can add device (for gas)
      // Checking deviceManager existance only
      if (deviceManager == 0x0)
      {
        return false;
      }

      // Diving to next managing level
      bool success = DeviceManager(deviceManager).delDevice(device_address);

      return success;
    }*/

    /*function delOffer(address offer_address) returns (bool result) {
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
    }*/


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

contract DeviceManager is AppManagerEnabled {

  using DeviceLibrary for address;
  address public eternalStorage;

  function DeviceManager(address _eternalStorage) {
    eternalStorage = _eternalStorage;
  }

  function addDevice(address device_address, bytes32 device_pubkey, address device_owner)
  returns (bool result) //TODO: return id
  {
    if (!isAppManager()){
      return false;
    }
    bool success = eternalStorage.addDevice(device_address, device_pubkey, device_owner);
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

  function updateDeviceById(uint256 _id, address device_address, bytes32 device_pubkey, address device_owner)
  {
    eternalStorage.updateDeviceById(_id, device_address, device_pubkey, device_owner);
  }

}


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
   returns (bool result)
  {
    //TODO: check collision
    var idx = getDevicesCount(_storageContract);
    EternalStorage(_storageContract).setAddressValue(sha3("device_address_", idx), _address);
    EternalStorage(_storageContract).setBytes32Value(sha3("device_pubkey_", idx), _pubkey);
    EternalStorage(_storageContract).setAddressValue(sha3("device_owner_", idx), _owner);
    EternalStorage(_storageContract).setBooleanValue(sha3("device_active_", idx), true);
    EternalStorage(_storageContract).setUIntValue(sha3("DevicesCount"), idx + 1);
    return true; // TODO: return id
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
    var addr = EternalStorage(_storageContract).getAddressValue(sha3("device_address_", _idx));
    if (addr == 0x0)
    {
      return (0x0, 0, 0x0, false);
    }
    var pubkey = EternalStorage(_storageContract).getBytes32Value(sha3("device_pubkey_", _idx));
    var owner = EternalStorage(_storageContract).getAddressValue(sha3("device_owner_", _idx));
    var active = EternalStorage(_storageContract).getBooleanValue(sha3("device_active_", _idx));
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


contract EternalStorage{

    mapping(bytes32 => uint) UIntStorage;

    function getUIntValue(bytes32 record) constant returns (uint){
        return UIntStorage[record];
    }

    function setUIntValue(bytes32 record, uint value)
    {
        UIntStorage[record] = value;
    }

    mapping(bytes32 => string) StringStorage;

    function getStringValue(bytes32 record) constant returns (string){
        return StringStorage[record];
    }

    function setStringValue(bytes32 record, string value)
    {
        StringStorage[record] = value;
    }

    mapping(bytes32 => address) AddressStorage;

    function getAddressValue(bytes32 record) constant returns (address){
        return AddressStorage[record];
    }

    function setAddressValue(bytes32 record, address value)
    {
        AddressStorage[record] = value;
    }

    mapping(bytes32 => bytes) BytesStorage;

    function getBytesValue(bytes32 record) constant returns (bytes){
        return BytesStorage[record];
    }

    function setBytesValue(bytes32 record, bytes value)
    {
        BytesStorage[record] = value;
    }

    mapping(bytes32 => bytes32) Bytes32Storage;

    function getBytes32Value(bytes32 record) constant returns (bytes32){
        return Bytes32Storage[record];
    }

    function setBytes32Value(bytes32 record, bytes32 value)
    {
        Bytes32Storage[record] = value;
    }

    mapping(bytes32 => bool) BooleanStorage;

    function getBooleanValue(bytes32 record) constant returns (bool){
        return BooleanStorage[record];
    }

    function setBooleanValue(bytes32 record, bool value)
    {
        BooleanStorage[record] = value;
    }

    mapping(bytes32 => int) IntStorage;

    function getIntValue(bytes32 record) constant returns (int){
        return IntStorage[record];
    }

    function setIntValue(bytes32 record, int value)
    {
        IntStorage[record] = value;
    }
}
