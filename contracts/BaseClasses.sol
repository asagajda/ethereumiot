pragma solidity ^0.4.4;

import "./Interfaces.sol";

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
