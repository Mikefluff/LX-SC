pragma solidity 0.4.8;

import './EventsHistoryUser.sol';
import './UserProxy.sol';
import './Storage.sol';
import './Owned.sol';
import './User.sol';

contract UserFactory is EventsHistoryUser, Owned {

	event UserCreated(address indexed user, address proxy);

    function createUserWithProxyAndRecovery(Storage _storage, bytes32 _roles, bytes32 _skills) {
        UserProxy proxy = new UserProxy();
        User user = new User(_storage, 'User');
        proxy.changeContractOwnership(user);
        user.claimContractOwnership();
        user.setUserProxy(proxy);
        UserCreated(user, proxy);
    }

 	function setupEventsHistory(address _eventsHistory) onlyContractOwner() returns(bool) {
        if (getEventsHistory() != 0x0) {
            return false;
        }
        _setEventsHistory(_eventsHistory);
        return true;
    }

}