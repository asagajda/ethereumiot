pragma solidity ^0.4.4;

import "./BaseClasses.sol";

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
    function addContract(string name, address addr) //onlyOwner
    returns (bool result) {
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

    function contracts(string name) returns (address) {
        return contracts[sha3(name)];
    }

}
