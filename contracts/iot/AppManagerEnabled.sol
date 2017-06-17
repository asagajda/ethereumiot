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
