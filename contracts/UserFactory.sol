pragma solidity 0.4.8;

import './EventsHistoryUser.sol';
import './UserLibrary.sol';
import './UserProxy.sol';
import './Storage.sol';
import './Owned.sol';
import './User.sol';

contract UserFactory is EventsHistoryUser, Owned {
    UserLibrary userLibrary;
    // SkillLibrary skillLibrary;

	event UserCreated(address indexed user, address proxy, bytes32[] roles, bytes32[] skills);

    function createUserWithProxyAndRecovery(Storage _storage, bytes32[] _roles, bytes32[] _skills) {
        UserProxy proxy = new UserProxy();
        User user = new User(_storage, 'User');
        proxy.changeContractOwnership(user);
        user.claimContractOwnership();
        user.setUserProxy(proxy);
        _setRoles(user, _roles);
        // _setSkills(user, _skills);
        UserCreated(user, proxy, _roles, _skills);
    }

 	function setupEventsHistory(address _eventsHistory) onlyContractOwner() returns(bool) {
        if (getEventsHistory() != 0x0) {
            return false;
        }
        _setEventsHistory(_eventsHistory);
        return true;
    }

    function setupUserLibrary(UserLibrary _userLibrary) onlyContractOwner() returns(bool) {
        userLibrary = _userLibrary;
        return true;
    }

    // function setupSkillLibrary(SkillLibrary _skillLibrary) onlyContractOwner() returns(bool) {
    //     skillLibrary = _skillLibrary;
    //     return true;
    // }

    function _setRoles(address _user, bytes32[] _roles) internal returns(bool){
        for(uint i = 0; i < _roles.length; i++){
            userLibrary.addRole(_user, _roles[i]);
            // if (!userLibrary.addRole(_user, _roles[i])){
            //     return false;
            // }
        }
        return true;
    }


    // function _setSkills(address _user, bytes32[] _skills) internal returns(bool){
    //     for(uint i = 0; i < _skills.length; i++){
    //         skillLibrary.addSkill(_user, _roles[i]);
    //     }
    //     return true;
    // }
}