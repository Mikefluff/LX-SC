pragma solidity 0.4.8;

import './Owned.sol';
import './EventsHistoryAndStorageUser';

contract UserFactory is EventsHistoryAndStorageUser, Owned{

	event UserCreated();

	event IdentityCreated(
        address indexed userKey,
        address proxy,
        address controller,
        address recoveryQuorum);

    mapping(address => bytes32) public userRoles;

    function CreateProxyWithControllerAndRecovery(address userKey, address[] delegates, uint longTimeLock, uint shortTimeLock) {
        UserProxy proxy = new UserProxy();

        RecoverableController controller = new RecoverableController(proxy, userKey, longTimeLock, shortTimeLock);
        proxy.transfer(controller);
        RecoveryQuorum recoveryQuorum = new RecoveryQuorum(controller, delegates);
        controller.changeRecoveryFromRecovery(recoveryQuorum);

        IdentityCreated(userKey, proxy, controller, recoveryQuorum);
        senderToProxy[msg.sender] = proxy;
    }

 	function setupEventsHistory(address _eventsHistory) onlyContractOwner() returns(bool) {
        if (getEventsHistory() != 0x0) {
            return false;
        }
        _setEventsHistory(_eventsHistory);
        return true;
    }

}