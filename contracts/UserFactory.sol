pragma solidity 0.4.8;

import './User.sol';
import './Owned.sol';
import './Storage.sol';
import './UserProxy.sol';
import './EventsHistoryAndStorageUser.sol';

contract UserFactory is EventsHistoryAndStorageUser, Owned{
    StorageInterface.Mapping userRoles;

	event UserCreated(address indexed user, address proxy);

    function UserFactory (Storage _storage, bytes32 _crate) EventsHistoryAndStorageUser(_store, _crate) {
        userRoles.init('userRoles');
    }

    function createUserWithProxyAndRecovery(Storage _storage) {
        UserProxy proxy = new UserProxy();
        User user = new User(_storage, 'User');
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