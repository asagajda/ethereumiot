// The bank database
contract DeviceDb is DougEnabled {

  using ProposalsLibrary for address;
  address public eternalStorage;

  function Organisation(address _eternalStorage) {
    eternalStorage = _eternalStorage;
  }

  function addProposal(bytes32 _name)
  {
    eternalStorage.addProposal(_name);
  }

    /*struct DeviceParams {
      uint pubkey;
      uint meta;
    }

    // ownermapping
    mapping (address => DeviceParams) devices;

    function deposit(address addr) returns (bool res) {
        if(DOUG != 0x0){
            address bank = ContractProvider(DOUG).contracts("bank");
            if (msg.sender == bank ){
                balances[addr] += msg.value;
                return true;
            }
        }
        // Return if deposit cannot be made.
        msg.sender.send(msg.value);
        return false;
    }

    function withdraw(address addr, uint amount) returns (bool res) {
        if(DOUG != 0x0){
            address bank = ContractProvider(DOUG).contracts("bank");
            if (msg.sender == bank ){
                uint oldBalance = balances[addr];
                if(oldBalance >= amount){
                    msg.sender.send(amount);
                    balances[addr] = oldBalance - amount;
                    return true;
                }
            }
        }
        return false;
    }*/

}
