pragma solidity ^0.4.4;

import "./DeviceLibrary.sol";
import "./Doug.sol";
import "./EternalStorage.sol";

contract Fixtures {
  using DeviceLibrary for address;
  function Fixtures(address _doug, address _storage, address _am, address _dm) public {
    Doug(_doug).addContract("AppManager", _am);
    Doug(_doug).addContract("DeviceManager", _dm);
    Doug(_doug).addContract("EternalStorage", _storage);

    _storage.addDevice(0xe0076ee6a766cf6ce5090d02360232996317852c, 123, 0xe0076ee6a766cf6ce5090d02360232996317852c);
    _storage.addDevice(0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db, 456, 0x583031d1113ad414f02576bd6afabfb302140225);
  }
}
