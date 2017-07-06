pragma solidity ^0.4.4;

import "./BaseClasses.sol";

contract EternalStorage is DougEnabled { // set doug enabled?

    mapping(bytes32 => uint256) UIntStorage;

    function getUIntValue(bytes32 record) constant returns (uint256){
        return UIntStorage[record];
    }

    function setUIntValue(bytes32 record, uint256 value)
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

    // Id tracking mapping

    bool constant PREV = false;
    bool constant NEXT = true;
    mapping(bytes32 =>  mapping(bool => bytes32) ) dllIndex;

    mapping(bytes32=>HashInfo) public HashInfoStorage;

    function getInfoByHash(bytes32 val) constant public returns (string table, string column, uint id)
    {
        var info = HashInfoStorage[val];
        return (info.table, info.column, info.id);
    }

    struct HashInfo {
        string table;
        string column;
        uint id;
    }

    function setInfoToHash(bytes32 _val, string table, string column, uint id)
    {
        HashInfoStorage[_val] = HashInfo(table, column, id);

        // Link the new node
        dllIndex[_val][PREV] = 0x0;
        dllIndex[_val][NEXT] = dllIndex[0x0][NEXT];

        // Insert the new node
        dllIndex[dllIndex[0x0][NEXT]][PREV] = _val;
        dllIndex[0x0][NEXT] = _val;
    }

    function getDllIndex(bytes32 hash, bool direction) constant public returns (bytes32)
    {
      return dllIndex[hash][direction];
    }
}
